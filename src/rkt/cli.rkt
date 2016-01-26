#!/usr/bin/env racket
#lang racket

;;; in which a CLI is treated like a "language" with a parser and everything

(define-logger cli)

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
                    p:$space
                    p:$spaces
                    (rest <- (p:many p:$anyChar))
                    (p:return
                     (list (string->symbol (apply string op-s))
                           (apply string rest)))))

;; (define (find-op-parser)
;;   (let ([ops (map symbol->symbol-parser (dict-keys options))])
;;     (log-cli-debug "found these operators: ~s" ops)
    
(provide symbol->symbol-parser
         symbols->symbols-choice-parser
         split-after-operator-parser)

