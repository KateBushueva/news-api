module API.Logic (handleRequest) where

import API.Cache
import API.Request
import Common.Article
import Common.Handle

handleRequest :: Monad m => Request -> Cache -> Handle m -> m (Cache, [Article])
handleRequest request cache backendHandle = do
  case getFromCache request cache of
    Just articles -> do
      let updatedCache = updateCache (request, articles) cache
      pure (updatedCache, articles)
    _ -> do
      articles <- getArticlesFromBackend backendHandle request
      let updatedCache = updateCache (request, articles) cache
      pure (updatedCache, articles)

getArticlesFromBackend :: Handle m -> Request -> m [Article]
getArticlesFromBackend Handle {..} request = do
  case request of
    FetchN n -> getNNews n
    FindByAuthor author -> searchByAuthor author
    FindByTitle title -> searchByTitle title
    FindByKeywords keywords -> searchByKeywords keywords
