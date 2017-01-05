module JvmBytecode
  module Instructions
    class Instruction
      using Extensions

      class << self
        attr_reader :opcode, :size, :mnemonic

        def format(opcode:, size: 1, mnemonic: nil)
          @@instructions ||= {}
          @@instructions[opcode] = self

          @opcode = opcode
          @size = size
          @mnemonic = mnemonic || shortname.downcase
        end 

        def all
          @@instructions.values
        end

        def fetch(opcode)
          @@instructions[opcode] || raise(Errors::OpcodeError, "#{sprintf('0x%02X', opcode)} is not implemented")
        end
      end

      attr_reader :cp
      attr_accessor :args

      def initialize(cp)
        @cp = cp
        @args = nil
      end

      def bytecode
        [self.class.opcode].pack('C') + additional_bytecode
      end

      def additional_bytecode
        ''
      end

      def decode(io)

      end

      def to_hash
        {
          mnemonic: self.class.mnemonic,
          opcode: self.class.opcode
        }
      end
    end
  end
end
