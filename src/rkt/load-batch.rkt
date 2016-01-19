#lang racket

(require racket/date)

(define-logger jarvis-load-batch)

(provide load-batch-from-path)

(define CONVENTION
  (hash
   'BATCH_INFO_FNAME "batch_info.txt"
   'INGREDIENTS_FNAME "ingredients.txt"
   'REMARKS_FNAME "remarks.txt"))

(define (convention-ref name)
  (dict-ref CONVENTION name))

(define (convention-ref-file path s)
  (path->complete-path
   (build-path path
               (convention-ref s))))

(define (convention-ref-files path)
  (apply values (map (curry convention-ref-file path)
                     (list 'BATCH_INFO_FNAME
                           'INGREDIENTS_FNAME
                           'REMARKS_FNAME))))

(define (parse-date-and-seq s)
  (log-jarvis-load-batch-debug "Parsing date-and-seq from ~s" s)
  (match (regexp-match #px"(\\d{4})-(\\d{2})-(\\d{2})-(\\d+)" s)
         [(list y m d seq) (values (seconds->date
                                    (find-seconds 0 0 0
                                                  (string->number d)
                                                  (string->number m)
                                                  (string->number y)))
                                   (string->number seq))]))

(define (parse-date s)
  (match (parse-date-and-seq (format "~a-~a" s 0))
         [(list d _) d]))

(define (parse-closed s)
  (if (equal? s "true")
      #t
      #f))

(define (load-batch-info fpath)
  (with-input-from-file fpath
    (lambda ()
      (let-values ([(announced-date
                     seq-nr) (parse-date-and-seq (read-line))]
                   [(closed) (parse-closed (read-line))]
                   [(name) (read-line)]
                   [(sell-from-date) (parse-date (read-line))]
                   [(avg-price) (string->number (read-line))])
        (values announced-date
                seq-nr
                closed
                name
                sell-from-date
                avg-price)))))

(define (load-file-content fpath)
  (call-with-input-file fpath
    (lambda (in) (port->string in))))

(define (load-batch-from-path path)
  (log-jarvis-load-batch-debug "Loading batch info from ~s" path)
  (let-values ([(info-f
                 ingr-f
                 rmrx-f) (convention-ref-files path)])
    (log-jarvis-load-batch-debug "Looking for these file: ~s"
                                 (map path->string (list info-f ingr-f rmrx-f)))
    (let-values ([(announced-date
                   seq-nr
                   closed
                   name
                   sell-from-date
                   average-price) (load-batch-info info-f)]
                 [(ingredients) (load-file-content ingr-f)]
                 [(remarks) (load-file-content rmrx-f)])
      (values announced-date
              seq-nr
              closed
              name
              sell-from-date
              average-price
              ingredients
              remarks))))
