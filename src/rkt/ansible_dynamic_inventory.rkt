#!/usr/bin/env racket

#lang racket

(require json)

(define-logger dyninv)

(define list-mode? (make-parameter #f))
(define host-mode? (make-parameter #f))

(define IPC_ENV_NAME "JARVIS_IPC_PORT")
(define ipc-port
  (getenv IPC_ENV_NAME))

(command-line
 #:usage-help
 "Ansible dynamic inventory script.\n"
 
 #:once-any

 ["--list"
  "Provide complete inventory"
  (list-mode? #t)]
 
 ["--host" host
  "Return the variables for a specific host"
  (host-mode? host)]
 
 #:ps "\n"
 "This script is meant to be invoked as the '-i' flag for ansible-playbook."
 "It will use IPC-via-TCP to communicate with a (possibly hosting) jarvis process."
 "The port for IPC is read from an environment variable called \"JARVIS_IPC_PORT\".")

;; CHECK THAT THE PORT NR ENVIRONMENT VARIABLE HAS BEEN SET

(unless (and ipc-port
             (string->number ipc-port))
        (log-dyninv-error "Please set the ~s variable to a port number"
                          IPC_ENV_NAME)
        (exit 1))

;; MAIN LOGIC

(define (read-and-dump-data req)
  (let-values ([(in out)
                (tcp-connect "localhost"
                             (string->number ipc-port))])
    (write-json req out)
    (close-output-port out)
    (printf "~a\n" (jsexpr->string (read-json in)))
    (close-input-port in)))

(define (print-list-data)
  (read-and-dump-data (list "ansible-inventory" "list")))

(define (print-host-data host)
  (read-and-dump-data (list "ansible-inventory" "host" host)))

(cond
 [(list-mode?) (print-list-data)]
 [(host-mode?) (print-host-data (host-mode?))]
 [else (log-dyninv-error "Unknown CLI operation")
       (exit 1)])



         
        
