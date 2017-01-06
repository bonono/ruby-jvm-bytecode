module JvmBytecode
  module Constants
    class Ref < Constant
      attr_reader :class_index, :name_and_type_index

      def self.decode(io)
        indexes = io.read(4).unpack('S>2')
        new(*indexes)
      end

      def initialize(class_index, name_and_type_index)
        @class_index = class_index
        @name_and_type_index = name_and_type_index
      end

      def bytecode
        super + [@class_index, @name_and_type_index].pack('S>2')
      end

      def to_hash
        super.merge({
          class_index: @class_index,
          name_and_type_index: @name_and_type_index
        })
      end
    end
  end 
end
