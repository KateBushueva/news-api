module Backend.Environment.Monad (BackendM, throwBackendError) where

import Backend.Environment.Config (Env)
import Common.Exceptions
import Control.Exception
import Control.Monad.Reader
import Data.Text as T

type BackendM a = ReaderT Env IO a

throwBackendError :: T.Text -> BackendM a
throwBackendError errMsg = do
  liftIO $ print errMsg
  liftIO $ throwIO BackendException
