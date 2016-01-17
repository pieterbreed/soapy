#!/usr/bin/env racket
#lang racket

;; LOGGING SETUP

(define-logger jarvis)
(current-logger jarvis-logger)
(log-jarvis-info "Jarvis starting up...")

;; REQUIRES

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
   'HUGO_SRC (build-path 'same "src" "hugo")
   'PGSQL_USERNAME (getenv "USER")
   'PGSQL_DB "soapy"))

(define (conf-ref s)
  (dict-ref CONFIG_DATA s))

;; CLI INTERFACE

(define commands
  (hash
   "noop"   (list "Does nothing"
             (lambda ()
               (log-info "noop was called :)")))
   "render" (list "Prepares and renders the static HTML (hugo)"
             (lambda ()
               (let ([db-conn (create-db-conn
                               (conf-ref 'PGSQL_USERNAME)
                               (conf-ref 'PGSQL_DB))])
                 (render-batch-files db-conn
                                     (conf-ref 'HUGO_SRC))
                 (render-hugo-files (conf-ref 'HUGO_SRC)
                                    (format "~a://~a:~a"
                                            (conf-ref 'WEBSERVER_PUBLIC_SCHEME)
                                            (conf-ref 'WEBSERVER_PUBLIC_DNSNAME)
                                            (conf-ref 'WEBSERVER_PUBLIC_PORT))))))))

(define command
  (command-line
   #:usage-help "noop | render"
   #:args (op) op))

(cond
 [(dict-has-key? commands command) ((second (dict-ref commands command)))]
 [else (log-error "Unknown command")])


