module Backend.Client.URL (fetchNRequest, findByPhraseRequest, findByWordsRequest) where

import Backend.Environment.Config
import Backend.Environment.Monad
import Control.Monad.Reader
import qualified Data.Text as T
import Network.HTTP.Simple

base :: String
base = "https://gnews.io/api/v4/"

fetchNRequest :: Int -> BackendM Request
fetchNRequest n
  | n < 1 || n > 20 = throwBackendError "News number cannot be less than 1 and bigger than 20"
  | otherwise = do
    key <- asks apiKey
    let request =
          parseRequest_ $
            base
              <> "top-headlines?category=general&max="
              <> show n
              <> "&apikey="
              <> key
    pure request

--TODO: add check for the phrase lengthfindByPhraseRequest :: T.Text -> BackendM Request
findByPhraseRequest :: T.Text -> BackendM Request
findByPhraseRequest "" = throwBackendError "Searching phrase cannot be empty"
findByPhraseRequest phrase = do
  key <- asks apiKey
  parseRequest $
    base
      <> "search?q="
      <> T.unpack phrase
      <> "&lang=en&country=us&max="
      <> show (5 :: Int)
      <> "&apikey="
      <> key

--TODO: add check for the keywords list length
findByWordsRequest :: [T.Text] -> BackendM Request
findByWordsRequest [] = throwBackendError "Keywords list cannot be empty"
findByWordsRequest (first : rest) = do
  key <- asks apiKey
  parseRequest $
    base
      <> "search?q="
      <> searchQuery
      <> "&lang=en&country=us&max="
      <> show (5 :: Int)
      <> "&apikey="
      <> key
  where
    searchQuery =
      "\"" <> T.unpack first <> "\""
        <> foldMap (\w -> " AND " <> "\"" <> T.unpack w <> "\"") rest
