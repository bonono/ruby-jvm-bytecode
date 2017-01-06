module JvmBytecode
  module Instructions
    class Nop < Instruction; format opcode: 0x00; end

    class AConstNull < Instruction; format opcode: 0x01, mnemonic: 'aconst_null'; end

    class IConstM1 < Instruction; format opcode: 0x02, mnemonic: 'iconst_m1'; end
    6.times do |n|
      Class.new(Instruction) { format opcode: 0x03 + n, mnemonic: "iconst_#{n}" }
    end

    class LConst0 < Instruction; format opcode: 0x09, mnemonic: 'lconst_0'; end
    class LConst1 < Instruction; format opcode: 0x0A, mnemonic: 'lconst_1'; end

    class FConst0 < Instruction; format opcode: 0x0B, mnemonic: 'fconst_0'; end
    class FConst1 < Instruction; format opcode: 0x0C, mnemonic: 'fconst_1'; end
    class FConst2 < Instruction; format opcode: 0x0D, mnemonic: 'fconst_2'; end

    class DConst0 < Instruction; format opcode: 0x0E, mnemonic: 'dconst_0'; end
    class DConst1 < Instruction; format opcode: 0x0F, mnemonic: 'dconst_1'; end

    # 0x10 bipush
    # 0x11 sipush
    # 0x12 ldc
    # 0x13 ldc_w
    # 0x14 ldc2_w
    # 0x15 ~ 0x19 (i|l|f|d|a)load

    4.times do |n|
      Class.new(Instruction) { format opcode: 0x1A + n, mnemonic: "iload_#{n}" }
      Class.new(Instruction) { format opcode: 0x1E + n, mnemonic: "lload_#{n}" }
      Class.new(Instruction) { format opcode: 0x22 + n, mnemonic: "fload_#{n}" }
      Class.new(Instruction) { format opcode: 0x26 + n, mnemonic: "dload_#{n}" }
      Class.new(Instruction) { format opcode: 0x2A + n, mnemonic: "aload_#{n}" }
    end

    class IALoad < Instruction; format opcode: 0x2E; end
    class LALoad < Instruction; format opcode: 0x2F; end
    class FALoad < Instruction; format opcode: 0x30; end
    class DALoad < Instruction; format opcode: 0x31; end
    class AALoad < Instruction; format opcode: 0x32; end
    class BALoad < Instruction; format opcode: 0x33; end
    class CALoad < Instruction; format opcode: 0x34; end
    class SALoad < Instruction; format opcode: 0x35; end

    # 0x36 ~ 0x3A (i|l|f|d|a)store

    4.times do |n|
      Class.new(Instruction) { format opcode: 0x3B + n, mnemonic: "istore_#{n}" }
      Class.new(Instruction) { format opcode: 0x3F + n, mnemonic: "lstore_#{n}" }
      Class.new(Instruction) { format opcode: 0x43 + n, mnemonic: "fstore_#{n}" }
      Class.new(Instruction) { format opcode: 0x47 + n, mnemonic: "dstore_#{n}" }
      Class.new(Instruction) { format opcode: 0x4B + n, mnemonic: "astore_#{n}" }
    end

    class IAStore < Instruction; format opcode: 0x4F; end
    class LAStore < Instruction; format opcode: 0x50; end
    class FAStore < Instruction; format opcode: 0x51; end
    class DAStore < Instruction; format opcode: 0x52; end
    class AAStore < Instruction; format opcode: 0x53; end
    class BAStore < Instruction; format opcode: 0x54; end
    class CAStore < Instruction; format opcode: 0x55; end
    class SAStore < Instruction; format opcode: 0x56; end

    class Pop < Instruction;    format opcode: 0x57; end
    class Pop2 < Instruction;   format opcode: 0x58; end
    class Dup < Instruction;    format opcode: 0x59; end
    class DupX1 < Instruction;  format opcode: 0x5A, mnemonic: 'dup_x1'; end
    class DupX2 < Instruction;  format opcode: 0x5B, mnemonic: 'dup_x2'; end
    class Dup2 < Instruction;   format opcode: 0x5C; end
    class Dup2X1 < Instruction; format opcode: 0x5D, mnemonic: 'dup2_x1'; end
    class Dup2X2 < Instruction; format opcode: 0x5E, mnemonic: 'dup2_x1'; end
    class Swap < Instruction;   format opcode: 0x5F; end

    %w(i l f d).each.with_index do |t, i|
      Class.new(Instruction) { format opcode: 0x60 + i, mnemonic: "#{t}add" }
      Class.new(Instruction) { format opcode: 0x64 + i, mnemonic: "#{t}sub" }
      Class.new(Instruction) { format opcode: 0x68 + i, mnemonic: "#{t}mul" }
      Class.new(Instruction) { format opcode: 0x6C + i, mnemonic: "#{t}div" }
      Class.new(Instruction) { format opcode: 0x70 + i, mnemonic: "#{t}rem" }
      Class.new(Instruction) { format opcode: 0x74 + i, mnemonic: "#{t}neg" }
    end

    class IShL < Instruction;  format opcode: 0x78; end
    class LShL < Instruction;  format opcode: 0x79; end
    class IShR < Instruction;  format opcode: 0x7A; end
    class LShR < Instruction;  format opcode: 0x7B; end
    class IUShR < Instruction; format opcode: 0x7C; end
    class LUShR < Instruction; format opcode: 0x7D; end
    class IAnd < Instruction;  format opcode: 0x7E; end
    class LAnd < Instruction;  format opcode: 0x7F; end
    class IOr < Instruction;   format opcode: 0x80; end
    class LOr < Instruction;   format opcode: 0x81; end
    class IXor < Instruction;  format opcode: 0x82; end
    class LXor < Instruction;  format opcode: 0x83; end

    # 0x84 iinc

    class I2L < Instruction; format opcode: 0x85; end
    class I2F < Instruction; format opcode: 0x86; end
    class I2D < Instruction; format opcode: 0x87; end

    class L2I < Instruction; format opcode: 0x88; end
    class L2F < Instruction; format opcode: 0x89; end
    class L2D < Instruction; format opcode: 0x8A; end

    class F2I < Instruction; format opcode: 0x8B; end
    class F2L < Instruction; format opcode: 0x8C; end
    class F2D < Instruction; format opcode: 0x8D; end

    class D2I < Instruction; format opcode: 0x8E; end
    class D2L < Instruction; format opcode: 0x8F; end
    class D2F < Instruction; format opcode: 0x90; end

    class I2B < Instruction; format opcode: 0x91; end
    class I2C < Instruction; format opcode: 0x92; end
    class I2S < Instruction; format opcode: 0x93; end

    class LCmp < Instruction;  format opcode: 0x94; end
    class FCmpL < Instruction; format opcode: 0x95; end
    class FCmpG < Instruction; format opcode: 0x96; end
    class DCmpL < Instruction; format opcode: 0x97; end
    class DCmpG < Instruction; format opcode: 0x98; end

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
