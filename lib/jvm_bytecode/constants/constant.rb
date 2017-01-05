module JvmBytecode
  module Constants
    class Constant
      class << self
        attr_reader :tag

        def define(t)
          @@constants ||= {}
          @@constants[t] = self

          @tag = t
        end

        def fetch(t)
          @@constants[t] || raise(Errors::ConstantError, "Constant:#{t} is not implemented")
        end
      end

      def bytecode
        [self.class.tag].pack('C') + additional_bytecode
      end

      def additional_bytecode
        ''
      end
    end
  end 
end
