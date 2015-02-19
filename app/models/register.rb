class Register < ActiveRecord::Base
  belongs_to :counterparty
  belongs_to :article

  module TYPES
    FACT = 'Fact'
    PLAN = 'Plan'
  end

  def fact?
    type == TYPES::FACT
  end

  def plan?
    type == TYPES::PLAN
  end

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

  scope :loans, -> {
    joins(:article).where(articles: {type: Article::TYPES::LOAN})
  }

  scope :by_month, -> (date) {
    unless date.blank?
      date = Date.parse(date)
      where("extract(month from date) = ? AND extract(year from date) = ?", date.month, date.year)
    end
  }

  scope :by_months, -> (dates) {
    if dates
      months = dates.map(&:month).join(',')
      years = dates.map(&:year).join(',')
    else
      months = '0'
      years = '0'
    end
    where("extract(month from date) in (#{months}) and extract(year from date) in (#{years})")
  }

  scope :by_date, -> (date) { where(date: Date.parse(date)) unless date.blank? }
  scope :by_counterparty, -> (data) { where(counterparty_id: data) if data }
  scope :by_value, -> (data) { where('value >= ?', data) if data }
  scope :by_type, -> (type) { send(type) if type }

  scope :by_article, -> (data) {
    return if data.blank?
    if ['revenues', 'costs', 'translations'].include? data
      self.send(data)
    elsif data
      where(article_id: data)
    end
  }

  scope :by_year, -> (year) {
    where("extract(year from date) = ?", year)
  }

  delegate :article_name, :type, to: :article

  scope :group_by_month, -> {
    joins(:article).select(" month(date) as month,
                             sum(case when articles.type = '#{Article::TYPES::REVENUE}' then value else 0 end) as revenue,
                             sum(case when articles.type = '#{Article::TYPES::COST}' then value else 0 end) as cost,
                             sum(case when articles.type = '#{Article::TYPES::TRANSLATION}' then value else 0 end) as translation,

                             (sum(case when articles.type = '#{Article::TYPES::REVENUE}' then value else 0 end) - sum(case when articles.type = '#{Article::TYPES::COST}' then value else 0 end)) as profit,
                             sum(case when articles.type = '#{Article::TYPES::LOAN}' then value else 0 end) as loan
                           ").group("month(date)")
  }
end
