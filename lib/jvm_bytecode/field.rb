module JvmBytecode
  # Implementation for "field_info" structure
  # @see https://docs.oracle.com/javase/specs/jvms/se8/html/jvms-4.html#jvms-4.5
  class Field < CommonDefinitionStructure
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
  end
end
