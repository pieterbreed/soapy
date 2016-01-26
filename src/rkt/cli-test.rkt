#!/usr/bin/env racket
#lang racket

(require rackunit
         rackunit/text-ui
         (prefix-in p: parsack)
         "cli.rkt")

(define (long-string-to-list-of-strings-parser)
  (let* ([ws " \t\n\r"]
         [ws-p (p:many1 (p:oneOf ws))]
         [id-p (p:parser-compose 
                (x <- (p:many1 (p:noneOf ws)))
                (p:return (apply string x)))])
    (p:sepBy1 id-p ws-p)))

(define cli-tests
  (test-suite
   "testing the utility functions that parses the CLI"
   (check-equal? (p:parse-result (symbol->symbol-parser 'op)
                                 "op")
                 'op)

   (let ([p (symbols->symbols-choice-parser 'op1 'op2 'op3)])
     (check-equal? (p:parse-result p "op1") 'op1)
     (check-equal? (p:parse-result p "op2") 'op2)
     (check-equal? (p:parse-result p "op3") 'op3))

   (check-equal? (p:parse-result (split-after-operator-parser)
                                 "  op1   some other stuff ")
                 (list 'op1 "some other stuff ")
                 "can identify the operator and retain the params")
   (check-equal? (p:parse-result (split-after-operator-parser)
                                 "op2")
                 (list 'op2 ""))

   (check-equal? (p:parse-result (long-string-to-list-of-strings-parser)
                                 "one  two three     \tfour")
                 (list "one" "two" "three" "four")
                 "simple parameter string")


   (let* ([win-op (lambda x (apply list 0 x))]
          [spec (hash 'op (vector win-op (long-string-to-list-of-strings-parser))
                      'op2 (vector win-op (long-string-to-list-of-strings-parser))
                      'op3 (vector win-op (long-string-to-list-of-strings-parser)))])
     (check-equal? (run-cli spec #("op" "one" "two"))
                   (list 0 (list "one" "two")))
     (check-equal? (run-cli spec #("op2" "three"))
                   (list 0 (list "three")))
     ;; (check-equal? (run-cli spec #("op3" ""))
     ;;               (list 0 (list "")))
     )))

(exit (run-tests cli-tests))
