#lang racket

(require db)

(provide get-active-batches-view-data)
(provide create-db-conn)

(define (create-db-conn db-name
                        db-user)
  (virtual-connection
   (connection-pool
    (lambda () (postgresql-connect #:user db-user
                                   #:database db-name)))))

(define (get-active-batches-view-data db-conn)
  (query-rows db-conn
              "SELECT to_char(announced, 'YYYY-MM-DD'),
                              seq,
                              name,
                      to_char(sell_from, 'YYYY-MM-DD'),
                              average_price,
                              ingredients,
                              elzas_remarks
               FROM batches
               WHERE closed = $1"
              false))
