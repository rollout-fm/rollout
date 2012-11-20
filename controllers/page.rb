# encoding: utf-8

class Podding < Sinatra::Base

  get "/pages/:name" do |name|
    @model = PageModel.new(name: name, path: settings.pages)
    slim @model.template
  end

end