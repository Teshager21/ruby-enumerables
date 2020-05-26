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
end

# include Enumerable
ar = [1, 2, 'a', 3, 'b']

ar.my_each do |a|
  puts "this is: #{a}"
end
ar.my_each

# rubocop:enable Style/For
