module Vandelay
  module Buildable
    def self.included(base)

      # Set default values on the base class so buildables
      #  do not over write each other's defaults.
      base.send :class_variable_set, :@@_internal_hash, {}
      base.define_singleton_method(:__set_default) do |attribute, default|
        self.send(:class_variable_get, :@@_internal_hash)[attribute] = default
      end

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
        attribute_hash
      end

      private
      def attribute_hash
        @@_internal_hash ||= {}
      end

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

