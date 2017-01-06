describe JvmBytecode::Field do
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
      volatile: 0x0040,
      transient: 0x0080,
      synthetic: 0x1000,
      enum: 0x4000
    })
  end
end
