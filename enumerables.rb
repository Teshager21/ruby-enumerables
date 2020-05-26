# rubocop:disable Style/For
module Enumerable
  # first the each method
  # check the input
  # hash, array?
  # empty block?

  # considering only arrays
  def my_each
    if block_given?
      for i in self
        yield i
      end
    else
      to_enum
    end
  end

  ###################################

  def my_each_with_index
    if block_given?
      for i in 0...length
        yield i, self[i]
      end
    else
      to_enum
    end
  end

  ###################################
  def my_select
    temp = []
    my_each do |i|
      temp << i if yield i
    end
    temp
  end

  #-----------------------------------#
end

#####################################

ar = [1, 2, 5, 3, 8]

ar.my_each do |a|
  puts "this is: #{a}"
end

ar.my_each

ar.my_each_with_index do |index, val|
  puts "index #{index} for #{val}"
end

n = ar.my_select(&:odd?)
p n

# rubocop:enable Style/For
