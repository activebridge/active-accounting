# frozen_string_literal: true
class Register < ActiveRecord::Base
  belongs_to :article
  belongs_to :counterparty
  belongs_to :vendor

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

  validates :date, :article, :value, :counterparty_id, :vendor_id, presence: true
  validates :counterparty_id, uniqueness: { scope: :vendor_id }

  delegate :article_name, :type, to: :article

  scope :revenues, lambda {
    joins(:article).where(articles: { type: Article::TYPES::REVENUE })
  }

  scope :costs, lambda {
    joins(:article).where(articles: { type: Article::TYPES::COST })
  }

  scope :translations, lambda {
    joins(:article).where(articles: { type: Article::TYPES::TRANSLATION })
  }

  scope :loans, lambda {
    joins(:article).where(articles: { type: Article::TYPES::LOAN })
  }

  scope :index_sort, lambda { |params|
    order(date: :desc)
      .by_month(params[:month])
      .by_type(params[:type])
      .by_article(params[:article_id])
      .by_counterparty(params[:counterparty_id])
      .by_vendor(params[:vendor_id])
      .by_date(params[:date])
      .by_value(params[:value])
      .limit(10)
      .offset(params[:offset] ? params[:offset].to_i : 0)
  }

  scope :by_month, lambda { |date|
    unless date.blank?
      date = Date.parse(date)
      where('extract(month from date) = ? AND extract(year from date) = ?', date.month, date.year)
    end
  }

  scope :by_months, lambda { |dates|
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
  scope :by_vendor, -> (data) { where(vendor_id: data) if data }
  scope :by_value, -> (data) { where('value >= ?', data) if data }
  scope :by_type, -> (type) { send(type) if type }

  scope :by_article, lambda { |data|
    return if data.blank?
    if %w(revenues costs translations).include? data
      send(data)
    elsif data
      where(article_id: data)
    end
  }

  scope :by_year, lambda { |year|
    where('extract(year from date) = ?', year)
  }

  scope :group_by_month, lambda {
    joins(:article).select(" month(date) as month,
                             sum(case when articles.type = '#{Article::TYPES::REVENUE}' then value else 0 end) as revenue,
                             sum(case when articles.type = '#{Article::TYPES::COST}' then value else 0 end) as cost,
                             sum(case when articles.type = '#{Article::TYPES::TRANSLATION}' then value else 0 end) as translation,

                             (sum(case when articles.type = '#{Article::TYPES::REVENUE}' then value else 0 end) - sum(case when articles.type = '#{Article::TYPES::COST}' then value else 0 end)) as profit,
                             sum(case when articles.type = '#{Article::TYPES::LOAN}' then value else 0 end) as loan
                           ").group('month(date)')
  }
end
