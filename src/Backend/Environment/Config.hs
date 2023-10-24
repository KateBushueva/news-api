module Backend.Environment.Config (Env (..), readEnvFromFile) where

import Common.Exceptions
import Control.Exception
import qualified Data.Configurator as Configurator
import qualified Data.Configurator.Types as Configurator
import Data.Text as T

newtype Env
  = Env
      { apiKey :: String
      }
  deriving (Show, Eq)

readEnvFromFile :: IO Env
readEnvFromFile = do
  eiConfig <- try $ Configurator.load [Configurator.Required "./local.config"] :: IO (Either IOException Configurator.Config)
  config <- either (handleException . T.pack . show) pure eiConfig
  key :: String <- Configurator.lookup config "env.apiKey" >>= maybe (handleException "Impossible to get API key from config file") pure
  pure $ Env key
  where
    handleException :: T.Text -> IO a
    handleException errMsg = do
      print errMsg
      throwIO InitException
