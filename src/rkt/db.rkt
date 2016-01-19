#lang racket

(define-logger jarvis-db)

(require db)

(provide create-db-conn)

(define (create-db-conn db-user
                        db-name)
  (log-jarvis-db-debug "Connecting to PSQL: ~a@~a"
                db-user
                db-name)
  (virtual-connection
   (connection-pool
    (lambda () (postgresql-connect #:user db-user
                                   #:database db-name)))))

