require 'hello_sign/file/mime_types'
require 'faraday/upload_io'

module HelloSign
  class File
    DEFAULT_MIME_TYPE = MIME_TYPES.fetch('txt')

    attr_reader :filename, :io_object
    private :filename, :io_object

    def initialize(file_data)
      @filename  = file_data[:filename]
      @io_object = file_data[:io]
      @mime_type = file_data[:mime]
    end

    def attachment
      Faraday::UploadIO.new(*parameters)
    end

    private

    def parameters
      begin
        io_object ? [io_object, mime_type, filename] : [filename, mime_type]
      end.compact
    end

    def mime_type
      @mime_type or begin
        extension = (filename || '').split('.').last
        MIME_TYPES.fetch(extension) { DEFAULT_MIME_TYPE }
      end
    end

  end
end
