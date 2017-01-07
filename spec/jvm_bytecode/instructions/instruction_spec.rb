describe JvmBytecode::Instructions::Instruction do
  let(:cp) { JvmBytecode::ConstantPool.new }
  let(:instance) { described_class.new(cp) }

  describe '.all' do
    subject { described_class.all.map(&:opcode).sort }

    it do
      is_expected.to eq(
        (0x00..0x0F).to_a +
        (0x1A..0x35).to_a +
        (0x3B..0x83).to_a +
        (0x85..0x98).to_a +
        (0xAC..0xB1).to_a +
        [0xB7]
      )
    end
  end

  describe '.fetch' do
    subject { described_class.fetch(opcode) }

    context 'when received valid opcode' do
      let(:opcode) { 0x00 }
      it { is_expected.to be JvmBytecode::Instructions::Nop}
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
