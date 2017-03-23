# Change Log

### [0.1.6] - 2017-03-22

Fixes NoMethodError: undefined method `[]' for nil:NilClass error when normalizing optional date fields that are left blank (which translates to nil in Typeform Data).

### [0.1.5] - 2017-03-20

Update Arendelle.

Arendelle 0.1.1 introduced a change in their naming of instance
variables in order to support ivars that start with numbers. This
updates the ivar behavior (which relies on a private implementation
detail to handle Typeform's bizarre multiple choice question format).

### [0.1.4] - 2017-03-16

Strips additional whitespace and isolates whitespace stripping behavior to a Util class, to allow for easier test coverage. Adds raw_json accessors to models where we normalize JSON input to allow for end-users to determine whether they want clean/normalized JSON or the original results from Typeform. This prevents mismatches in the regular expression => attribute matching in VirtualModel, which were running into issues when `" " != " "`, preventing the regular expressions from matching.

### [0.1.3] - 2017-03-16

Adds support for typecasting Yes/No and Terms of Service fields in TypedForm::VirtualModel. Adds "original_answer" field to Questions to preserve original values, either for debugging purposes or for situations where typecasting is not desirable.  

## [0.1.2] - 2017-03-13

Strips non-breaking whitespace ("\\u00a0") character from typeform data to normalize question/answer searching. Adds support for typecasting date, datetime, and integer objects from Typeform Responses & metadata.

## [0.1.1] - 2017-03-12

Adds support for TypedForm::VirtualModel. Adds a decorator-like model which allows user-defined VirtualModels which respond with Typeform Data values.

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

