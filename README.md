# TypedForm

TypedForm is a simple wrapper for the [Typeform Data API](https://www.typeform.com/help/data-api/) to expose a simple Q&A format from their JSON schema.

The API interface is intentionally kept very minimalistic; the remainder of functionality will be in processing and rebuilding their data format into a format that is usable for a variety of applications (our use case: providing a Q&A view format from cached data-API results).

For a more robust API wrapper, you may want to investigate [TypeformData](https://github.com/shearwaterintl/typeform_data) or other wrappers.

## Why?

TypedForm was created out of a simple desire: to display a full set of questions and answers provided via a completed survey. Typeform's Data API schema is robust, but delivers data in a format that requires some quite a bit of work to make sense of. For example, the typeform API delivers questions and answers that use [piping](https://www.typeform.com/help/piping/) in the following format (only showing relevant data for this example - their API provides much more data than included below):

```
# typeform_response.json

"questions" [
  {
    "id": "list_p0Qz_choice",
    "question": "I am applying on behalf of:",
    "field_id": 44763792
  },
  {
    "id": "textfield_goYz",
    "question": "What is the name of your {{answer_44763792}}?",
    "field_id": 44763783
  },
  {
    "id": "list_fprR_choice",
    "question": "Does {{answer_44763783}} have an advisor (coach, department head, etc)?",
    "field_id": 44763793
  }
],

"responses": [
  {
    "answers": {
      "list_p0Qz_choice": "Program or Academic Unit",
      "textfield_goYz": "Rory for President 2017",
      "list_fprR_choice": "Yes -- that's me!"
  }
]
```

In addition to piping/interpolation, Typeform's data is structured in a difficult-to-use manner (that's putting it nicely) when it comes to associating answers with questions on "choice" questions; we seek to remedy this by building arrays from choice values, and building a single canonical question with multiple answers associated with the question.

Finally, if you've ever tried to duplicate a Typeform Form, you'll notice that their response field IDs completely change, and can no longer be used for locating answers. This gem attempts to solve that as well, by associating questions and answers together based on their results.

Take a look at https://github.com/useed/typed_form/tree/master/spec/fixtures for examples of what you can expect when it comes to their data API; this should help shed some additional light on the purpose behind this gem.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'typed_form'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install typed_form

## Usage

With TypedForm, you can easily extrapolate answers from the data provided into the question, and give your questions a simple interface for accessing the extrapolated (and original) question and answer format:

```ruby
# Your typeform API key -- keep this a secret!
api_key = "api_key"

# Your typeform form ID
form_id = "typeform_form_id"

# individual response token, provided in responses hash or via webhook data
token = "form_token" 

client = TypedForm::Client.new(api_key: api_key)
json = client.find_form_by(form_id: form_id, token: token)
  => # json response for that specific form submission

parsed = TypedForm::JSONResponseHandler.new(json)
form = TypedForm::FormResponse.new(parsed_questions: parsed.questions,
                                   parsed_response: parsed.response.first)
questions = form.questions

questions.first.text
 => "What is the name of your Program or Academic Unit?"

questions.first.original_text
 => "What is the name of your {{answer_44763792}}?"

questions.first.answer
 => "Rory for President 2017"

questions.first.type
 => "textfield"
```


The most common use case for this is extrapolating question and answers into a simple object that can provide a clean interface for displaying them. Question type information can be used to allow helpers to format and display different field types (most specifically dates) in a more user-friendly format.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/useed/typed_form. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
