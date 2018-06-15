class Kind1 < ActiveRecord::Base
  has_many :kind2s, dependent: :destroy
end
