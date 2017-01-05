module JvmBytecode
  module Constants
    class NameAndType < Constant
      define 12

      attr_reader :name_index, :descriptor_index

      def self.decode(io)
        indexes = io.read(4).unpack('S>2')
        new(*indexes)
      end

      def initialize(name_index, descriptor_index)
        @name_index = name_index
        @descriptor_index = descriptor_index
      end

      def additional_bytecode
        [@name_index, @descriptor_index].pack('S>2')
      end

      def to_hash
        {
          name_index: @name_index,
          descriptor_index: @descriptor_index
        }
      end
    end
  end 
end
