# encoding: utf-8

class Podding < Sinatra::Base

  get "/hosts" do
    @page = Page.first(name: "hosts")
    @hosts = Host.all
    slim :hosts
  end

  get "/hosts/:name" do |name|
    @page = Page.first(name: "hosts")
    @host = Host.first(name: name)
    slim @host.template
  end

end
