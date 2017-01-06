describe JvmBytecode::Field do
  let(:cp) { JvmBytecode::ConstantPool.new }
  let(:instance) { described_class.new(cp) }

  it_behaves_like 'a class included AccessFlag module'
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
      instance.access_flag :public, :static
      instance.name 'N'
      instance.descriptor 'D'
      instance.source_file 'F'
    end

    it do
      is_expected.to eq(
        [0x09, 0x01, 0x02, 0x01].pack('S>*') + instance.attributes.first.bytecode
      )
    end
  end

  describe '#decode' do
    let(:io) { StringIO.new([0x09, 0x01, 0x02, 0x00].pack('S>*')) }
    subject { instance.tap { |i| i.decode(io) } }

    it { expect(subject.readable_access_flag).to eq [:public, :static] }
    it { expect(subject.name).to be 1 }
    it { expect(subject.descriptor).to be 2 }

    it 'decodes attributes' do
      expect(JvmBytecode::Attributes::Attribute).to(
        receive(:decode_serial).with(cp, io).and_call_original
      )
      subject
    end
  end

  describe '#to_hash' do
    subject { instance.to_hash }
    before do
      instance.access_flag :public, :static
      instance.name 'N'
      instance.descriptor 'D'
      instance.source_file 'F'
    end

    it do
      is_expected.to eq({
        access_flag: [:public, :static],
        name_index: 1,
        descriptor_index: 2,
        attributes: [instance.attributes.first.to_hash]
      })
    end
  end
end
