#lang racket

(provide #%top
         #%app
         #%datum
         (rename-out [myapl-module-begin #%module-begin])
         interpret
         myapl-environment)

(define-syntax-rule (myapl-module-begin expression)
  (#%module-begin
   (interpret 'expression myapl-environment)))

(define (interpret expression environment)
  (let* ([type (car expression)]
         [value (cdr expression)])
    (match type
      ['number
       (string->number (car value))]
      ['verb
       (hash-ref environment (car value))]
      ['procedure-call
       (let* ([operator
              (interpret (car value) environment)]
              [operands
               (map (lambda (op) (interpret op environment))
                    (cadr value))])
         (apply operator operands))]
[else (error "AST node could not be evaluated: " value)])))

(define myapl-environment
  (hash
   "=" =))

;(interpret '(procedure-call (verb "=") ((number "4") (number "4"))) myapl-environment)
;(module mymod #f (myapl-module-begin '(procedure-call (verb "=") ((number "4") (number "4")))))