# frozen_string_literal: true

# Some characters you can recruit for your tests
module Recruit
  module_function

  def duck(**mapping)
    Duck.new(**mapping)
  end

  def spy(proxy_target = nil, permit_all_methods = false)
    Spy.new(proxy_target, permit_all_methods)
  end

  # Mostly just quacks like one
  class Duck
    def initialize(**mapping)
      mapping.each do |method_name, value|
        if mapping[method_name].respond_to?(:call)
          define_singleton_method(method_name, value)
        else
          define_singleton_method(method_name, &-> { mapping[method_name] })
          define_singleton_method(
            "#{method_name}=".to_sym,
            &->(val) { mapping[method_name] = val }
          )
        end
      end
    end
  end

  # Lets you can keep an eye on your ducks
  class Spy
    def initialize(proxy_target = nil, permit_all_methods = false)
      @report = Hash.new { |hash, key| hash[key] = [] }
      @proxy_target = proxy_target
      @permit_all_methods = permit_all_methods
    end

    def respond_to_missing?(method_name, *)
      permit_all_methods ? true : @proxy_target&.respond_to?(method_name) || super
    end

    def method_missing(method_name, *args, &block)
      @report[method_name] << [args, block]
      if @proxy_target&.respond_to?(method_name)
        @proxy_target.send(method_name, *args, &block)
      else
        super
      end
    rescue NoMethodError => e
      @permit_all_methods ? nil : e
    end
  end

  # It's the same thing, except cheaper and not very useful
  # def dupe(target, **_mapping)
  #   klass = target.is_a?(Class) ? target : target.class

  #   Class.new do
  #     target.public_methods.each do |method_name|
  #       define_singleton_method(
  #         method_name,
  #         *klass.method(method_name).parameters
  #       )
  #     end
  #   end
  # end

  # Will let you claim `fake('Lies').equal?(Lies)`
  def fake(
    class_name = 'Fake',
    super_class: Object,
    namespace: Object,
    avoid_collisions: false,
    &block
  )
    if avoid_collisions && namespace.const_defined?(class_name)
      throw NameError(
        "constant '#{class_name}' already defined for #{namespace}"
      )
    end

    namespace.const_set(class_name, Class.new(super_class, &block))
  end
end
