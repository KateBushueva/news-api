module API.Request (Request (..)) where

import qualified Data.Text as T

data Request
  = FetchN Int
  | FindByAuthor T.Text
  | FindByTitle T.Text
  | FindByKeywords [T.Text]
  deriving (Show, Eq)
