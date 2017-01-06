module JvmBytecode
  # Implementation for "method_info" structure
  # @see https://docs.oracle.com/javase/specs/jvms/se8/html/jvms-4.html#jvms-4.6
  class Method < CommonDefinitionStructure
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
  end
end
