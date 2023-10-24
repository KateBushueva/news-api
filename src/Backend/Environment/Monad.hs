module Backend.Environment.Monad (BackendM, throwBackendError, throwDecodingError) where

import Backend.Environment.Config (Env)
import Common.Exceptions
import Control.Exception
import Control.Monad.Reader
import Data.Text as T

type BackendM = ReaderT Env IO

throwBackendError :: T.Text -> BackendM a
throwBackendError errMsg = do
  liftIO $ print errMsg
  liftIO $ throwIO BackendException

throwDecodingError :: String -> BackendM a
throwDecodingError errMsg = do
  liftIO $ print errMsg
  liftIO $ throwIO DecodingError
