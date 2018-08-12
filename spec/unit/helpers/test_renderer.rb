# frozen_string_literal: true

require_relative '../helper'

describe Renderer do
  include Renderer

  MyTestClass = Struct.new(:content) do
    def to_str
      self.content
    end
  end

  it 'should render a given string by pushing it through the TextFilter pipeline' do
    TextFilterEngine.stub(:render, lambda do |content, options|
      content.must_equal('Given string!')
      options.must_equal({})
    end) do
      render_content('Given string!')
    end
  end

  it 'should render a given object which has an implicit string conversion ' do
    TextFilterEngine.stub(:render, lambda do |content, options|
      content.must_equal(content)
      options.must_equal({})
    end) do
      render_content(MyTestClass.new('Given content'))
    end
  end

  it 'should pass an options hash to the render pipeline' do
    TextFilterEngine.stub(:render, lambda do |content, options|
      content.must_equal('foo')
      options.must_equal(options)
    end) do
      render_content('foo', { foo: 'bar', baz: 'derp' })
    end
  end

end

