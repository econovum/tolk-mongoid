module Tolk
  class Phrase
    include Mongoid::Document
    include Mongoid::Timestamps

    attr_accessible :key

    field :key, type: String

    validates_uniqueness_of :key

    cattr_accessor :per_page
    self.per_page = 30

    has_many :translations, :class_name => 'Tolk::Translation', :dependent => :destroy do
      def primary
        to_a.detect {|t| t.locale_id == Tolk::Locale.primary_locale.id}
      end

      def for(locale)
        to_a.detect {|t| t.locale_id == locale.id}
      end
    end

    attr_accessor :translation

    scope :containing_text, lambda { |query| self.any_of(text: Regexp.new(".*#{query}.*")) }
    scope :containing_key, lambda { |query| self.any_of(key: Regexp.new(".*#{query}.*")) }
  end
end
