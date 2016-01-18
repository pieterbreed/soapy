#!/usr/bin/env racket
#lang racket

;; LOGGING SETUP

(define-logger jarvis)
(current-logger jarvis-logger)
(log-jarvis-info "Jarvis starting up...")

;; REQUIRES

(require json)
(require racket/cmdline)
(require racket/format)
(require mzlib/os)
(require "src/rkt/render.rkt"
         "src/rkt/db.rkt")

;; ENVIRONMENT CONFIGURATION

(define CONFIG_DATA
  (hash
   'WEBSERVER_PUBLIC_SCHEME "http"
   'WEBSERVER_PUBLIC_DNSNAME (gethostname)
   'WEBSERVER_PUBLIC_PORT "8080"
   'STATIC_HTML_OUTPUT (build-path 'same "output" "hugo")
   'HUGO_SRC (path->complete-path (build-path 'same "src" "hugo"))
   'ANSIBLE_SRC (path->complete-path (build-path 'same "src" "ansible"))
   'EXTRA_BINS (path->complete-path (build-path 'same "bin"))
   'PGSQL_USERNAME (getenv "USER")
   'PGSQL_DB "soapy"
   'JARVIS_RPC_PORT 4010))

(define (conf-ref s)
  (dict-ref CONFIG_DATA s))


(void (putenv "PATH" (format "~a:~a"
                       (conf-ref 'EXTRA_BINS)
                       (getenv "PATH"))))
(void (putenv "JARVIS_IPC_PORT" (number->string (conf-ref 'JARVIS_RPC_PORT))))

;; RPC operation

(define (rpc-invoke args)
  args)

(define RPCC (make-channel))

(define rpc-thread
  (thread
   (lambda ()
     (log-jarvis-debug "RPC thread starting up on port ~s..."
                       (conf-ref 'JARVIS_RPC_PORT))
     (let ([listener (tcp-listen (conf-ref 'JARVIS_RPC_PORT)
                                 4 #f ;; default values for max-waiting & re-use of port
                                 "localhost")])
       (let loop ()
         (sync (handle-evt RPCC
                           (lambda (_)
                             (tcp-close listener)
                             (log-jarvis-debug "RPC thread quitting...")))
               (handle-evt listener
                           (lambda (_)
                             (let-values ([(in out) (tcp-accept listener)])
                               (write-json (rpc-invoke (read-json in))
                                           out)
                               (close-input-port in)
                               (close-output-port out)
                               (loop))))))))))

(define (stop-rpc)
  (channel-put RPCC 'done)
  (thread-wait rpc-thread))

;; CLI INTERFACE

(define (render-proc)
  (let ([db-conn (create-db-conn
                  (conf-ref 'PGSQL_USERNAME)
                  (conf-ref 'PGSQL_DB))])
    (render-batch-files db-conn
                        (conf-ref 'HUGO_SRC))
    (render-hugo-files (conf-ref 'HUGO_SRC)
                       (format "~a://~a:~a"
                               (conf-ref 'WEBSERVER_PUBLIC_SCHEME)
                               (conf-ref 'WEBSERVER_PUBLIC_DNSNAME)
                               (conf-ref 'WEBSERVER_PUBLIC_PORT)))))

(define (deploy-proc)
  (let ([ansible-path (conf-ref 'ANSIBLE_SRC)])
    (parameterize
     ([current-directory ansible-path])
     (system*
      (find-executable-path "ansible_dynamic_inventory.rkt") "--list"))))
      ;; (find-executable-path "ansible-playbook")
      ;; "-i" "ansible_dynamic_inventory.rkt"
      ;; "deploy_web.yml"))))

(define commands
  (hash
   "noop"    (list "Does nothing"
                   (lambda _ (log-jarvis-info "noop was called :)")))
   "render"  (list "Prepares and renders the static HTML (hugo)"
                   (lambda _ (render-proc)))
   "deploy"  (list "Deploys the app stack"
                   (lambda _ (deploy-proc)))
   ;; "ansible" (list "Runs ansible-playbook with a dynamic inventory against the provided playbook."
   ;;                 (lambda args (ansible-proc args)))
   ))

(define command-params
  (command-line
   #:usage-help "noop | render"
   #:args op op))

(log-jarvis-info "Received CLI params: ~a" command-params)

(define command (first command-params))

(void
 (cond
  [(dict-has-key? commands command) (apply (second (dict-ref commands command)) (rest command-params))]
  [else (log-jarvis-error "Unknown command")
        (exit 1)]))

(stop-rpc)
