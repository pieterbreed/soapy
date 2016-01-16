#lang racket

(require db)
(require web-server/templates)

(define db-name (or (getenv "PGSQL_DB_NAME")
                    "soapy"))
(define db-user (or (getenv "USER")
                    (getenv "PGSQL_USERNAME")))
(define hugo-batches-path (let ([v (getenv "WEB_HUGO_SRC_FOLDER")])
                            (if v
                                (build-path v "content" "batches")
                                (build-path 'same))))

(log-debug
 "Using:\nDB: ~s\nDB_USERNAME: ~s\nHUGO_BATCHES_PATH: ~s"
 db-name
 db-user
 (path->string hugo-batches-path))

(define db-conn
  (virtual-connection
   (connection-pool
    (lambda () (postgresql-connect #:user db-user
                                   #:database db-name)))))

(define (save-renders renders)
  (for-each save-render renders))

(define (save-render render)
  (let* ([filename (first render)]
         [text (second render)]
         [file (open-output-file (build-path hugo-batches-path filename)
                                 #:mode 'text
                                 #:exists 'truncate/replace)])
    (display text file)
    (close-output-port file)))

(define (render-active-batches)
  (let ([rs (query-rows db-conn
                        "SELECT to_char(announced, 'YYYY-MM-DD'),
                                        seq,
                                        name,
                                to_char(sell_from, 'YYYY-MM-DD'),
                                        average_price,
                                        ingredients,
                                        elzas_remarks
                         FROM batches
                         WHERE closed = $1"
                        false)])
    (map render-batch rs)))

(define (render-batch r)
    (apply hugo-batch-file (vector->list r)))

(define (hugo-batch-file announced
                         sequence
                         name
                         sell_from
                         average_price
                         ingredients
                         elzas_remarks)
  (let ([tpl (include-template "batch_template.md")])
    (list (format "~a-~a.md" announced sequence)
          tpl)))

(save-renders (render-active-batches))
