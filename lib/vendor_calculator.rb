class VendorCalculator
  SOCIAL_TAX = 422.65

  def initialize(vendor, params)
    @vendor = vendor
    @translation = params[:translation].to_f
    @rate = @vendor.currency_monthly_payment == "USD" ? params[:rateDollar].to_f : 1
    @month = params[:month]
  end

  def total_money
    @total_money ||= sprintf("%.2f", (summ_salary + summ_salary * 0.0075)/0.96)
  end

  def summ_salary
    @summ_salary ||= @vendor.value_payment * @rate + SOCIAL_TAX + @translation
  end

  def total_money_words salary
    (I18n.with_locale(:ua) { salary.to_i.to_words gender: :female } + name_currency(salary.split('.')[0])).mb_chars.capitalize.to_s
  end

  def name_currency number
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
end
