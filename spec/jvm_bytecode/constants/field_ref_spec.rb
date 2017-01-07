describe JvmBytecode::Constants::FieldRef do
  describe '.tag' do
    subject { described_class.tag }
    it { is_expected.to be 9 }
  end
end 
