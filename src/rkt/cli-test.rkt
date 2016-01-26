#!/usr/bin/env racket
#lang racket

(require rackunit
         rackunit/text-ui
         (prefix-in p: parsack)
         "cli.rkt")

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
                 (list 'op2 ""))))

(exit (run-tests cli-tests))
