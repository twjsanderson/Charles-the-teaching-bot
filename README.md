# Charles the Teaching Bot
--------------------------------------
                       ≠π                                     
                      π÷√π               
                     ππ×πππππππ               
               π∞ππππ√√√∞∞∞√ππ≠π         
               √√=π ππ   π  π√ππ                   
               π√≠ππ∞∞πππ≈π π∞∞π               
               ππ∞    π√π   π√≠π                 
               π≈π√√∞∞∞√√ππππ≈π     
                 π≈≠ππππ√√≈≈π                        
              π∞≈∞√√π  √≈√≈√√∞√             
             π∞√√∞π≈π    π√≈π≈√√           
           π∞≈√≈π  √∞  π=√  π√∞√≠π
---------------------------------------

A simple command line to help developers learn basic concepts about internet networking.

Mainly created as an exercise to help me learn Haskell.

## Setup

Make sure ghc is installed

In your terminal run:
1. ghc Main.hs
2. ./Main (from root)

## What I learned

This project was an attempt to learn basic I/O operations, file interactions and some simple conditional logic in a new language (Haskell). It forced me to use some recursion (no loops in FP!) and build with some case logic to handle the branching behaviour I wanted.

I also had to learn about type conversions (strings into ints). I learned about "show" to convert String to Int (and a few other helpful functions).

I ran into some errors reading files that ended up breaking the app via the updateScore function. It turns out that modifying an existing file (depending on how it's done) can cause an "resource busy (file is locked)" error.

Turns out that Haskell's lazy evaluation can sometimes premeptively lock a resource (ie. a read) until its fully evaluated. So I took a alternate approach and create a temp file with the new data, deleted the old file and renamed the temp one to replace the original file. The solution is pretty convoluted but it gets around the locking problem well enough.

(reference - https://stackoverflow.com/questions/5053135/resource-busy-file-is-locked-error-in-haskell)

Lastly, I learn about the >> operator to help me execute multiple functions in sequence when I dont care about their results. This is related
to the Monad typeclass, which I dont fully understand yet.

## Stretch Goals

1. DRY up my code
2. Add tests
3. Create a new command that shows results for all past quizzes
4. Add a new quiz