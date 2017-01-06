module JvmBytecode
  module Instructions
    4.times do |n|
      Class.new(Instruction) { format opcode: 0x1A + n, mnemonic: "iload_#{n}" }
      Class.new(Instruction) { format opcode: 0x1E + n, mnemonic: "lload_#{n}" }
      Class.new(Instruction) { format opcode: 0x22 + n, mnemonic: "fload_#{n}" }
      Class.new(Instruction) { format opcode: 0x26 + n, mnemonic: "dload_#{n}" }
      Class.new(Instruction) { format opcode: 0x2A + n, mnemonic: "aload_#{n}" }

      Class.new(Instruction) { format opcode: 0x3B + n, mnemonic: "istore_#{n}" }
      Class.new(Instruction) { format opcode: 0x3F + n, mnemonic: "lstore_#{n}" }
      Class.new(Instruction) { format opcode: 0x43 + n, mnemonic: "fstore_#{n}" }
      Class.new(Instruction) { format opcode: 0x47 + n, mnemonic: "dstore_#{n}" }
      Class.new(Instruction) { format opcode: 0x4B + n, mnemonic: "astore_#{n}" }
    end

    class IALoad < Instruction; format opcode: 0x2E; end
    class LALoad < Instruction; format opcode: 0x2F; end
    class FALoad < Instruction; format opcode: 0x30; end
    class DALoad < Instruction; format opcode: 0x31; end
    class AALoad < Instruction; format opcode: 0x32; end
    class BALoad < Instruction; format opcode: 0x33; end
    class CALoad < Instruction; format opcode: 0x34; end
    class SALoad < Instruction; format opcode: 0x35; end

    class IAStore < Instruction; format opcode: 0x4F; end
    class LAStore < Instruction; format opcode: 0x50; end
    class FAStore < Instruction; format opcode: 0x51; end
    class DAStore < Instruction; format opcode: 0x52; end
    class AAStore < Instruction; format opcode: 0x53; end
    class BAStore < Instruction; format opcode: 0x54; end
    class CAStore < Instruction; format opcode: 0x55; end
    class SAStore < Instruction; format opcode: 0x56; end

    class IAdd < Instruction
      format opcode: 0x60
    end 

    class IReturn < Instruction; format opcode: 0xAC; end
    class LReturn < Instruction; format opcode: 0xAD; end
    class FReturn < Instruction; format opcode: 0xAE; end
    class DReturn < Instruction; format opcode: 0xAF; end
    class AReturn < Instruction; format opcode: 0xB0; end

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
