describe JvmBytecode::Constants::Class do
  let(:test_index) { 1 }
  let(:instance) { described_class.new(test_index) }

  describe '.tag' do
    subject { described_class.tag }
    it { is_expected.to be 7 }
  end

  describe '#name_index' do
    subject { instance.name_index }
    it { is_expected.to be test_index }
  end

  describe '#bytecode' do
    subject { instance.bytecode }
    it { is_expected.to eq([described_class.tag, test_index].pack('CS>')) }
  end 

  describe '#to_hash' do
    subject { instance.to_hash }
    it { is_expected.to eq({ type: 'Class', name_index: test_index }) }
  end
end 
