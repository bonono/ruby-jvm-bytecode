module JvmBytecode
  module Constants
    class Class < Constant
      define 7

      attr_reader :name_index

      def self.decode(io)
        new(io.read(2).unpack('S>').first)
      end

      def initialize(name_index)
        @name_index = name_index
      end

      def additional_bytecode
        [@name_index].pack('S>')
      end

      def to_hash
        { name_index: @name_index }
      end
    end
  end 
end
