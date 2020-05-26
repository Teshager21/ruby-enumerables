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

  ####################################

  def my_each_with_index
    for i in 0...length
      yield i, self[i]
    end
  end
end

######################################################

ar = [1, 2, 'a', 3, 'b']

ar.my_each do |a|
  puts "this is: #{a}"
end

# ar.my_each

ar.my_each_with_index do |index, val|
  puts "index #{index} for #{val}"
end

# rubocop:enable Style/For
