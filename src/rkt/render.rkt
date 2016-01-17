#lang racket

(define-logger jarvis-render)

(require "db.rkt")
(require web-server/templates)

(provide render-batch-files)
(provide render-hugo-files)

(define (render-batch-files db-conn
                            hugo-batches-path)
  (save-renders
   hugo-batches-path
   (render-active-batches db-conn)))

(define render-hugo-files
  null)

;; INTERNALS

(define (save-renders hugo-batches-path renders)
  (for-each (curry save-render hugo-batches-path)
            renders))

(define (render-active-batches db-conn)
  (map render-batch (get-active-batches-view-data db-conn)))

(define (save-render hugo-batches-path render)
  (let* ([filepath (build-path hugo-batches-path
                               (first render))]
         [text (second render)]
         [file (open-output-file
                filepath
                #:mode 'text
                #:exists 'truncate/replace)])
    (display text file)
    (close-output-port file)
    (log-jarvis-render-info (path->string filepath))))

(define (render-batch r)
  (apply create-hugo-batch-file (vector->list r)))

(define (create-hugo-batch-file announced
                                sequence
                                name
                                sell_from
                                average_price
                                ingredients
                                elzas_remarks)
  (let ([tpl (include-template "batch_template.md")])
    (list (format "content/batches/~a-~a.md" announced sequence)
          tpl)))

