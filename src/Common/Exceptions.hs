module Common.Exceptions (ApiExceptions (..)) where

import Control.Exception

data ApiExceptions
  = InitException
  | BackendException
  deriving (Show, Eq)

instance Exception ApiExceptions
