describe JvmBytecode::Constants::NameAndType do
  let(:test_name_index) { 1 }
  let(:test_desc_index) { 2 }
  let(:instance) { described_class.new(test_name_index, test_desc_index) }

  describe '.tag' do
    subject { described_class.tag }
    it { is_expected.to be 12 }
  end

  describe '#name_index' do
    subject { instance.name_index }
    it { is_expected.to be test_name_index }
  end

  describe '#descriptor_index' do
    subject { instance.descriptor_index }
    it { is_expected.to be test_desc_index }
  end 

  describe '#bytecode' do
    subject { instance.bytecode }
    it { is_expected.to eq [described_class.tag, test_name_index, test_desc_index].pack('CS>*') }
  end

  describe '#to_hash' do
    subject { instance.to_hash }
    it do
      is_expected.to eq({
        type: 'NameAndType',
        name_index: test_name_index,
        descriptor_index: test_desc_index
      })
    end
  end
end 
