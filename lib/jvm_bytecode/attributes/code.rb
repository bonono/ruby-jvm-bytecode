module JvmBytecode
  module Attributes
    class Code < Attribute
      define location: [:method]

      Instructions::Instruction.all.each do |i|
        define_method(i.mnemonic) do |*args|
          @instructions.push(i.new(cp)).last.args = args
        end
      end

      def initialize(cp)
        super(cp)

        @max_stack = 0
        @max_locals = 0
        @instructions = []
      end

      def max_stack(n)
        @max_stack = n
      end

      def max_locals(n)
        @max_locals = n
      end

      def additional_bytecode
        code = @instructions.map(&:bytecode).join('')
        [@max_stack, @max_locals, code.length].pack('S>2I>') + code + [0, 0].pack('S>2')
      end

      def decode(io)
        io.read(4) # discard length

        @max_stack, @max_locals, len = io.read(8).unpack('S>2I>')
        
        @instructions.clear
        while len > 0
          opcode = io.read(1).unpack('C').first
          inst = Instructions::Instruction.fetch(opcode)
          @instructions << inst.new(cp).tap { |i| i.decode(io) }

          len -= inst.size
        end

        io.read(4) # discard exceptions and attributes
      end

      def to_hash
        super.merge({
          max_stack: @max_stack,
          max_local_variables: @max_locals,
          instructions: @instructions.map(&:to_hash)
        })
      end
    end
  end
end
