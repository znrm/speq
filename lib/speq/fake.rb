module Speq
  # The Fake class is a lightweight, general-purpose test double
  class Fake
    def initialize(mapping)
      mapping.each do |method_name, return_value|
        define_singleton_method(method_name, &infer_method_body(return_value))
      end
    end

    def infer_method_body(return_value)
      if return_value.respond_to?(:call)
        return_value
      else
        -> { return_value }
      end
    end

    def to_s
      'a fake'
    end
  end
end
