{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module API.NewsApi
  ( runApplication,
  )
where

import API.Logic
import API.Monad
import API.Request
import Common.Article
import Common.Exceptions
import Control.Exception (try)
import Control.Monad.Catch (throwM)
import Control.Monad.IO.Class (liftIO)
import Control.Monad.Trans.State.Lazy
import Data.Proxy
import qualified Data.Text as T
import qualified Network.Wai.Handler.Warp as Warp
import Servant.API
import Servant.Server
import System.IO (hPutStrLn, stderr)

type NewsAPI =
  "fetchN" :> QueryParam "n" Int :> Get '[JSON] [Article]
    :<|> "findByAuthor" :> QueryParam "author" T.Text :> Get '[JSON] [Article]
    :<|> "findByTitle" :> QueryParam "title" T.Text :> Get '[JSON] [Article]
    :<|> "findByKeywords" :> QueryParam "keywords" T.Text :> Get '[JSON] [Article]

api :: Proxy NewsAPI
api = Proxy

fetchN :: Maybe Int -> ApiM [Article]
fetchN Nothing = throwM err400
fetchN (Just n) = handleApiRequest $ FetchN n

findByAuthor :: Maybe T.Text -> ApiM [Article]
findByAuthor Nothing = throwM err400
findByAuthor (Just author) = handleApiRequest $ FindByAuthor author

findByTitle :: Maybe T.Text -> ApiM [Article]
findByTitle Nothing = throwM err400
findByTitle (Just title) = handleApiRequest $ FindByTitle title

findByKeywords :: Maybe T.Text -> ApiM [Article]
findByKeywords Nothing = throwM err400
-- TODO: split keywords by comma
findByKeywords (Just keywords) = handleApiRequest $ FindByKeywords [keywords]

handleApiRequest :: Request -> ApiM [Article]
handleApiRequest request = do
  Env {..} <- get
  eiResp <- liftIO $ try (handleRequest request cache handle)
  case eiResp of
    Right (updatedCache, articles) -> do
      updateCacheEnv updatedCache
      pure articles
    Left err -> handleError err
  where
    handleError BackendException = throwM gnewsError
    handleError DecodingError = throwM decodingError
    handleError _ = throwM err500

server :: ServerT NewsAPI ApiM
server =
  fetchN
    :<|> findByAuthor
    :<|> findByTitle
    :<|> findByKeywords

mkApplication :: Env -> IO Application
mkApplication env = do
  let app = hoistServer api (applyState env) server
  pure $ serve api app

applyState :: Env -> ApiM a -> Handler a
applyState e m = do
  (res, _) <- runStateT m e
  pure res

runApplication :: Env -> IO ()
runApplication env = do
  let settings =
        Warp.setPort 4008 $
          Warp.setBeforeMainLoop
            ( hPutStrLn
                stderr
                "News API is listening on port 4008"
            )
            Warp.defaultSettings
  mkApplication env >>= Warp.runSettings settings

gnewsError :: ServerError
gnewsError =
  ServerError
    { errHTTPCode = 505,
      errReasonPhrase = "Failed to establish communication with GNews",
      errBody = "",
      errHeaders = []
    }

decodingError :: ServerError
decodingError =
  ServerError
    { errHTTPCode = 509,
      errReasonPhrase = "Failed to decode response from GNews",
      errBody = "",
      errHeaders = []
    }
