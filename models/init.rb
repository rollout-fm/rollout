# frozen_string_literal: true

Dir[File.dirname(__FILE__) + "/*.rb"].each do |model|
  if model != __FILE__
    require_relative model
  end
end

