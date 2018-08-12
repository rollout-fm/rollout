#!/usr/bin/env ruby

# frozen_string_literal: true

require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/config_file'
require 'slim'
require 'less'
require 'redcarpet'
require 'net/http'
require 'net/https'
require 'json'
require 'i18n'

require 'mlk'
require 'mlk/storage_engines/file_storage'

require_relative 'lib/podding'

class Podding < Sinatra::Base
  register Sinatra::ConfigFile

  enable :sessions, :static, :logging

  root_dir = File.dirname(__FILE__)
  source_dir = "#{root_dir}/source"
  config_file "#{root_dir}/config.yml"

  set :root, root_dir
  set :public_folder, root_dir + '/static'
  set :views, root_dir + '/views'

  Mlk::FileStorage.base_path = source_dir
  Mlk::Model.storage_engine = Mlk::FileStorage

  configure :production do
    # ...
  end

  configure :development do
    require 'pry'
    require 'pry-byebug'
  end

  helpers do
    include Rack::Utils
    alias_method :h, :escape_html
  end

  require_relative 'controllers/init'
  require_relative 'models/init'
  require_relative 'helpers/init'
  require_relative 'filters/init'

  get '/css/:style.css' do
    pp params
    less params[:style].to_sym, :paths => [settings.views + "/css"]
  end

  # Configure localization

  I18n.load_path += Dir[File.join(source_dir, 'locales', '*.yml').to_s]

  if Settings["language"]
    I18n.locale = Settings.language
  else
    I18n.locale = "en"
  end

  # Load all helpers

  Helper.defined_helpers.each do |helper|
    helpers helper
  end

  run! if app_file == $0
end

