class Calender < ApplicationRecord
  enum garbage_type: [:burnable, :unburnable, :petbottle, :cans, :others]

  def garbage_type_str
    if garbage_type
      {burnable: '燃えるゴミの日', unburnable: '燃えないごみ・古紙類の日', petbottle: 'ペットボトルの日', cans: '缶の日', others: 'ビン・古着・危険ごみ・白色トレイの日'}[garbage_type.to_sym]
    else
      '何も捨てられない日'
    end
  end
end
