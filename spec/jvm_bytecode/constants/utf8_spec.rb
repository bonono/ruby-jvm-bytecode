describe JvmBytecode::Constants::Utf8 do
  let(:test_string) { 'TEST' }
  let(:instance) { described_class.new(test_string) }

  describe '.tag' do
    subject { described_class.tag }
    it { is_expected.to be 1 }
  end

  describe '#to_s' do
    subject { instance.to_s }
    it { is_expected.to eq test_string }
  end

  describe '#bytecode' do
    subject { instance.bytecode }
    it do 
      is_expected.to eq(
        [described_class.tag, 4].pack('CS>') + test_string.force_encoding('ASCII-8BIT')
      )
    end
  end 

  describe '#to_hash' do
    subject { instance.to_hash }
    it { is_expected.to eq({ type: 'Utf8', string: test_string }) }
  end
end 
