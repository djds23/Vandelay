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
      #   def build
      #     base = super
      #
      #     {
      #       extra_fields: 'my_values',
      #       buildable: base
      #     }
      #   end
      #
      # This could also be used to build a new object
      #
      #   class CarBuilder
      #     include Vandelay::Buildable
      #     made_of :wheels, :doors
      #
      #     def get_car
      #       Car.new(build)
      #     end
      #   end
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

      # Method used to declare fields which will get implemented in the builder.
      # Accepts a default argument that will be used if no value is set.
      #
      # @param [Array] attributes fields that ought to be set on the builder
      # @param [Object] default the default value for all passed attributes
      # @return [void]
      def made_of(*attributes, default: nil)
        attributes.each do |attribute|
          compose_setter(attribute, default)
        end
      end

      # Stub for documentation
      #
      # @param [Symbol] attribute fields built in the internal hash
      # @param [Object] default the default value for those fields
      def __set_default
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

