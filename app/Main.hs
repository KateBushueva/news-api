module Main (main) where

import API.Cache (initCache)
import API.Monad as API
import API.NewsApi (runApplication)
import Backend.Client.Handle
import Backend.Environment.Config as Backend

main :: IO ()
main = do
  backendEnv <- Backend.readEnvFromFile
  let handle = createBackendHandle backendEnv
      applicationEnv = API.Env handle initCache
  runApplication applicationEnv
