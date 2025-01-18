main :: IO ()
main = do
    showContent "intro"
    cmdLoop "menu"

showContent :: String -> IO ()
showContent fileName = do
    let filePath = "content/" ++ fileName ++ ".txt"
    content <- readFile filePath
    putStrLn content

handleCommand :: String -> String -> IO ()
handleCommand loop cmd
    -- General commands
    | cmd == "exit" = showContent "exit" >> return ()
    | cmd == "commands" = showContent "commands" >> cmdLoop loop
    -- Menu-specific commands
    | loop == "menu" = case cmd of
        "" -> showContent "choose_course" >> cmdLoop "course"
        _  -> showContent "unknown" >> cmdLoop "menu"
    -- Course-specific commands
    | loop == "course" = case cmd of
        "1" -> showContent "rest" >> cmdLoop "rest"
        _  -> showContent "unknown" >> cmdLoop "course"
    -- REST Course-specific commands
    | loop == "rest" = case cmd of
        
        _  -> showContent "unknown" >> cmdLoop "rest"
    -- Catch error & exit
    | otherwise = showContent "error" >> return ()

cmdLoop :: String -> IO ()
cmdLoop name = do
    cmd <- getLine
    handleCommand name cmd
