module JvmBytecode
  class ConstantPool
    using Extensions

    def initialize
      @constants = []
    end

    def constant(index)
      @constants[index - 1]
    end

    def utf8(str)
      index = nil
      each_constants_of Constants::Utf8.tag do |utf8, i|
        index = i if utf8.to_s == str
      end

      index || add(Constants::Utf8.new(str))
    end

    def add_class(name)
      add(Constants::Class.new(index_or_utf8(name)))
    end

    def add_name_and_type(name, descriptor)
      add(
        Constants::NameAndType.new(index_or_utf8(name), index_or_utf8(descriptor))
      )
    end

    def add_method_ref(class_index, name_and_type_index)
      add(Constants::MethodRef.new(class_index, name_and_type_index))
    end

    def class_index(name)
      name_index = utf8(name)
      
      index = nil
      each_constants_of Constants::Class.tag do |klass, i|
        index = i if klass.name_index == name_index
      end

      index || raise(Errors::ConstantError, "Class constant named \"#{name}\" doesn't exist")
    end

    def each_constants_of(tag)
      @constants.each.with_index do |const, i|
        yield const, i + 1 if const.class.tag == tag
      end
    end

    def add(const)
      @constants.push(const).length
    end

    def index_or_utf8(v)
      v.is_a?(String) ? utf8(v) : v.to_i
    end

    def bytecode
      @constants.join_bytecodes { @constants.length + 1 }
    end

    def decode(io)
      entries = io.read(2).unpack('S>').first - 1

      @constants.clear
      entries.times do
        tag = io.read(1).unpack('C').first
        @constants << Constants::Constant.fetch(tag).decode(io)
      end
    end

    def to_hash
      @constants.map.with_index do |const, i|
        { 
          index: i + 1,
          type: const.class.name.split('::').last.gsub('Constant', '')
        }.merge(const.to_hash)
      end
    end
  end
end
