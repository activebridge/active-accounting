class Register < ActiveRecord::Base
  belongs_to :counterparty
  belongs_to :article

  validates :date, :article, :value, presence: true

  scope :revenues, -> {
    joins(:article).where(articles: {type: Article::TYPES::REVENUE})
  }

  scope :costs, -> {
    joins(:article).where(articles: {type: Article::TYPES::COST})
  }

  scope :translations, -> {
    joins(:article).where(articles: {type: Article::TYPES::TRANSLATION})
  }

  scope :group_by_article, -> {
    select("article_id, sum(value) as sum").group("article_id").order("")
  }

  scope :by_month, -> (date) {
    where("extract(month from date) = ? AND extract(year from date) = ?", date.month, date.year)
  }

  delegate :article_name, :type, to: :article
end
