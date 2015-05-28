require 'rails_helper'

RSpec.describe ConvertString, type: :class do
  let(:convert_string) { ConvertString.new }

  it 'convert full_name_to_short_name' do
    expect(convert_string.full_name_to_short_name('Галушка Олександр Анатолійович')).to eq('Галушка О.А.')
  end
end
