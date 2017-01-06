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

      def bytecode
        super + [@name_index].pack('S>')
      end

      def to_hash
        super.merge({ name_index: @name_index })
      end
    end
  end 
end
