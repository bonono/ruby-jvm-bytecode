module JvmBytecode
  class ClassFile
    using Extensions
    include AccessFlag

    MAGIC_NUMBER = [0xCA, 0xFE, 0xBA, 0xBE].pack('C4').freeze
    ACCESS_FLAGS = {
      public: 0x0001,
      final: 0x0010,
      super: 0x0020,
      interface: 0x0200,
      abstract: 0x0400,
      synthetic: 0x1000,
      anotation: 0x2000,
      enum: 0x4000
    }.freeze

    def self.decode(io)
      new.tap { |cf| cf.decode(io) }
    end

    def initialize(&block)
      @cp = ConstantPool.new

      @minor_ver = 0
      @major_ver = 52

      @this_class = nil
      @super_class = nil

      @interfaces = []
      @fields = []
      @methods = []
      @attributes = []

      self.instance_eval(&block) if block_given?
    end

    def constant_pool(&block)
      @cp.tap { |cp| cp.instance_eval(&block) if block_given? }
    end

    def minor_version(v)
      @minor_ver = v
    end

    def major_version(v)
      @major_ver = v
    end 

    def this_class(name)
      @this_class = @cp.class_index(name)
    end

    def super_class(name)
      @super_class = @cp.class_index(name)
    end

    def new_method
      Method.new(@cp)
    end

    def add_method(m)
      @methods.push(m).last
    end

    def method_definition(&block)
      add_method(new_method).tap { |m| m.instance_eval(&block) if block_given?}
    end

    def source_file(filename)
      @attributes << Attributes::SourceFile.new(@cp).tap do |a|
        a.filename(filename)
      end
    end

    def bytecode
      version    = [@minor_ver, @major_ver].pack('S>*')
      classes    = [access_flag, @this_class, @super_class].pack('S>*')
      interfaces = ([@interfaces.length] + @interfaces).pack("S>*")
      fields     = @fields.join_bytecodes
      methods    = @methods.join_bytecodes
      attributes = @attributes.join_bytecodes

      MAGIC_NUMBER + version + @cp.bytecode + classes + interfaces + fields + methods + attributes
    end

    def decode(io)
      raise Errors::DecodeError, 'Not class file' if io.read(4) != MAGIC_NUMBER

      @minor_ver, @major_ver = io.read(4).unpack('S>2')

      @cp.decode(io)

      acc_flag, @this_class, @super_class = io.read(6).unpack('S>3')
      set_access_flag(acc_flag)

      if_count = io.read(2).unpack('S>').first
      @interfaces = io.read(if_count * 2).unpack("S>#{if_count}")

      @fields = Field.decode_serial(@cp, io)
      @methods = Method.decode_serial(@cp, io)
    end

    def to_hash
      {
        minor_version: @minor_ver,
        major_version: @major_ver,
        constant_pool: @cp.to_hash,
        access_flag: readable_access_flag,
        this_class: @this_class,
        super_class: @super_class,
        methods: @methods.map(&:to_hash)
      }
    end
  end
end
