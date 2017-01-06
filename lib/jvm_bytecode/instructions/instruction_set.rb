module JvmBytecode
  module Instructions
    4.times do |n|
      # iload_(0|1|2|3)
      Class.new(Instruction) do
        format opcode: 0x1A + n, mnemonic: "iload_#{n}"
      end

      # aload_(0|1|2|3)
      Class.new(Instruction) do
        format opcode: 0x2A + n, mnemonic: "aload_#{n}"
      end
    end

    class IAdd < Instruction
      format opcode: 0x60
    end 

    class IReturn < Instruction
      format opcode: 0xAC
    end

    class Return < Instruction
      format opcode: 0xB1, mnemonic: '_return'

      def to_hash
        super.merge({ mnemonic: 'return' })
      end
    end

    class InvokeSpecial < Instruction
      format opcode: 0xB7, size: 3

      def bytecode
        super + [args.first].pack('S>')
      end

      def decode(io)
        super(io)
        self.args = io.read(2).unpack('S>')
      end

      def to_hash
        super.merge({ ref: args.first })
      end
    end
  end
end
