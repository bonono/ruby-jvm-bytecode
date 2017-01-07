describe JvmBytecode::Constants::InterfaceMethodRef do
  describe '.tag' do
    subject { described_class.tag }
    it { is_expected.to be 11 }
  end
end 
