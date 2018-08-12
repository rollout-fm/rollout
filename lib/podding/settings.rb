# frozen_string_literal: true

require 'settingslogic'

class Settings < Settingslogic
  source "#{File.dirname(__FILE__)}/../../config.yml"
  load!
end
