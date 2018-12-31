#lang racket

(require syntax/strip-context
         "parser.rkt")

(provide read
         read-syntax)

(define (read port)
  (syntax->datum
            (read-syntax #f port)))

#;(define (read-syntax path port)
  (with-syntax ([src-data (myapl-parse port)])
    (strip-context
     #'(module _ "expander.rkt"
         (provide data)
         (define data 'src-data)))))

(define (read-syntax path port)
  (define src-data (myapl-parse port))
  (define module-data
    `(module myapl-mod
       MyAPL/expander
       ,@src-data))
  (datum->syntax #f module-data))


;(read (open-input-string "3"))