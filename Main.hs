import System.IO
import System.Directory (removeFile, renameFile)

main :: IO ()
main = do
    -- Initialize default scores for each course/quiz
    let scores = ["rest_score"]
    mapM_ initializeScores scores
    showContent "intro"
    cmdLoop "menu"

initializeScores :: String -> IO ()
initializeScores fileName = do
    let filePath = "content/" ++ fileName ++ ".txt"
    writeFile filePath "0"

-- Update the score in the file
updateScore :: String -> String -> IO ()
updateScore fileName result = do
    scoreInt <- getScore fileName  -- Get the current score as an IO Int
    let newScore = case result of
            "correct" -> scoreInt + 1  -- Increment score if correct
            "incorrect" -> scoreInt    -- Keep score if incorrect
            _ -> scoreInt              -- Default to current score for other cases

    let tempfilePath = "content/" ++ fileName ++ "_temp.txt"
    writeFile tempfilePath (show newScore)

    let oldfilePath = "content/" ++ fileName ++ ".txt"
    deleteFile fileName

    renameFile tempfilePath oldfilePath
    

-- Function to get the current score from the file
getScore :: String -> IO Int
getScore fileName = do
    let filePath = "content/" ++ fileName ++ ".txt"
    scoreStr <- readFile filePath  -- Read the file content as a string
    return (read scoreStr :: Int)  -- Convert the string to an Int and return it

-- Delete the score file
deleteFile :: String -> IO ()
deleteFile fileName = do
    let filePath = "content/" ++ fileName ++ ".txt"
    removeFile filePath

resetScore :: String -> IO ()
resetScore fileName = do
    let tempfilePath = "content/" ++ fileName ++ "_temp.txt"
    writeFile tempfilePath "0"

    let oldfilePath = "content/" ++ fileName ++ ".txt"
    deleteFile fileName

    renameFile tempfilePath oldfilePath

showScore :: String -> String -> IO ()
showScore fileName total = do
    let filePath = "content/" ++ fileName ++ ".txt"
    score <- readFile filePath
    putStrLn $ "Your score is " ++ score ++ "/" ++ total

showContent :: String -> IO ()
showContent fileName = do
    let filePath = "content/" ++ fileName ++ ".txt"
    content <- readFile filePath
    putStrLn content

handleCommand :: String -> String -> IO ()
handleCommand loop cmd
    -- General commands
    | cmd == "exit" = showContent "exit" >> return ()
    | cmd == "help" = showContent "help" >> cmdLoop loop
    | cmd == "menu" = showContent "choose_course" >> cmdLoop "course"

    -- Main Menu commands
    | loop == "menu" = case cmd of
        "" -> showContent "choose_course" >> cmdLoop "course"
        _  -> showContent "unknown" >> cmdLoop "menu"

    -- Course Choices commands
    | loop == "course" = case cmd of
        "1" -> showContent "rest_intro" >> cmdLoop "rest"
        _  -> showContent "unknown" >> cmdLoop "course"
    
    -- REST commands
    | loop == "rest" = case cmd of
        "intro" -> showContent "rest_intro" >> cmdLoop "rest"
        "1" -> showContent "rest_one" >> cmdLoop "rest"
        "2" -> showContent "rest_two" >> cmdLoop "rest"
        "3" -> showContent "rest_three" >> cmdLoop "rest"
        "4" -> showContent "rest_four" >> cmdLoop "rest"
        "quiz" -> showContent "rest_quiz" >> cmdLoop "rest_quiz"
        _  -> showContent "unknown" >> cmdLoop "rest"

    | loop == "rest_quiz" = case cmd of
        "back" -> resetScore "rest_score" >> showContent "rest_intro" >> cmdLoop "rest"
        "start" -> showContent "rest_quiz_one" >> cmdLoop "rest_question_one"
        _  -> showContent "unknown" >> cmdLoop "rest_quiz"

    | loop == "rest_question_one" = case cmd of
        "back" -> resetScore "rest_score" >> showContent "rest_intro" >> cmdLoop "rest"
        "1" -> updateScore "rest_score" "incorrect" >> showContent "rest_quiz_two" >> cmdLoop "rest_question_two"
        "2" -> updateScore "rest_score" "correct" >> showContent "rest_quiz_two" >> cmdLoop "rest_question_two"
        "3" -> updateScore "rest_score" "incorrect" >> showContent "rest_quiz_two" >> cmdLoop "rest_question_two"
        "4" -> updateScore "rest_score" "incorrect" >> showContent "rest_quiz_two" >> cmdLoop "rest_question_two"
        _  -> showContent "unknown" >> cmdLoop "rest_question_one"
    
    | loop == "rest_question_two" = case cmd of
        "back" -> resetScore "rest_score" >> showContent "rest_intro" >> cmdLoop "rest"
        "1" -> updateScore "rest_score" "incorrect" >> showContent "rest_quiz_three" >> cmdLoop "rest_question_three"
        "2" -> updateScore "rest_score" "incorrect" >> showContent "rest_quiz_three" >> cmdLoop "rest_question_three"
        "3" -> updateScore "rest_score" "correct" >> showContent "rest_quiz_three" >> cmdLoop "rest_question_three"
        "4" -> updateScore "rest_score" "incorrect" >> showContent "rest_quiz_three" >> cmdLoop "rest_question_three"
        _  -> showContent "unknown" >> cmdLoop "rest_question_two"
    
    | loop == "rest_question_three" = case cmd of
        "back" -> resetScore "rest_score" >> showContent "rest_intro" >> cmdLoop "rest"
        "1" -> updateScore "rest_score" "incorrect" >> showContent "rest_quiz_four" >> cmdLoop "rest_question_four"
        "2" -> updateScore "rest_score" "incorrect" >> showContent "rest_quiz_four" >> cmdLoop "rest_question_four"
        "3" -> updateScore "rest_score" "incorrect" >> showContent "rest_quiz_four" >> cmdLoop "rest_question_four"
        "4" -> updateScore "rest_score" "correct" >> showContent "rest_quiz_four" >> cmdLoop "rest_question_four"
        _  -> showContent "unknown" >> cmdLoop "rest_question_three"
    
    | loop == "rest_question_four" = case cmd of
        "back" -> resetScore "rest_score" >> showContent "rest_intro" >> cmdLoop "rest"
        "1" -> updateScore "rest_score" "correct" >> showContent "rest_quiz_end" >> cmdLoop "rest_question_end"
        "2" -> updateScore "rest_score" "incorrect" >> showContent "rest_quiz_end" >> cmdLoop "rest_question_end"
        _  -> showContent "unknown" >> cmdLoop "rest_question_four"
    
    | loop == "rest_question_end" = case cmd of
        "back" -> resetScore "rest_score" >> showContent "rest_intro" >> cmdLoop "rest"
        "" -> showScore "rest_score" "4" >> resetScore "rest_score" >> cmdLoop "menu"
        _  -> showContent "unknown" >> cmdLoop "rest_question_end"
    
    -- Catch error & exit
    | otherwise = showContent "error" >> return ()

cmdLoop :: String -> IO ()
cmdLoop name = do
    cmd <- getLine
    handleCommand name cmd
