describe JvmBytecode::Constants::Ref do
  let(:test_class_index) { 1 }
  let(:test_name_and_type_index) { 2 }
  let(:instance) { described_class.new(test_class_index, test_name_and_type_index) }

  before { allow(described_class).to receive(:tag).and_return 0xFF }

  describe '#class_index' do
    subject { instance.class_index }
    it { is_expected.to be test_class_index }
  end

  describe '#name_and_type_index' do
    subject { instance.name_and_type_index }
    it { is_expected.to be test_name_and_type_index }
  end 

  describe '#bytecode' do
    subject { instance.bytecode }
    it { is_expected.to eq [0xFF, test_class_index, test_name_and_type_index].pack('CS>*') }
  end

  describe '#to_hash' do
    subject { instance.to_hash }
    it do
      is_expected.to eq({
        type: 'Ref',
        class_index: test_class_index,
        name_and_type_index: test_name_and_type_index
      })
    end
  end
end 
