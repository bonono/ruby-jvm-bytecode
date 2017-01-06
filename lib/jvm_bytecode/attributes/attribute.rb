module JvmBytecode
  module Attributes
    # Base class for implementation of Attributes
    # https://docs.oracle.com/javase/specs/jvms/se8/html/jvms-4.html#jvms-4.7
    class Attribute
      using Extensions

      class << self
        attr_reader :attr_name, :locations
        
        # @param name [String, nil]
        # @param location [Array<Symbol>]
        def define(name: nil, location:)
          @attr_name = name || shortname.encode('UTF-8')
          @locations = location

          @@attributes ||= {}
          @@attributes[@attr_name] = self
        end

        # Get attribute class speficified by argument
        #
        # @param attr_name [String]
        # @raise [JvmBytecode::Errors::AttributeError]
        # @return [JvmBytecode::Attributes::Attribute]
        def fetch(attr_name)
          @@attributes[attr_name] || raise(Errors::AttributeError, "#{attr_name} is not implemented")
        end

        # @return [Array<JvmBytecode::Attributes::Attribute>]
        def all
          @@attributes.values
        end

        # Decode bytecode concatenates "attributes_count" and "attributes" fields
        #
        # @param cp [JvmBytecode::ConstantPool]
        # @param io [IO]
        # @return [Array<JvmBytecode::Attributes::Attribute>]
        def decode_serial(cp, io)
          n = io.read(2).unpack('S>').first
          Array.new(n) do
            name_index = io.read(2).unpack('S>').first
            fetch(cp.constant(name_index).to_s).new(cp).tap { |a| a.decode(io) }
          end
        end
      end

      attr_reader :cp

      def initialize(cp)
        @cp = cp
      end

      # Return bytecode
      #
      # @return [String] ASCII-8BIT string
      def bytecode
        bc = additional_bytecode
        [cp.utf8(self.class.attr_name), bc.length].pack('S>I>') + bc
      end

      # @return [Hash]
      def to_hash
        {
          type: self.class.attr_name
        }
      end

      protected 

      # Subclass should implement this method to return bytecode
      #
      # @return [String]
      def additional_bytecode
        ''
      end
    end
  end
end
