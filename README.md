# news-api

A simple API for fetching news from [GNews](https://gnews.io/) service.

Please note, that current version doesn't support concurrency, tests, proper exceptions handling and needs some refactoring.


## How to start

1. Clone the repository
2. Before running you need to create a `local.config` file in the project root (use the `template.config` file as an example). In your `local.config` file "Your_GNews_API_key" value must be replaced with the API key that you get from GNews service (you may need to sing up)
3. To run application type `stack run`. The server work on port 4008.

## How to use

The server gets http requests and returns JSON responses. To send requests you may use browsers, Postman, curl utility etc.

There are a few types of queries accepted:
- To get n articles - type `http://localhost:4008/fetchN?n=3` where 3 may be replaced with the number in range from 1 to 20
- To get articles by title - type `http://localhost:4008/findByTitle?title="Harry Potter"` where "Harry Potter" is the combination of words that must be included in article title
- To get articles by keywords - type ...
- Getting article by authors doesn't work correctly for now, as GNews service doesn't provide this type of filtering. Need more time to implement this feature.

