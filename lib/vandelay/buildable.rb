module Vandelay
  module Buildable
    def self.included(base)
      base.send :class_variable_set, :@@_internal_hash, {}
      base.define_singleton_method(:__set_default) do |attribute, default|
        puts self.send(:class_variable_get, :@@_internal_hash)
        self.send(:class_variable_get, :@@_internal_hash)[attribute] = default
      end
      base.instance_eval <<-RUBY
        def attribute_hash
          self.send(:class_variable_get, :@@_internal_hash)
        end
      RUBY

      base.send :include, InstanceMethods
      base.extend ClassMethods
    end

    module InstanceMethods

      # Returns a hash of all the attributes & their set values.
      # Best to practice would be to override this for your required formats.
      #
      # def build
      #   base = super
      #
      #   {
      #     extra_fields: 'my_values',
      #     buildable: base
      #   }
      # end
      #
      # @return [Hash] filled with attributes and set values
      def build
        puts self
        attribute_hash
      end

      private
      def update_attribute_hash(attribute, value)
        attribute_hash[attribute] = value
      end
    end

    module ClassMethods

      # @param [Array] attributes fields that ought to be set on the builder
      # @option [Object] default
      def composed_of(*attributes, default: nil)
        attributes.each do |attribute|
          compose_setter(attribute, default)
        end
      end

      private
      def compose_setter(attribute, default)
        __set_default(attribute, default)
        define_method("set_#{attribute}") do |value|
          instance_variable_set("@#{attribute}", value)
          update_attribute_hash(attribute, value)

          self
        end
      end
    end
  end
end

