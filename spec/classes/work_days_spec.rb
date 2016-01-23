require 'rails_helper'

RSpec.describe WorkDays, type: :class do
  let(:holiday) { FactoryGirl.create(:holiday, date: Date.new(2015, 10, 9)) }

  describe 'is_working?' do
    it 'working' do
      work_day = WorkDays.new(Date.new(2015, 6, 30))
      expect(work_day.is_working?).to be true
    end

    it 'working in friday when last day of month is sunday' do
      last_day_friday = Date.new(2015, 5, 29)
      work_day = WorkDays.new(last_day_friday)
      expect(work_day.is_working?).to be true
    end

    it 'working in friday when last day of month is saturday' do
      last_day_friday = Date.new(2015, 10, 30)
      work_day = WorkDays.new(last_day_friday)
      expect(work_day.is_working?).to be true
    end

    it 'not working when last day of month is sunday' do
      last_day_sunday = Date.new(2015, 5, 31)
      work_day = WorkDays.new(last_day_sunday)
      expect(work_day.is_working?).to be false
    end

    it 'not working when last day of month is saturday' do
      last_day_saturday = Date.new(2015, 5, 30)
      work_day = WorkDays.new(last_day_saturday)
      expect(work_day.is_working?).to be false
    end

    it 'not working when last day of month is holiday' do
      work_day = WorkDays.new(holiday.date)
      expect(work_day.is_working?).to be false
    end
  end
end
