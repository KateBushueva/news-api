module Main (main) where

import Backend.Client.Handle
import Backend.Environment.Config
import Common.Handle

main :: IO ()
main = do
  env <- readEnvFromFile
  let handle = createBackendHandle env
  -- test
  articles <- getNNews handle 3
  print articles
  -- pass handle to the function that process user's requests
  pure ()
