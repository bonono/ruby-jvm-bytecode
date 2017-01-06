module JvmBytecode
  class Field
    using Extensions
    include AccessFlag
    include AttributesField

    ACCESS_FLAGS = {
      public: 0x0001,
      private: 0x0002,
      protected: 0x0004,
      static: 0x0008,
      final: 0x0010,
      volatile: 0x0040,
      transient: 0x0080,
      synthetic: 0x1000,
      enum: 0x4000
    }.freeze 

    def self.decode_serial(cp, io)
      Array.new(io.read(2).unpack('S>').first) do 
        new(cp).tap { |f| f.decode(io) }
      end
    end

    def initialize(cp)
      @cp = cp
      @name = 0
      @descriptor = 0
    end

    def name(n)
      @name = @cp.index_or_utf8(n)
    end

    def descriptor(d)
      @descriptor = @cp.index_or_utf8(d)
    end

    def bytecode
      [access_flag, @name, @descriptor].pack('S>3') + attributes.join_bytecodes
    end

    def decode(io)
      acc_flag, @name, @descriptor = io.read(6).unpack('S>3')
      set_access_flag(acc_flag)
      set_attributes(Attributes::Attribute.decode_serial(@cp, io))
    end

    def to_hash
      {}
    end
  end
end
