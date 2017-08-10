module TypedForm
  # General utility functions used in multiple areas in the gem.
  class Util
    # Removes non-breaking spaces (character point 160) from TypeForm data
    # before beginning processing.
    def self.normalize_spaces(text)
      text.gsub(/(\\u00a0|\\xC2\\xA0)/, " ").gsub(/[[:space:]]/, " ")
    end
  end
end
