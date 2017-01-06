# should let target class instance as "instance"
shared_examples 'a class included AttributesField module' do
  it 'includes AttributesField module' do
    expect(described_class.include?(JvmBytecode::AttributesField)).to be_truthy
  end

  describe '#add_attribute' do
    let(:mock) { double(JvmBytecode::Attributes::Attribute) }
    subject { instance.add_attribute(mock) }

    it { is_expected.to be mock }
    it { expect { subject }.to change { instance.attributes.size }.by 1 }
  end

  describe '#attributes' do
    subject { instance.attributes }
    it { is_expected.to eq [] }
  end

  describe '#set_attributes' do
    let(:attrs) { [] }
    before { instance.set_attributes(attrs) }

    it 'sets attributes received' do
      expect(instance.attributes).to be attrs
    end
  end

  describe '#code' do
    let(:code_attr) { JvmBytecode::Attributes::Code }

    it 'adds Code attribute and eval' do
      expect(instance).to(
        receive(:add_attribute).with(instance_of(code_attr)).and_call_original
      )
      expect_any_instance_of(code_attr).to receive(:instance_eval)
      instance.code {}
    end
  end

  describe '#source_file' do
    let(:sf_attr) { JvmBytecode::Attributes::SourceFile }
    let(:filename) { 'FILENAME' }

    it 'adds SourceFile attribute and sets filename' do
      expect(instance).to(
        receive(:add_attribute).with(instance_of(sf_attr)).and_call_original
      )
      expect_any_instance_of(sf_attr).to receive(:filename).with(filename)
      instance.source_file(filename)
    end
  end
end

# should let target class instance as "instance"
shared_examples 'a class included AccessFlag module' do
  it 'includes AccessFlag module' do
    expect(described_class.include?(JvmBytecode::AccessFlag)).to be_truthy
  end

  describe '#all_access_flags' do
    subject { instance.all_access_flags }
    it { is_expected.to be_a Hash }
  end

  describe '#access_flag' do
    let(:flags) { [] }
    subject { instance.access_flag(*flags) }

    context 'when called at first' do
      it { is_expected.to be 0 }
    end

    context 'when called with args' do
      let(:flags) { instance.all_access_flags.keys }
      it { is_expected.to be instance.all_access_flags.values.reduce(0, &:|) } 
    end
  end

  describe '#set_access_flag' do
    let(:flag_value) { 0x1A2B }
    subject { instance.set_access_flag(flag_value) }

    it { is_expected.to be flag_value }
    it { expect { subject }.to change { instance.access_flag }.to flag_value }
  end

  describe '#readable_access_flag' do
    let(:flags) { instance.all_access_flags.keys }
    before { instance.access_flag(*flags) }
    subject { instance.readable_access_flag }

    it { is_expected.to eq flags }
  end
end
