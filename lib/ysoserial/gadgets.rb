require 'pathname'
require 'psych/class_loader'

CLASS_LOADER = Psych::ClassLoader.new

module YSoSerial
  module Gadgets
    def self.load
      pattern = File.join(Pathname(__FILE__).dirname, "gadgets", "*.rb")
      Dir.glob(pattern).each do |path|
        Kernel.require(path)
      end
    end

    def self.table
      gadgets = {}
      self.load
      YSoSerial::Gadgets.constants.select do |class_name|
        class_full_name = "YSoSerial::Gadgets::#{class_name}"
        gadgets[class_name] = CLASS_LOADER.load(class_full_name)
      end
      gadgets
    end
  end
end

