module JvmBytecode
  module AttributesField
    def add_attribute(a)
      attributes.push(a).last
    end

    def attributes
      @attributes ||= []
    end

    def set_attributes(attrs)
      @attributes = attrs
    end

    def code(&block)
      add_attribute(Attributes::Code.new(cp)).instance_eval(&block)
    end 

    def source_file(f)
      add_attribute(Attributes::SourceFile.new(cp)).filename(f)
    end
  end
end
