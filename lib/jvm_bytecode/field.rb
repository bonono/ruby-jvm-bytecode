module JvmBytecode
  # Implementation for "field_info" structure
  # @see https://docs.oracle.com/javase/specs/jvms/se8/html/jvms-4.html#jvms-4.5
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

    # Decode concatenated "field_count" and "fields"
    #
    # @param cp [JvmBytecode::ConstantPool]
    # @param io [IO]
    # @return [Array<JvmBytecode::Field>]
    def self.decode_serial(cp, io)
      Array.new(io.read(2).unpack('S>').first) do 
        new(cp).tap { |f| f.decode(io) }
      end
    end

    attr_reader :cp

    def initialize(cp)
      @cp = cp
      @name = 0
      @descriptor = 0
    end

    # Setter and getter for name_index
    #
    # @param n [Integer, String]
    # @return [Integer]
    def name(n = nil)
      @name = cp.index_or_utf8(n) if n
      @name
    end

    # Setter and getter for descriptor_index
    #
    # @param d [Integer, String]
    # @return [Integer]
    def descriptor(d = nil)
      @descriptor = cp.index_or_utf8(d) if d
      @descriptor
    end

    # Return bytecode
    #
    # @return [String] ASCII-8BIT string
    def bytecode
      [access_flag, @name, @descriptor].pack('S>3') + attributes.join_bytecodes
    end

    # Decode bytecode
    #
    # @param io [IO]
    def decode(io)
      acc_flag, @name, @descriptor = io.read(6).unpack('S>3')
      set_access_flag(acc_flag)
      set_attributes(Attributes::Attribute.decode_serial(cp, io))
    end

    # @return [Hash]
    def to_hash
      {
        access_flag: readable_access_flag,
        name_index: name,
        descriptor_index: descriptor,
        attributes: attributes.map(&:to_hash)
      }
    end
  end
end
