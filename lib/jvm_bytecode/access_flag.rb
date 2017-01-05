module JvmBytecode
  module AccessFlag
    def all_access_flag
      self.class::ACCESS_FLAGS
    end

    def access_flag(*flags)
      @acc_flag = flags.map(&all_access_flag.method(:[])).reduce(0, &:|) if flags.any?
      @acc_flag || 0
    end

    def set_access_flag(acc_flag)
      @acc_flag = acc_flag
    end

    def readable_access_flag
      all_access_flag.select { |k, v| (@acc_flag & v) > 0 }.keys
    end
  end
end
