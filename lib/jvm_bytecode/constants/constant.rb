module JvmBytecode
  module Constants
    # Base class for implemention of constant in constant pool
    # @see https://docs.oracle.com/javase/specs/jvms/se8/html/jvms-4.html#jvms-4.4
    class Constant
      using Extensions

      class << self
        attr_reader :tag

        # @param t [Integer] tag value
        def define(t)
          @@constants ||= {}
          @@constants[t] = self

          @tag = t
        end

        # Get constant class speficified by argument
        # @param t [Integer]
        # @raise [JvmBytecode::Errors::ConstantError]
        # @return [JvmBytecode::Constant]
        def fetch(t)
          @@constants[t] || raise(Errors::ConstantError, "Constant:#{t} is not implemented")
        end
      end

      # Return bytecode
      #
      # @return [String] ASCII-8BIT string
      def bytecode
        self.class.tag.chr
      end

      #@return [Hash]
      def to_hash
        { type: self.class.shortname }
      end
    end
  end 
end
