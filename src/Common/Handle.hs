module Common.Handle (Handle (..)) where

import Common.Article
import Data.Text as T

data Handle m
  = Handle
      { getNNews :: Int -> m [Article],
        searchByAuthor :: T.Text -> m [Article],
        searchByTitle :: T.Text -> m [Article],
        searchByKeywords :: [T.Text] -> m [Article]
      }
