{-# LANGUAGE DeriveAnyClass #-}

module Common.Article
  ( Article (..),
    Response (..),
  )
where

import Data.Aeson
import qualified Data.ByteString.Lazy as LBS
import qualified Data.Text as T
import GHC.Generics (Generic)

data Article
  = Article
      { title :: T.Text,
        description :: T.Text,
        url :: T.Text
      }
  deriving (Show, Eq, Generic, FromJSON, ToJSON)

data Response
  = Response
      { totalArticles :: Int,
        articles :: [Article]
      }
  deriving (Show, Eq, Generic, FromJSON, ToJSON)
