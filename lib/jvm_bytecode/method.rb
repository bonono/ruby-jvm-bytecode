module JvmBytecode
  class Method
    using Extensions
    include AccessFlag

    ACCESS_FLAGS = {
      public: 0x0001,
      private: 0x0002,
      protected: 0x0004,
      static: 0x0008,
      final: 0x0010,
      syncrhonized: 0x0020,
      bridge: 0x0040,
      varargs: 0x0080,
      native: 0x0100,
      abstract: 0x0400,
      strict: 0x0800,
      synthetic: 0x1000
    }.freeze 

    def self.decode_serial(cp, io)
      Array.new(io.read(2).unpack('S>').first) do 
        new(cp).tap { |m| m.decode(io) }
      end
    end

    def initialize(cp)
      @cp = cp
      @name = 0
      @descriptor = 0
      @attributes = []
    end

    def name(n)
      @name = @cp.index_or_utf8(n)
    end

    def descriptor(d)
      @descriptor = @cp.index_or_utf8(d)
    end

    def code(&block)
      @attributes
        .push(Attributes::Code.new(@cp))
        .last
        .instance_eval(&block)
    end

    def bytecode
      [access_flag, @name, @descriptor].pack('S>*') + @attributes.join_bytecodes
    end

    def decode(io)
      acc_flag, @name, @descriptor = io.read(6).unpack('S>3')
      set_access_flag(acc_flag)

      @attributes = Attributes::Attribute.decode_serial(@cp, io)
    end

    def to_hash
      {
        name_index: @name,
        descriptor_index: @descriptor,
        access_flag: access_flag,
        attributes: @attributes.map(&:to_hash)
      }
    end
  end
end
