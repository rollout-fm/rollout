# frozen_string_literal: true

class Page < Mlk::Model
  attribute :title
  attribute :icon
  attribute :label
  attribute :quip
  attribute :is_secondary
  attribute :is_unimportant
  attribute :is_hidden
  attribute :is_special
  attribute :short_title
end

