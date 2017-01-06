module JvmBytecode
  # Module for a class that requires handling "attributes" field
  module AttributesField
    # Add an attribute
    #
    # @param a [JvmBytecode::Attributes::Attribute]
    # @return [JvmBytecode::Attributes::Attribute] added attribute
    def add_attribute(a)
      attributes.push(a).last
    end

    # @return [Array<vmBytecode::Attributes::Attribute>]
    def attributes
      @attributes ||= []
    end

    # Set attributes directly
    #
    # @param attrs [Array<JvmBytecode::Attributes::Attribute>]
    def set_attributes(attrs)
      @attributes = attrs
    end

    #
    # Following methods are defined to provide DSL-like syntax
    #

    # For "Code" attribute
    def code(&block)
      add_attribute(Attributes::Code.new(cp)).instance_eval(&block)
    end 

    # For SourceFile attribute
    def source_file(f)
      add_attribute(Attributes::SourceFile.new(cp)).filename(f)
    end
  end
end
