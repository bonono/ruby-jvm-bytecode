describe JvmBytecode::Method do
  let(:cp) { JvmBytecode::ConstantPool.new }
  let(:instance) { described_class.new(cp) }

  it_behaves_like 'a class included AccessFlag module'
end
