module JvmBytecode
  module Attributes
    class SourceFile < Attribute
      define location: [:class_file]

      def filename(f)
        @filename = cp.index_or_utf8(f)
      end

      def additional_bytecode
        [@filename].pack('S>')
      end

      def decode(io)
        io.read(4) # discard length
        @filename = io.read(2).unpack('S>').first
      end

      def to_hash
        {}
      end
    end
  end
end
