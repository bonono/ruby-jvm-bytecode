describe JvmBytecode::Instructions::Instruction do
  let(:cp) { JvmBytecode::ConstantPool.new }
  let(:instance) { described_class.new(cp) }

  describe '.all' do
    subject { described_class.all.map(&:opcode).sort }

    it do
      is_expected.to eq [
        0x1A, 0x1B, 0x1C, 0x1D,
        0x2A, 0x2B, 0x2C, 0x2D,
        0x60,
        0xAC,
        0xB1,
        0xB7
      ]
    end
  end

  describe '.fetch' do
    subject { described_class.fetch(opcode) }

    context 'when received valid opcode' do
      let(:opcode) { 0x60 }
      it { is_expected.to be JvmBytecode::Instructions::IAdd}
    end

    context 'when received invalid opcode' do
      let(:opcode) { 0xFFFF }
      it { expect { subject }.to raise_error(JvmBytecode::Errors::OpcodeError) }
    end
  end

  describe '#bytecode' do
    subject { instance.bytecode }
    before { allow(described_class).to receive(:opcode).and_return 0xAB }

    it { is_expected.to eq 0xAB.chr }
  end

  describe '#to_hash' do
    subject { instance.to_hash }
    before do 
      allow(described_class).to receive(:mnemonic).and_return 'mm'
      allow(described_class).to receive(:opcode).and_return 0xAB
    end

    it { is_expected.to eq({ mnemonic: 'mm', opcode: '0xAB' }) }
  end
end
