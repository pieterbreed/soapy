#!/usr/bin/env racket
#lang racket

;;; in which a CLI is treated like a "language" with a parser and everything

(require (prefix-in p: parsack))

(define cli-one-line (string-join (vector->list (current-command-line-arguments))
                                  " "))

(define (symbol->symbol-parser s)
  (p:>> (p:try (p:string (symbol->string s)))
        (p:return s)))

(define (symbols->symbols-choice-parser . ss)
  (p:choice (map symbol->symbol-parser ss)))

(define (split-after-operator-parser)
  (p:parser-compose p:$spaces
                    (op-s <- p:$identifier)
                    p:$spaces
                    (rest <- (p:many p:$anyChar))
                    (p:return
                     (list (string->symbol (apply string op-s))
                           (apply string rest)))))

(define (run-cli spec cli-params)
  (let* ([cli-str (string-join (vector->list cli-params))]
         [op-params (p:parse-result (split-after-operator-parser)
                                    cli-str)]
         [op (first op-params)]
         [params (second op-params)]
         [op-record (dict-ref spec op)]
         [parser (vector-ref op-record 1)]
         [data (p:parse-result parser params)])
    ((vector-ref op-record 0) data)))

;; (define (find-op-parser)
;;   (let ([ops (map symbol->symbol-parser (dict-keys options))])
;;     (log-cli-debug "found these operators: ~s" ops)
    
(provide symbol->symbol-parser
         symbols->symbols-choice-parser
         split-after-operator-parser
         run-cli)

