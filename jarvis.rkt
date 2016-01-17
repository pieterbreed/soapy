#!/usr/bin/env racket
#lang racket

(require racket/format)
(require mzlib/os)
(require "src/rkt/render.rkt"
         "src/rkt/db.rkt")

;; ENVIRONMENT CONFIGURATION

(define ENVIRONMENT
  (hash
   'WEBSERVER_PUBLIC_SCHEME "http"
   'WEBSERVER_PUBLIC_DNSNAME (gethostname)
   'WEBSERVER_PUBLIC_PORT "8080"
   'STATIC_HTML_OUTPUT (build-path 'same "output" "hugo")
   'HUGO_SRC (build-path 'same "src" "hugo")
   'PGSQL_USERNAME (getenv "USER")
   'PGSQL_DB "soapy"))

;; CLI INTERFACE

(define commands
  (hash
   "noop" (list "Does nothing"
                (lambda () (log-info "noop was called :)")))
   "render" (list "Renders the static HTML"
                  (lambda ()
                    (let ([db-conn (create-db-conn 
                                    (dict-ref ENVIRONMENT
                                              'PGSQL_USERNAME)
                                    (dict-ref ENVIRONMENT
                                              'PGSQL_DB))])
                      (render-batch-files db-conn)
                      ;(render-hugo-files)
                      )))))

(define command
  (command-line
   #:usage-help "(fill me out: http://stackoverflow.com/q/34837318/24172)"
   #:args (op) op))

(cond
 [(dict-has-key? commands command) ((second (dict-ref commands command)))]
 [else (log-error "Unknown command")])


