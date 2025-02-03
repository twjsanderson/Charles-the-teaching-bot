import System.IO
import System.Directory (removeFile, renameFile)

main :: IO ()
main = do
    -- Initialize default scores for each course/quiz
    let scores = ["rest_score"]
    mapM_ initializeScores scores
    showContent "intro"
    cmdLoop Menu

cmdLoop :: GameState -> IO ()
cmdLoop state = do
    cmd <- getLine
    handleCommand state (parseInput cmd)

initializeScores :: String -> IO ()
initializeScores fileName = do
    let filePath = "content/" ++ fileName ++ ".txt"
    writeFile filePath "0"

updateScore :: String -> String -> IO ()
updateScore fileName result = do
    scoreInt <- getScore fileName
    let newScore = if result == "correct" then scoreInt + 1 else scoreInt

    let tempfilePath = "content/" ++ fileName ++ "_temp.txt"
    writeFile tempfilePath (show newScore)

    let oldfilePath = "content/" ++ fileName ++ ".txt"
    deleteFile fileName

    renameFile tempfilePath oldfilePath
    
getScore :: String -> IO Int
getScore fileName = do
    let filePath = "content/" ++ fileName ++ ".txt"
    scoreStr <- readFile filePath
    return (read scoreStr :: Int)  -- Convert the string to an Int and return it

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


data GameState = Menu
    | Course
    | Rest
    | RestLessons
    | RestQuiz
    | RestQuestionOne
    | RestQuestionTwo
    | RestQuestionThree
    | RestQuestionFour
    | RestQuestionBack
    | RestQuestionEnd
    deriving (Eq, Show)

data Command = Exit
    | Help
    | MenuCmd
    | Start
    | Intro
    | Quiz
    | Choice Int
    | Back
    | Unknown
    | Empty
    deriving (Eq, Show)

parseInput :: String -> Command
parseInput "exit" = Exit
parseInput "help" = Help
parseInput "menu" = MenuCmd
parseInput "back" = Back
parseInput "intro" = Intro
parseInput "start" = Start
parseInput "1" = Choice 1
parseInput "2" = Choice 2
parseInput "3" = Choice 3
parseInput "4" = Choice 4
parseInput "quiz" = Quiz
parseInput "" = Empty
parseInput _ = Unknown


handleCommand :: GameState -> Command -> IO ()
-- Main Menu cmds
handleCommand Menu Empty = showContent "choose_course" >> cmdLoop Course

-- Course cmds
handleCommand Course (Choice 1) = showContent "rest_intro" >> cmdLoop RestLessons

-- Rest Lesson 1
handleCommand RestLessons Intro = showContent "rest_intro" >> cmdLoop RestLessons
handleCommand RestLessons (Choice 1) = showContent "rest_one" >> cmdLoop RestLessons
handleCommand RestLessons (Choice 2) = showContent "rest_two" >> cmdLoop RestLessons
handleCommand RestLessons (Choice 3) = showContent "rest_three" >> cmdLoop RestLessons
handleCommand RestLessons (Choice 4) = showContent "rest_four" >> cmdLoop RestLessons
handleCommand RestLessons Quiz = showContent "rest_quiz" >> cmdLoop RestQuiz

-- Rest Quiz
handleCommand RestQuiz Back = resetScore "rest_score" >> showContent "rest_intro" >> cmdLoop RestLessons
handleCommand RestQuiz Start = showContent "rest_quiz_one" >> cmdLoop RestQuestionOne

-- Rest Q1
handleCommand RestQuestionOne (Choice 2) = updateScore "rest_score" "correct" >> showContent "rest_quiz_two" >> cmdLoop RestQuestionTwo
handleCommand RestQuestionOne (Choice _) = updateScore "rest_score" "incorrect" >> showContent "rest_quiz_two" >> cmdLoop RestQuestionTwo

-- Rest Q2
handleCommand RestQuestionTwo (Choice 3) = updateScore "rest_score" "correct" >> showContent "rest_quiz_three" >> cmdLoop RestQuestionThree
handleCommand RestQuestionTwo (Choice _) = updateScore "rest_score" "incorrect" >> showContent "rest_quiz_three" >> cmdLoop RestQuestionThree

-- Rest Q3
handleCommand RestQuestionThree (Choice 4) = updateScore "rest_score" "correct" >> showContent "rest_quiz_four" >> cmdLoop RestQuestionFour
handleCommand RestQuestionThree (Choice _) = updateScore "rest_score" "incorrect" >> showContent "rest_quiz_four" >> cmdLoop RestQuestionFour

-- Rest Q4
handleCommand RestQuestionFour (Choice 1) = updateScore "rest_score" "correct" >> showContent "rest_quiz_end_1" >> cmdLoop RestQuestionEnd
handleCommand RestQuestionFour (Choice _) = updateScore "rest_score" "incorrect" >> showContent "rest_quiz_end_1" >> cmdLoop RestQuestionEnd

-- Rest Quiz End 
handleCommand RestQuestionEnd Exit = showScore "rest_score" "4" >> showContent "exit" >> return ()
handleCommand RestQuestionEnd _ = showScore "rest_score" "4" >> resetScore "rest_score" >> showContent "rest_quiz_end_2" >> cmdLoop Menu

-- Handle App Wide cmds & errors
handleCommand state MenuCmd = showContent "choose_course" >> cmdLoop Course
handleCommand state Empty = showContent "unknown" >> cmdLoop state
handleCommand state Exit = showContent "exit" >> return ()
handleCommand state Help = showContent "help" >> cmdLoop state
handleCommand state _ = showContent "unknown" >> cmdLoop state
