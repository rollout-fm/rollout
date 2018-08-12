# frozen_string_literal: true

require_relative '../helper'

describe Episode do
  it 'can set the teaser' do
    content = "!!!\nThis is the teaser\n!!!\nThis is the content"

    document = mock_with_attributes(content: content, data: { 'name' => 'epi' })
    episode = Episode.new(document)
    episode.content.must_equal('This is the content')
    episode.teaser.must_equal('This is the teaser')
  end

  it 'has an empty teaser when not available' do
    document = mock_with_attributes(content: '', data: { 'foo' => 'bar' })
    episode = Episode.new(document)
    episode.content.must_equal('')
    episode.teaser.must_equal('')
  end

  describe '#date' do
    it 'can parse the set date' do
      document = mock_with_attributes(content: '', data: { 'date' => '24.12.2012' })
      episode = Episode.new(document)
      episode.date.must_be_instance_of Date
      episode.date.must_equal Date.new(2012, 12, 24)
    end
  end

  describe '#status' do
  end

  describe '#hosts' do
    it 'returns an empty array when no hosts are available' do
      document = mock_with_attributes(content: '', data: { })
      hosts = Episode.new(document).hosts
      hosts.must_be_kind_of(Enumerable)
      hosts.must_be_empty
    end

    it 'can reference a single host with attribute host' do
      document = mock_with_attributes(content: '', data: { 'host' => 'asdf' })
      host = Host.new(mock_with_attributes(content: '', data: { 'name' => 'asdf' }))

      first_mock = MiniTest::Mock.new
      first_mock.expect(:call, host, [{ name: 'asdf' }])

      Host.stub(:first, first_mock) do
        hosts = Episode.new(document).hosts
        hosts.must_be_kind_of(Enumerable)
        hosts.size.must_equal(1)
        hosts.first.must_equal(host)
      end
    end

    it 'can reference a single host with attribute hosts' do
      document = mock_with_attributes(content: '', data: { 'hosts' => 'hjkl' })
      host = Host.new(mock_with_attributes(content: '', data: { 'name' => 'hjkl' }))

      first_mock = MiniTest::Mock.new
      first_mock.expect(:call, host, [{ name: 'hjkl' }])

      Host.stub(:first, first_mock) do
        hosts = Episode.new(document).hosts
        hosts.must_be_kind_of(Enumerable)
        hosts.size.must_equal(1)
        hosts.must_equal([host])
      end
    end

    it 'can reference a single host with array attribute hosts' do
      document = mock_with_attributes(content: '', data: { 'hosts' => ['huh'] })
      host = Host.new(mock_with_attributes(content: '', data: { 'name' => 'huh' }))

      first_mock = MiniTest::Mock.new
      first_mock.expect(:call, host, [{ name: 'huh' }])

      Host.stub(:first, first_mock) do
        hosts = Episode.new(document).hosts
        hosts.must_be_kind_of(Enumerable)
        hosts.size.must_equal 1
        hosts.must_equal([host])
      end
    end

    it 'can reference multiple hosts with array attribute hosts' do
      document = mock_with_attributes(content: '', data: { 'hosts' => [ 'huh', 'asdf'] })
      host1 = Host.new(mock_with_attributes(content: '', data: { 'name' => 'huh' }))
      host2 = Host.new(mock_with_attributes(content: '', data: { 'name' => 'asdf' }))

      first_mock = MiniTest::Mock.new
      first_mock.expect(:call, host1, [{ name: 'huh' }])
      first_mock.expect(:call, host2, [{ name: 'asdf' }])

      Host.stub(:first, first_mock) do
        hosts = Episode.new(document).hosts
        hosts.must_be_kind_of(Enumerable)
        hosts.size.must_equal(2)
        hosts.must_include(host1)
        hosts.must_include(host2)
      end
    end

    it 'only references valid hosts' do
      document = mock_with_attributes(
        content: '', data: { 'hosts' => ['huh', 'asdf', 'does_not_exist'] }
      )
      host1 = Host.new(mock_with_attributes(content: '', data: { 'name' => 'huh' }))
      host2 = Host.new(mock_with_attributes(content: '', data: { 'name' => 'asdf' }))


      first_mock = MiniTest::Mock.new
      first_mock.expect(:call, host1, [{ name: 'huh' }])
      first_mock.expect(:call, host2, [{ name: 'asdf' }])
      first_mock.expect(:call, nil, [{ name: 'does_not_exist' }])

      Host.stub(:first, first_mock) do
        hosts = Episode.new(document).hosts
        hosts.must_be_kind_of(Enumerable)
        hosts.size.must_equal(2)
        hosts.must_include(host1)
        hosts.must_include(host2)
      end
    end
  end
end

