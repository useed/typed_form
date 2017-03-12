# Change Log

## [0.1.0] - 2017-03-12

Adds logic for extracting data needed for Data API from incoming Webhooks. 

Adds YARD documentation to gem.

Separates API/Client, Data-API Form Data, and Form/Webhook responsibilities into isolated namespaces. Stabilizes Gem API around accessing form data via 
API and loading from existing JSON data sources.

## [0.0.4] - 2017-03-10

Defaults to freezing Questions after initialization, to prevent concerns with mutating data inadvertently when working with questions as value objects.

## [0.0.3] - 2017-03-10

Bugfixes for Question#type. Adds minimal error propagation in event Typeform's 
data is unreliable around question type inference in the future.

## [0.0.2] - 2017-03-10

Added support for interpolated questions (what Typeform refers to as "piping") and for string conversion of multiple choice answers to a single CSV format.

## [0.0.1] - 2017-03-09

Initial version released. Added initial support for retrieving results from Typeform Data API. 

