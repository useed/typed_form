module TypedForm
  # Objects related to working with the Typeform API.
  module API
    # API wrapper for querying typeform's Data API.
    # @attr [String] api_key Your Typeform API key.
    # @see https://www.typeform.com/help/data-api/ Typeform Data API docs
    class Client
      attr_reader :api_key

      include HTTParty

      # Creates a new instance of an API client for querying the
      # Typeform Data API.
      # @param [String] api_key Typeform API Key
      def initialize(api_key:)
        @api_key = api_key
      end

      # Queries the Typeform Data API /form/ endpoint to retrieve a specific
      # response (filtered by token) for a specific Form.
      #
      # @param [String] form_id Typeform Form ID
      # @param [String] token The token for the form response you are querying
      # @param [Hash<Object>] query_params Splats and passes along query
      # parameters to the form's query. See
      # https://www.typeform.com/help/data-api/ under Filtering Options for
      # more information.
      def find_form_by(form_id:, token:, **query_params)
        forms_by_id(form_id: form_id, token: token, **query_params)
      end

      private

      def forms_by_id(form_id:, **query_params)
        url_params = query_params.map { |k, v| "#{k}=#{v}" }
        request_url = [form_id, authenticated_slug(url_params)].join("?")
        get(request_url).body
      end

      def get(slug)
        self.class.get(base_url + slug)
      end

      def base_url
        "https://api.typeform.com/v1/form/"
      end

      def authenticated_slug(url_params)
        ["key=#{api_key}", url_params].join("&")
      end
    end
  end
end
