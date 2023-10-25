# news-api

A simple API for fetching news from [GNews](https://gnews.io/) service.

Please note, that current version doesn't support concurrency, tests, proper exceptions handling and needs more refactoring.

The service supports simple caching mechanism, which stores up to 10 last requests.

## How to start

1. Clone the repository
2. Before running you need to create a `local.config` file in the project root (use the `template.config` file as an example). In your `local.config` file "Your_GNews_API_key" value must be replaced with the API key that you get from GNews service (you may need to sing up)
3. Type `stack build` and after building completes call `stack run` in terminal from project root folder to build and run the application. The server will work on port 4008.

## How to use

The server gets http requests and returns JSON responses. To send requests you may use browsers, Postman, curl utility etc.

There are a few types of queries accepted:
- To get n articles - type `http://localhost:4008/fetchN?n=3` where 3 may be replaced with the number in range from 1 to 20
- To get articles by title - type `http://localhost:4008/findByTitle?title="Harry%20Potter"` where `"Harry Potter"` is the combination of words that must be included in article title (make sure to use double quotes here). The service will return up to 5 results.
- To get articles by keywords - type `http://localhost:4008/findByKeywords?keywords=Harry%20Potter,%20Daniel%20Radcliffe`, where `Harry%20Potter,%20Daniel%20Radcliffe` may be replaced by custom keywords separated by comma. The service takes only 3 first keywords and ignores the rest. Make sure you don't use any quotes in this request. The service will return up to 5 results.
- Getting article by authors doesn't work correctly for now, as GNews service doesn't provide this type of filtering. Need more time to implement this feature. For now the endpoint work the same way as findByTitle.

For the errors description please see the terminal output.
