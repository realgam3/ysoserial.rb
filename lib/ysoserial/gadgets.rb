require 'pathname'

module YSoSerial
  module Gadgets
    def self.load
      pattern = File.join(Pathname(__FILE__).dirname, "gadgets", "*.rb")
      Dir.glob(pattern).each do |path|
        Kernel.load(path)
      end
    end

    def self.table
      gadgets = {}
      self.load
      YSoSerial::Gadgets.constants.select do |const_symbol|
        const = YSoSerial::Gadgets.const_get(const_symbol) rescue nil
        if not const.nil? and const.is_a? Class
          class_name = const.name.split("::")[-1].to_sym
          gadgets[class_name] = const
        end
      end
      gadgets
    end
  end
end

