module Common.Handle (Handle (..)) where

import Data.Text as T

type Article = String

data Handle m
  = Handle
      { getNNews :: Int -> m Article,
        searchByAuthor :: T.Text -> m [Article],
        searchByTitle :: T.Text -> m [Article],
        searchByKeywords :: [T.Text] -> m [Article]
      }
