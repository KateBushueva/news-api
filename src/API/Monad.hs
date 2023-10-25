module API.Monad where

import API.Cache
import Common.Handle
import Control.Monad.Trans.State.Lazy
import Servant.Server

data Env
  = Env
      { handle :: Handle IO,
        cache :: Cache
      }

type ApiM = StateT Env Handler

updateCacheEnv :: Cache -> ApiM ()
updateCacheEnv newCache = do
  env <- get
  put env {cache = newCache}
