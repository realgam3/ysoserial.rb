require 'yaml'
require 'base64'

FORMAT_MAP = {
  "marshal": Marshal,
  "yaml": YAML,
}

OUTPUT_MAP = {
  "raw": {
    "encoder": -> (value) { value },
    "decoder": -> (value) { value },
  },
  "escaped": {
    "encoder": -> (value) { value.dump[1..-2] },
    "decoder": -> (value) { value.undump },
  },
  "base64": {
    "encoder": -> (value) { Base64.urlsafe_encode64(value, padding: 0) },
    "decoder": -> (value) { Base64.urlsafe_decode64(value, padding: 0) },
  },
}

module YSoSerial
  class BaseGadget
    def initialize(cmd)
      @cmd = cmd
    end

    def description
      "no description"
    end

    def author
      "unknown"
    end

    def supported_formats
      raise "Supported Formats not configured"
    end

    def payload(format = :marshal)
      raise "Payload not configured"
    end

    def generate(format = :marshal, output = :raw)
      unless FORMAT_MAP.key? format
        raise "Formatter not found"
      end

      unless supported_formats.include? format
        raise "Formatter not supported"
      end

      unless OUTPUT_MAP.key? output
        raise "Output format not found"
      end

      formatter_class = FORMAT_MAP[format]
      output_function = OUTPUT_MAP[output][:encoder]
      output_function.call(formatter_class.dump(payload))
    end

    def test(format = :marshal, output = :raw)
      payload = generate(format, output)

      formatter_class = FORMAT_MAP[format]
      output_function = OUTPUT_MAP[output][:decoder]
      formatter_class.load(output_function.call(payload)) rescue nil
    end
  end
end
