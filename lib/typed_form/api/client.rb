module TypedForm
  module API
    class Client
      attr_reader :api_key

      include HTTParty

      def initialize(api_key:)
        @api_key = api_key
      end

      def forms_by_id(form_id:, **query_params)
        url_params = query_params.map { |k, v| "#{k}=#{v}" }
        request_url = [form_id, authenticated_slug(url_params)].join("?")
        get(request_url).body
      end

      def find_form_by(form_id:, token:, **query_params)
        forms_by_id(form_id: form_id, token: token, **query_params)
      end

      private

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
