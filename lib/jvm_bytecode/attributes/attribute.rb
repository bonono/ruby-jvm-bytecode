module JvmBytecode
  module Attributes
    # Base class for implementation of Attributes
    # https://docs.oracle.com/javase/specs/jvms/se8/html/jvms-4.html#jvms-4.7
    class Attribute
      using Extensions

      class << self
        attr_reader :attr_name, :locations
        
        def define(name: nil, location:)
          @attr_name = name || shortname.encode('UTF-8')
          @locations = location

          @@attributes ||= {}
          @@attributes[@attr_name] = self
        end

        def fetch(attr_name)
          @@attributes[attr_name] || raise(Errors::AttributeError, "#{attr_name} is not implemented")
        end

        def all
          @@attributes.values
        end

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

      def additional_bytecode
        raise NotImplementedError, "#{self.class}##{__method__} is not implemented!"
      end

      def bytecode
        bc = additional_bytecode
        [cp.utf8(self.class.attr_name), bc.length].pack('S>I>') + bc
      end
    end
  end
end
