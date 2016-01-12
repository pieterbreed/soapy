#lang racket

(require db)

(define db-name "soapy")
(define db-user "pieterbreed")

(define db-conn
  (virtual-connection
   (connection-pool
    (lambda () (postgresql-connect #:user db-user
                                   #:database db-name)))))

