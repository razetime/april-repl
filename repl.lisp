; A simple April repl.

(ql:quickload "april")

(defvar *running* T
  "Whether the program is running or not.")
(defconstant HELP
"]help - Displays this help.
]symbols - Help for symbols
]defns - All definitions in the current workspace so far
]save [file] - Save REPL history in 'file'. If unspecified, will save in temp.apl in the current folder.
]load <file> - load an APL file into the REPL.
]clear - Clear the current workspace.
]off - Close REPL.")
(defconstant NL (format nil "~C" #\newline))
(defconstant SYMS
"← ASSIGN                       ⍷ find                                      
                               ∪ unique union                              
+ conjugate plus               ∩ intersection                              
- negate minus                 ~ not without                               
× direction times                                                          
÷ reciprocal divide            / replicate Reduce                          
* exponential power            \ \expand Scan                              
⍟ natural logarithm logarithm  ⌿ replicate first Reduce First              
⌹ matrix inverse matrix divide ⍀ expand first Scan First                   
○ pi times circular                                                        
! factorial binomial           , ravel catenate/laminate                   
? roll deal                    ⍪ table catenate first/laminate             
                               ⍴ shape reshape                             
| magnitude residue            ⌽ reverse rotate                            
⌈ ceiling maximum              ⊖ reverse first rotate first                
⌊ floor minimum                ⍉ transpose reorder axes                    
⊥ decode                                                                   
⊤ encode                       ¨ Each                                      
⊣ same left                    ⍨ Constant Self Swap                        
⊢ same right                   ⍣ Repeat Until                              
                               . Outer Product (∘.) Inner Product          
= equal                        ∘ OUTER PRODUCT (∘.) Bind Beside            
≠ unique mask not equal        ⍤ Rank Atop                                 
≤ less than or equal to        ⍥ Over                                      
< less than                    @ At                                        
> greater than                                                             
≥ greater than or equal to     ⍞ STDIN STDERR                              
≡ depth match                  ⎕ EVALUATED STDIN STDOUT SYSTEM NAME PREFIX 
≢ tally not match              ⍠ Variant                                   
                               ⌸ Index Key Key                             
∨ greatest common divisor/or   ⌺ Stencil                                   
∧ lowest common multiple/and   ⌶ I-Beam                                    
⍲ nand                         ⍎ execute                                   
⍱ nor                          ⍕ format                                    
                                                                           
↑ mix take                     ⋄ STATEMENT SEPARATOR                       
↓ split drop                   ⍝ COMMENT                                   
⊂ enclose partioned enclose    → ABORT BRANCH                              
⊃ first pick                   ⍵ RIGHT ARGUMENT RIGHT OPERAND (⍵⍵)         
⊆ nest partition               ⍺ LEFT ARGUMENT LEFT OPERAND (⍺⍺)           
⌷ materialise index            ∇ recursion Recursion (∇∇)                  
⍋ grade up grades up           & Spawn                                     
⍒ grade down grades down                                                   
                               ¯ NEGATIVE                                  
⍳ indices indices of           ⍬ EMPTY NUMERIC VECTOR                      
⍸ where interval index         ∆ IDENTIFIER CHARACTER                      
∊ enlist member of             ⍙ IDENTIFIER CHARACTER                      ")
(defvar *defns* "")

(write-string "April Compiler REPL
Type ]help for help
Type ]off to exit
  ")


(loop while *running* 
  do (let ((input (read-line)))
          (if (eql #\] (char input 0))
              (cond ((string= "]help"    input) (write-line HELP))
                    ((string= "]symbols" input) (write-line SYMS))
                    ((string= "]defns"   input) (write-line *defns*))
                    ((string= "]clear"   input) (april:april-clear-workspace common))
                    ((string= "]off"     input) (write-line "Exiting April...") (setf *running* nil))
                    ((string= "]save" (subseq input 0 5)) 
                      (with-open-file (outfile (if (> (length input) 6) (subseq input 6) "temp.apl") :direction :output :if-does-not-exist :create :if-exists :supersede)
                        (format outfile *defns*))) 
                    ((string= "]load" (subseq input 0 5)) (with-open-file (stream (subseq input 6))
                      (april:april (let ((contents (make-string (file-length stream))))
                        (read-sequence contents stream)
                        (setf *defns* (concatenate 'string *defns* NL contents))
                        contents))))
                    (T (write-line "Invalid command")))
              (handler-case
                (progn
                  (if (eql #\{ (char input (- (length input) 1))) 
                      (let ((bal (count #\{ input)))
                           (loop while (/= bal 0)
                             do (let ((next-line (read-line)))
                                     (progn
                                       (setf input (concatenate 'string input NL next-line))
                                      ;  (format T "Line given: ~a~a" next-line NL)
                                       (setf bal (+ bal (april:april-c "{+/-/'{}'∘.=⍨⍵/⍨~≠\\''''=⍵}" next-line))))))))
                  (april:april-f input)
                  (if (find #\← input) (setf *defns* (concatenate 'string *defns* NL input))))
                (ERROR (err) (format t "ERROR: ~a" err))))
          (write-string (concatenate 'string NL "  "))))

; {≠\''''=⍵} '{''{}{}''''dasdasdsa''}'