class WikiCategory < ApplicationRecord
  has_many :wikis

  default_scope { order("seq asc") }
end
