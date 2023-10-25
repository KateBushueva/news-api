module Backend.Client.RequestFunctions (fetchNNews, findByPhrase, findByKeyWords) where

import Backend.Client.URL
import Backend.Environment.Monad
import Control.Monad.Reader
import qualified Data.ByteString.Lazy as LBS
import qualified Data.Text as T
import Network.HTTP.Simple
import Network.HTTP.Types.Status (ok200)

sendRequest :: Request -> BackendM LBS.ByteString
sendRequest request = do
  resp <- liftIO $ httpLBS request
  let status = getResponseStatus resp
  if status == ok200
    then pure $ getResponseBody resp
    else throwBackendError $ "Failed to get response from the server: " <> (T.pack . show) status

fetchNNews :: Int -> BackendM LBS.ByteString
fetchNNews n = do
  request <- fetchNRequest n
  sendRequest request

findByPhrase :: T.Text -> BackendM LBS.ByteString
findByPhrase phrase = do
  request <- findByPhraseRequest phrase
  sendRequest request

findByKeyWords :: [T.Text] -> BackendM LBS.ByteString
findByKeyWords keywords = do
  request <- findByWordsRequest keywords
  sendRequest request
