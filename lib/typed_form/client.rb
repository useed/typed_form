module TypedForm
  class Client
    attr_reader :api_key

    include HTTParty

    def initialize(api_key:)
      @api_key = api_key
    end

    def form_responses(form_id:, **query_params)
      url_params = query_params.map { |k, v| "#{k}=#{v}" }
      get [form_id, authenticated_slug(url_params)].join("?")
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
