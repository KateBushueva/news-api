module Main (main) where

import Backend.Client.Http
import Backend.Environment.Config
import Control.Monad.Reader

main :: IO ()
main = do
  env <- readEnvFromFile
  request <- runReaderT (findByKeyWords ["Harry Potter", "one"]) env
  print request
