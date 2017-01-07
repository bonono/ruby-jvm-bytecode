describe JvmBytecode::Constants::MethodRef do
  describe '.tag' do
    subject { described_class.tag }
    it { is_expected.to be 10 }
  end
end 
