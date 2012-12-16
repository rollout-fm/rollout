# encoding: utf-8

require_relative 'helper'

class CustomModel
  def name
    "fufufu"
  end
end

class URLHelperTest < MiniTest::Unit::TestCase
  # Include tested module
  include URLs

  def test_episode_urls
    episode = Episode.first(title: "Trolololo")
    assert_equal "/episodes/#{episode.name}", url_for(episode)
  end

  def test_show_urls
    show =  Show.first(name: "show1")
    assert_equal "/shows/#{show.name}", url_for(show)
  end

  def test_page_urls
    page =  Page.first(name: "page1")
    assert_equal "/pages/#{ page.name }", url_for(page)
  end

  def test_custom_model_urls
    model = CustomModel.new
    assert_equal "/custommodels/#{ model.name }", url_for(model)
  end

end