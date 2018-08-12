# frozen_string_literal: true

require 'minitest/autorun'

require 'pry'
require 'pry-byebug'

require 'mlk'
require 'mlk/storage_engines/memory_storage'

require_relative '../../lib/podding'
require_relative '../../models/init'
require_relative '../../helpers/init'

begin
  require 'minitest/pride'
rescue LoadError
  # Continue, but without colors
end

Mlk::Model.storage_engine = Mlk::MemoryStorage

def generate_document(header, content = '')
<<-EOF
---
#{ header.inject('') { |acc, val| acc +=  "#{ val[0] }: #{ val[1] }\n" } }
---
#{ content }
EOF
end

Document = Struct.new(:content, :data) do

end

def mock_with_attributes(attributes)
  Document.new(attributes[:content], attributes[:data])
end
