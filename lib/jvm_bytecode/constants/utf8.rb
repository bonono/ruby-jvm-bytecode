module JvmBytecode
  module Constants
    class Utf8 < Constant
      define 1

      def self.decode(io)
        str = io.read(io.read(2).unpack('S>').first).force_encoding('UTF-8')
        new(str)
      end

      def initialize(str)
        raise "#{self.class} requires utf-8 string" unless str.encoding.to_s == 'UTF-8'
        @str = str
      end

      def to_s
        @str
      end

      def bytecode
        s = @str.dup.force_encoding('ASCII-8BIT')
        super + [s.length].pack('S>') + s
      end

      def to_hash
        super.merge({ string: @str })
      end
    end
  end 
end
