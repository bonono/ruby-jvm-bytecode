module JvmBytecode
  module Instructions
    # Base class for implementation of instruction set
    # @see https://docs.oracle.com/javase/specs/jvms/se8/html/jvms-6.html
    class Instruction
      using Extensions

      class << self
        attr_reader :opcode, :size, :mnemonic

        # @param opcode [Integer]
        # @param size [Integer]
        # @param mnemonic [String]
        def format(opcode:, size: 1, mnemonic: nil)
          @@instructions ||= {}
          @@instructions[opcode] = self

          @opcode = opcode
          @size = size
          @mnemonic = mnemonic || shortname.downcase
        end 

        # @return [Array<JvmBytecode::Instructions::Instruction>]
        def all
          @@instructions.values
        end

        # Get instruction class specified by opcode
        #
        # @param opcode [Integer]
        # @raise [JvmBytecode::Errors::OpcodeError]
        # @return [JvmBytecode::Instructions::Instruction]
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

      # Return bytecode
      #
      # @return [String] ASCII-8BIT string
      def bytecode
        [self.class.opcode].pack('C')
      end

      # @param io [IO]
      def decode(io)
        # do nothing
      end

      # @return [Hash]
      def to_hash
        {
          mnemonic: self.class.mnemonic,
          opcode: sprintf('0x%02X', self.class.opcode)
        }
      end
    end
  end
end
