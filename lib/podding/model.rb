# encoding: utf-8

require 'scrivener'

class Model
  include Scrivener::Validations

  class << self

    attr_accessor :base_path

    def first(options = {})
      find(options).first
    end

    def find(options = {})
      all.select do |model|
        options.all? do |param, value|
          model.meta_data[param.to_s] == value
        end
      end
    end

    def find_match(options = {})
      all.select do |model|
        options.all? do |param, value|
          data = model.meta_data[param.to_s]
          if data
            result = case data
                     when Enumerable then data.select { |el| el.match(value) }
                     when String then data.match(value)
                     end

            result && result.size > 0
          end
        end
      end
    end

    def all
      all_files = scan_files

      all_files.map do |path|
        self.new(path: path)
      end.sort_by &default_sort_by
    end

    def path
      name = to_reference + "s"
      "#{ Model.base_path }/#{ name }"
    end

    def scan_files
      files = "#{ path }/**/*.{markdown,md}"
      Dir[files]
    end

    def default_sort_by
      :name
    end

    # Manage relations between models

    def attribute(name)
      define_method(name) do
        @meta_data[name.to_s]
      end
    end

    def belongs_to(name, model)
      define_method name do
        name = name.to_s
        model = Utils.class_lookup(self.class, model)
        model.first(:name => self.meta_data[name])
      end
    end

    def has_many(name, model, reference = to_reference)
      define_method name do
        model = Utils.class_lookup(self.class, model)
        if reference.to_s.end_with?("s")
          model.find_match(:"#{ reference }" => self.name)
        else
          model.find(:"#{ reference }" => self.name)
        end
      end
    end

    protected

    def to_reference
      self.name.downcase
    end

  end

  attr_reader :path, :content, :meta_data

  attribute :name

  def initialize(options = {})
    @path = options[:path]
    split_content = split_content_and_meta(@path)
    @content = split_content[:content]
    @meta_data = split_content[:meta_data]
  end

  def validate
    assert_present :name
  end

  def split_content_and_meta(path)
    data = ""
    content = File.read(path)

    begin
      if match = content.match(/^(---\s*\n(.*?)\n?)^(---\s*$\n?)(.*)/m)
        data = YAML.load(match[2])
        content = match[4]
      else
        data = { }
      end
    rescue => e
      raise "YAML Exception reading #{path}: #{e.message}"
    end

    { content: content, meta_data: data }
  end

  def template
    if @meta_data["template"]
      @meta_data["template"].to_sym
    else
      default_template
    end
  end

  def default_template
    self.class.name.downcase.to_sym
  end

  # Dynamic meta data lookup
  def method_missing(meth, *args, &block)
    key = meth.to_s

    return super if @meta_data.nil?

    if @meta_data.has_key?(key)
      @meta_data[key]
    else
      nil
    end
  end

  def respond_to?(meth)
    if @meta_data && @meta_data.has_key?(meth)
      true
    else
      super
    end
  end

end
