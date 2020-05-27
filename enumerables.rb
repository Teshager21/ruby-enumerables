# rubocop:disable Style/For
# rubocop:disable Style/MultipleComparison
# rubocop:disable Metrics/PerceivedComplexity
# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/MethodLength
module Enumerable
  # first the each method
  # check the input
  # hash, array?
  # empty block?
  ###############################################
  # considering only arrays
  def my_each
    if block_given?
      for i in 0...length
        yield i
      end
    else
      to_enum(:my_each)
    end
  end

  ############# my each with index #############

  def my_each_with_index
    if block_given?
      (0...length).each do |i|
        yield i, self[i]
      end
    else
      to_enum
    end
  end

  # ############## my select #####################
  def my_select
    temp = []
    my_each do |i|
      temp << i if yield i
    end
    temp
  end

  # ############# my all? ###########################
  def my_all?(arg = nil)
    if !arg.nil?
      if arg.is_a? Regexp
        my_each do |item|
          return false unless item.to_s.match(arg)
        end
      elsif arg.is_a? Class
        my_each do |item|
          return false unless item.instance_of? arg
        end
      else
        my_each do |item|
          return false unless item == arg
        end
      end
    elsif block_given?
      my_each do |item|
        eval = yield item
        return false if eval == false or eval == nil?
      end
    elsif !block_given? && arg.nil?
      my_each do |item|
        p 'are we here?'
        return false if item.nil? or item == false
      end
    end
    true
  end

  #-----------------------------------#
end

######### End of Enumerable Module ############################
p [].my_all?
p [2, 4, 6, 8, 10].my_all?(Numeric)
p [2, 4, 9].my_all?(&:even?)
p [8, 'alen', 'smith'].my_all?(String)
p %w[john john].my_all?('john')

# rubocop:enable Style/For
# rubocop:enable Style/MultipleComparison
# rubocop:enable Metrics/PerceivedComplexity
# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/MethodLength
