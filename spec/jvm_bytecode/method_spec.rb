describe JvmBytecode::Method do
  let(:cp) { JvmBytecode::ConstantPool.new }
  let(:instance) { described_class.new(cp) }

  it_behaves_like 'a class included AccessFlag module'

  it 'has ACCESS_FLAGS constant' do
    expect(described_class::ACCESS_FLAGS).to eq({
      public: 0x0001,
      private: 0x0002,
      protected: 0x0004,
      static: 0x0008,
      final: 0x0010,
      synchronized: 0x0020,
      bridge: 0x0040,
      varargs: 0x0080,
      native: 0x0100,
      abstract: 0x400,
      strict: 0x0800,
      synthetic: 0x1000
    })
  end
end
