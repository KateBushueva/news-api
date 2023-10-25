module API.Cache (Cache, getFromCache, initCache, updateCache) where

import API.Request
import Common.Article

cacheLimit :: Int
cacheLimit = 10

type Entity = (Request, [Article])

newtype Cache = Cache [Entity]
  deriving (Show, Eq)

initCache :: Cache
initCache = Cache []

pushToCache :: Entity -> Cache -> Cache
pushToCache entity (Cache cache)
  | length cache < cacheLimit = Cache (entity : cache)
  | otherwise = Cache (entity : init cache)

getFromCache :: Request -> Cache -> Maybe [Article]
getFromCache _ (Cache []) = Nothing
getFromCache req (Cache (entity : rest)) =
  if fst entity == req
    then Just $ snd entity
    else getFromCache req (Cache rest)

updateCache :: Entity -> Cache -> Cache
updateCache entity (Cache cache) =
  let filtered = filter (/= entity) cache
   in pushToCache entity (Cache filtered)
