describe JvmBytecode::CommonDefinitionStructure do
  let(:cp) { JvmBytecode::ConstantPool.new }
  let(:instance) { described_class.new(cp) }

  it_behaves_like 'a class included AttributesField module'

  describe '#name' do
    let(:name) { 'N' }
    subject { instance.name(name) }
    it { is_expected.to be 1 }
  end

  describe '#descriptor' do
    let(:desc) { 'D' }
    subject { instance.descriptor(desc) }
    it { is_expected.to be 1 }
  end

  describe '#bytecode' do
    subject { instance.bytecode }
    before do
      instance.set_access_flag 0x1234
      instance.name 'N'
      instance.descriptor 'D'
      instance.source_file 'F'
    end

    it do
      is_expected.to eq(
        [0x1234, 0x01, 0x02, 0x01].pack('S>*') + instance.attributes.first.bytecode
      )
    end
  end

  describe '#decode' do
    let(:io) { StringIO.new([0x1234, 0x01, 0x02, 0x00].pack('S>*')) }
    subject { instance.tap { |i| i.decode(io) } }

    it { expect(subject.access_flag).to be 0x1234 }
    it { expect(subject.name).to be 1 }
    it { expect(subject.descriptor).to be 2 }

    it 'decodes attributes' do
      expect(JvmBytecode::Attributes::Attribute).to(
        receive(:decode_serial).with(cp, io).and_call_original
      )
      subject
    end
  end
end
