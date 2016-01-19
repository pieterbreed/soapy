#lang racket

(define-logger jarvis-render)

(require "db.rkt")
(require web-server/templates)

;; API

(provide render-hugo-files)

(define (render-hugo-files hugo-path base-url)
  (parameterize
   ([current-directory hugo-path])
   (system*
    (find-executable-path "hugo")
    (format "--baseURL=~s" base-url)
    "--verbose"
    "--buildDrafts"
    #:set-pwd? true)))

