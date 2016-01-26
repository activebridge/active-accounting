# encoding: utf-8

class VendorCalculator
  SOCIAL_TAX = 303.16

  def initialize(vendor, params)
    @vendor = vendor
    @translation = params[:translation].to_f
    @rate = @vendor.currency_monthly_payment == 'USD' ? params[:rateDollar].to_f : 1
    @month = params[:month]
  end

  def total_money
    @total_money ||= sprintf("%.2f", (summ_salary/to_index(cash_tax))/to_index(single_tax) + social_tax)
  end

  def summ_salary
    @summ_salary ||= @vendor.value_payment * @rate + @translation
  end

  def total_money_words(salary)
    (I18n.with_locale(:ua) { salary.to_i.to_words gender: :female } + name_currency(salary.split('.')[0])).mb_chars.capitalize.to_s
  end

  def name_currency(number)
    last_symbols = number.last(2)
    if last_symbols.last == '1' && last_symbols != '11'
      " гривня"
    elsif last_symbols.last.to_i > 1 && last_symbols.last.to_i < 5 && last_symbols.first != '1'
      " гривні"
    else
      " гривень"
    end
  end

  def params_new_act
    { vendor_id: @vendor.id,
      total_money: total_money,
      month: @month.to_date }
  end

  def taxes
    @taxes ||= Tax.first
  end

  def social_tax
    taxes.social
  end

  def single_tax
    taxes.single
  end

  def cash_tax
    taxes.cash
  end

  def to_index(tax)
    1 - tax/100
  end
end
