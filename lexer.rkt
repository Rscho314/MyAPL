#lang racket

;; File format:
;; ------------
;;
;; <verb/adverb symbol or array literal>
;; '((c...+ (m...+ n...+))...+) ; list of list of coordinates
;;                                (locations of use)
;;                                and modes (with address of next cell)
;; adverbs take up a cell, to allow multiple adverbs for a verb
;; currently no way to define new verbs

(require parser-tools/lex
             [prefix-in : parser-tools/lex-sre])

(provide myapl-lexer
         delimiters
         verbs
         nouns)

(define-empty-tokens delimiters
  (OP        ;(
   CP        ;)
   SPACE
   EOF))

(define-tokens verbs
  (VERB))

(define-tokens nouns
  (NUMBER
   MODE))

(define myapl-lexer
  (lexer   
   [#\( (token-OP)]
   [#\) (token-CP)]
   [" " (token-SPACE)]
   [(eof) (token-EOF)]

   [#\= (token-VERB lexeme)]
   
   [(:+ numeric) (token-NUMBER lexeme)]
   [(:or "i" "o") (token-MODE lexeme)]
   
   [(:- whitespace " ") (myapl-lexer input-port)]))