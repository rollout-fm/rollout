# frozen_string_literal: true

require_relative '../helper'

class Filter1 < TextFilter; end

describe TextFilterEngineBase do

  let(:engine) do
    TextFilterEngineBase.new
  end

  describe '#filters' do

    it 'should return registered filters as a sorted array' do
      engine.register_filter(:c)
      engine.register_filter(:a)
      engine.register_filter(:b)

      engine.filters.must_equal([:a, :b, :c])
    end
  end

  describe '#register_filter' do

    it 'should add registered filters to filters array' do
      engine.register_filter(Filter1)
      engine.filters.must_equal([Filter1])
    end

    it 'should not register a filter twice' do
      engine.register_filter(Filter1)
      engine.register_filter(Filter1)
      engine.filters.must_equal([Filter1])
    end

  end

  describe '#unregister_filter' do

    it 'should remove unregistered filters from filters set' do
      engine.unregister_filter(Filter1)
      engine.filters.must_equal([])
    end

  end

  describe '#render' do
    it 'should instantiate all registered filters' do
      filter = Class.new(TextFilter)

      filter_instance = MiniTest::Mock.new
      filter_instance.expect(:render, 'foo', ['foo'])

      filter.stub(:new, filter_instance) do
        engine.register_filter(filter)
        engine.render('foo', { :foo => 'bar' })
      end
    end
  end
end


describe TextFilterEngineBase do

  describe '#register_filter' do

    it 'should add registered filters to filters array' do
      TextFilterEngine.register_filter(Filter1)
      TextFilterEngine.filters.must_equal([Filter1])
    end

  end

  describe '#unregister_filter' do
    it 'should remove unregistered filters from filters set' do
      TextFilterEngine.unregister_filter(Filter1)
      TextFilterEngine.filters.must_equal([])
    end
  end

end

