require_relative 'helper'

class ShowModelTest < MiniTest::Unit::TestCase
  def setup
    @shows = Show.all
  end

  def test_show_amount
    assert_equal 2, @shows.count
  end

  def test_show_type
    assert @shows.all? { |s| s.instance_of?(Show) }
  end

  def test_show_content
    assert @shows.all? { |s| !s.content.empty? }
  end

  def test_show_path
    assert @shows.all? { |s| File.exist? s.path }
  end

  def test_find_show_by_name
    assert 1, Show.find(name: "show1").count
    assert 1, Show.find(name: "show2").count
  end

  def test_find_show_by_title
    assert 1, Show.find(title: "My super show 1").count
    assert 1, Show.find(title: "My super show 2").count
  end

  def test_find_show_by_template
    assert 1, Show.find(template: "custom_shows_template").count
  end
end