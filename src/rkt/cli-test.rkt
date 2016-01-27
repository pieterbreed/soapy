#!/usr/bin/env racket
#lang racket

(require rackunit
         rackunit/text-ui
         (prefix-in p: parsack)
         "cli.rkt")

(define cli-tests
  (test-suite
   "testing the utility functions that parses the CLI"

   (let ([spec (hash
                'op1 (p:return 1))])
     (check-equal? (run-cli spec #("op1"))
                   1))))

(exit (run-tests cli-tests))
