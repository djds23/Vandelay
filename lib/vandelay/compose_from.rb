module Vandelay
  module ComposeFrom
    def self.extended(base)
      base.extend ClassMethods
      base.define_singleton_method(:compose_from) do |from_name, attributes|
        from_name = __underscore(from_name)
        define_method("compose_from_#{from_name}") do |instance|
          attributes.each do |attr|
            setter_name = "set_#{attr}"
            if self.respond_to?(setter_name) && instance.respond_to?(attr)
              self.send(setter_name, instance.send(attr))
            else
              warn %{
                Builder #{base.class.name} or instance #{instance.class.name} do not respond to expected message: #{attr}."
              }.strip
            end
          end

          self
        end
      end
    end

    module ClassMethods
      # Stub for documentation
      #
      # @param [String] from_name the name of the object you will be composing from.
      #   IE: compose from 'MiniCooper' => compose_from_mini_cooper(mini_cooper, [:wheels, :doors])
      # @param  [Array] attributes an array of attributes to be taken from an
      #   instance of a class to the new class
      def compose_from(from_name, attributes)
      end

      def __underscore(string)
        if string.respond_to? :underscore
          string.underscore
        else
          string.gsub(/::/, '/').
          gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
          gsub(/([a-z\d])([A-Z])/,'\1_\2').
          tr("-", "_").
          downcase
        end
      end
    end
  end
end

