module JvmBytecode
  # Module for a class that requires handling "access_flags" field
  module AccessFlag
    # @return [Hash]
    def all_access_flags
      self.class::ACCESS_FLAGS
    end

    # Setter and getter for access flag
    #
    # @param flags [Array<Symbol>]
    # @return [Integer]
    def access_flag(*flags)
      @acc_flag = flags.map(&all_access_flags.method(:[])).reduce(0, &:|) if flags.any?
      @acc_flag || 0
    end

    # Set access flag directly
    #
    # @param acc_flag [Integer]
    def set_access_flag(acc_flag)
      @acc_flag = acc_flag
    end

    # @return [Array<Symbol>]
    def readable_access_flag
      all_access_flags.select { |_, v| (@acc_flag & v) > 0 }.keys
    end
  end
end
