# frozen_string_literal: true

require_relative '../helper'

describe URLs do
  include URLs

  Content = Struct.new(:name) do
    def self.name
      'Content'
    end
  end

  FakeEpisode = Struct.new(:class, :name, :show)
  FakeShow =  Struct.new(:class, :name)
  FakeHost = Struct.new(:twitter_name, :flattr_name)

  it 'should generate content URLs' do
    content = Content.new('my_content')
    url_for(content).must_equal('/contents/my_content')
  end

  it 'should generate correct episode URLs' do
    show = FakeShow.new(Show, 'my_show')
    episode = FakeEpisode.new(Episode, 'my_episode', show)

    url_for(episode).must_equal('/shows/my_show/my_episode')
  end

  it 'should generate correct twitter URLs' do
    host = FakeHost.new('my_twitter', 'my_flattr')
    twitter_url(host).must_equal('https://twitter.com/my_twitter')
  end

  it 'should generate correct flattr URLSs' do
    host = FakeHost.new('my_twitter', 'my_flattr')
    flattr_url(host).must_equal('https://flattr.com/profile/my_flattr')
  end

end

