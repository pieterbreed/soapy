#!/usr/bin/env racket
#lang racket

;;; in which a CLI is treated like a "language" with a parser and everything

(require (prefix-in p: parsack))

(define (run-cli spec cli-params)
  (let ([params-list (vector->list cli-params)])
    (p:parse-result
     (let ([parsed-op (string->symbol (first params-list))])
       (unless (dict-has-key? spec parsed-op)
               (error "Unkown operation!"))
       (dict-ref spec parsed-op))
     (rest params-list))))

(provide run-cli)

