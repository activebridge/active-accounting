class Charts::GeneralSerializer < ActiveModel::Serializer
  attributes :month, :revenue, :cost, :profit, :translation
end
