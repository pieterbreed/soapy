#lang racket

(require yaml)

(provide read-batch-data)

(define (markdown-file? p)
  (and (not (directory-exists? p))
       (equal? #"md" (filename-extension p))))

(define (strip-frontmatter fs)
  

(define (read-batch-data path)
  (let* ([md-files (find-files markdown-file?
                               (build-path path
                                           "content"
                                           "batches"))]
         [md-text (map strip-frontmatter md-files)])
    (map file->yaml md-text)))
