module Backend.Client.Handle (createBackendHandle) where

import qualified Backend.Client.Http as Backend
import Backend.Environment.Config
import Backend.Environment.Monad
import Common.Article
import Common.Handle
import Control.Monad.Reader
import Data.Aeson
import qualified Data.ByteString.Lazy as LBS

decodeArticle :: LBS.ByteString -> BackendM [Article]
decodeArticle bs = do
  response :: Response <- either throwDecodingError pure $ eitherDecode bs
  pure $ articles response

createBackendHandle :: Env -> Handle IO
createBackendHandle env =
  Handle
    { getNNews = \n ->
        flip runReaderT env $ do
          resp <- Backend.fetchNNews n
          decodeArticle resp,
      searchByAuthor = \phrase ->
        flip runReaderT env $ do
          resp <- Backend.findByPhrase phrase
          decodeArticle resp,
      searchByTitle = \phrase ->
        flip runReaderT env $ do
          resp <- Backend.findByPhrase phrase
          decodeArticle resp,
      searchByKeywords = \keywords ->
        flip runReaderT env $ do
          resp <- Backend.findByKeyWords keywords
          decodeArticle resp
    }
