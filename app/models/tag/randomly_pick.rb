class Array
  def randomly_pick(number)
    sort_by{ rand }.slice(0...number)
  end
end
