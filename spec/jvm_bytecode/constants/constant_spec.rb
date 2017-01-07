describe JvmBytecode::Constants::Constant do
  let(:instance) { described_class.new }

  describe '.fetch' do
    subject { described_class.fetch(tag) }

    context 'when received valid tag' do
      let(:tag) { JvmBytecode::Constants::Utf8.tag }
      it { is_expected.to be JvmBytecode::Constants::Utf8 }
    end

    context 'when received invalid tag' do
      let(:tag) { 0xFFF }
      it { expect { subject }.to raise_error(JvmBytecode::Errors::ConstantError) }
    end
  end

  describe '#bytecode' do
    subject { instance.bytecode }
    before { allow(described_class).to receive(:tag).and_return 0x12 }

    it { is_expected.to eq 0x12.chr }
  end

  describe '#bytecode' do
    subject { instance.to_hash }
    it { is_expected.to eq({ type: 'Constant' }) }
  end
end
