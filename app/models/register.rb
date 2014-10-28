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

  scope :group_by_month, -> {
    joins(:article).select(" month(date) as month,
                             sum(case when articles.type = '#{Article::TYPES::REVENUE}' then value else 0 end) as revenue,
                             sum(case when articles.type = '#{Article::TYPES::COST}' then value else 0 end) as cost,
                             sum(case when articles.type = '#{Article::TYPES::TRANSLATION}' then value else 0 end) as translation,

                             (sum(case when articles.type = '#{Article::TYPES::REVENUE}' then value else 0 end) - sum(case when articles.type = '#{Article::TYPES::COST}' then value else 0 end)) as profit
                           ").group("month(date)")
  }
end
