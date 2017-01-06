describe JvmBytecode::Attributes::Attribute do
  let(:cp) { JvmBytecode::ConstantPool.new }
  let(:instance) { described_class.new(cp) }

  describe '.fetch' do
    subject { described_class.fetch(name) }

    context 'when received valid attribute name' do
      let(:name) { 'SourceFile' }
      it { is_expected.to be JvmBytecode::Attributes::SourceFile }
    end

    context 'when received invalid attribute name' do
      let(:name) { '>_<' }
      it { expect { subject }.to raise_error(JvmBytecode::Errors::AttributeError) }
    end
  end

  describe '.all' do
    subject { described_class.all }
    it do
      is_expected.to eq [
        JvmBytecode::Attributes::Code,
        JvmBytecode::Attributes::SourceFile
      ]
    end
  end

  describe '.decode_serial' do
    let(:sf_attr) do
      JvmBytecode::Attributes::SourceFile.new(cp).tap do |a|
        a.filename('FILENAME')
      end
    end
    let(:io) { StringIO.new([0x01].pack('S>') + sf_attr.bytecode) }

    subject { described_class.decode_serial(cp, io) }

    it { is_expected.to be_a Array }
    it { expect(subject.length).to be 1 }
    it { expect(subject.first).to be_a sf_attr.class }
    it { expect(subject.first.filename).to eq sf_attr.filename }
  end

  describe '#additional_bytecode' do
    subject { instance.send(:additional_bytecode) }
    it { is_expected.to eq '' }
  end

  describe '#bytecode' do
    let(:stub_bytecode) { [0x12, 0x34].pack('I>*') }
    subject { instance.bytecode }

    before do
      allow(cp).to receive(:utf8).and_return(1)
      allow(instance).to(
        receive(:additional_bytecode).and_return(stub_bytecode)
      )
    end

    it { is_expected.to eq [0x01, stub_bytecode.length].pack('S>I>') + stub_bytecode }
  end
end
