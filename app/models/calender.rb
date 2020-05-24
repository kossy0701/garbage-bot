class Calender < ApplicationRecord
  enum garbage_type: [:burnable, :unburnable, :petbottle, :cans, :others]
end
