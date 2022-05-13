; A simple April repl.

(ql:quickload "april")

(defvar *running* T
  "Whether the program is running or not.")
(defconstant HELP
"]help - Displays this help.
]symbols - Help for symbols
]defns - All definitions in the current workspace so far
]save [file] - Save REPL history in 'file'. If unspecified, will save in temp.apl in the current folder.
]off - Close REPL.")

(defconstant NL (format nil "~C" #\newline))
(defvar *defns* "")

(write-string "April Compiler REPL
Type ]help for help
Type ]off to exit
  ")

(loop while *running* 
  do (let ((input (read-line)))
       (if (eql #\] (char input 0))
           (cond  ((string= "]help"    input) (write-line HELP))
                  ((string= "]symbols" input) (write-line "NYI")) ; TODO
                  ((string= "]defns"   input) (write-line *defns*))
                  ((string= "]off"     input) (write-line "Exiting April...") (setf *running* nil))
                  ((string= "]save" (subseq input 0 5)) 
                    (with-open-file (outfile (if (> (length input) 6) (subseq input 6) "temp.apl") :direction :output :if-does-not-exist :create :if-exists :supersede)
                      (format outfile *defns*))) 
                  (T (write-line "Invalid command")))
           (handler-case 
             (progn
               (april:april-f input)
               (if (find #\← input) (setf *defns* (concatenate 'string *defns* NL input))))
             (ERROR (err) (format t "ERROR: ~a" err))))
       (write-string (concatenate 'string NL "  "))))