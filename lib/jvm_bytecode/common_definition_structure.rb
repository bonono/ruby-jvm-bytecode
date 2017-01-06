module JvmBytecode
  # "method_info" and "field_info" has common structure.
  # So, The classes that implement these structure inherit this class.
  #
  # @see https://docs.oracle.com/javase/specs/jvms/se8/html/jvms-4.html#jvms-4.5 field_info
  # @see https://docs.oracle.com/javase/specs/jvms/se8/html/jvms-4.html#jvms-4.6 method_info
  class CommonDefinitionStructure
    using Extensions
    include AccessFlag
    include AttributesField

    # Decode bytecode concatenates structure length and structures
    #
    # @param cp [JvmBytecode::ConstantPool]
    # @param io [IO]
    # @return [Array<JvmBytecode::CommonDefinitionStructure>]
    def self.decode_serial(cp, io)
      Array.new(io.read(2).unpack('S>').first) do
        new(cp).tap { |cds| cds.decode(io) }
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
