# frozen_string_literal: true

module Speq
  module Recruit
    # Mostly just quacks like one
    class Duck
      def initialize(**mapping)
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
    end

    # Lets you can keep an eye on your ducks
    class Spy
      def initialize(proxy_target = nil, permit_all_methods = false)
        @calls = Hash.new { |hash, key| hash[key] = [] }
        @proxy_target = proxy_target
        @permit_all_methods = permit_all_methods
      end

      def record(method_name, *args, &block)
        @calls[method_name] << [args, block]
      end

      def method_missing(method_name, *args, &block)
        record(method_name, *args, &block)
        if @proxy_target&.respond_to?(method_name)
          @proxy_target.send(method_name, *args, &block)
        else
          super
        end
      rescue NoMethodError => e
        @permit_all_methods ? nil : e
      end
    end

    # Will let you claim `fake('Lies').equal?(Lies)`
    def self.fake(class_name = 'Fake', super_class: Object, namespace: Object, avoid_collisions: false, &block)
      if avoid_collisions && namespace.const_defined?(class_name)
        raise NameError, "constant '#{class_name}' is already defined for #{namespace}"
      end

      namespace.const_set(class_name, Class.new(super_class, &block))
    end
  end
end
