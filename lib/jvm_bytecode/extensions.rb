module JvmBytecode
  module Extensions
    refine Array do
      def join_bytecodes(template = 'S>')
        [block_given? ? yield : length].pack('S>') + map(&:bytecode).join('')
      end
    end

    refine Class do
      def shortname
        name.split('::').last
      end
    end
  end
end
