# rubocop:disable Style/MultipleComparison
# rubocop:disable Metrics/PerceivedComplexity
# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Style/For
# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/ModuleLength

module Enumerable
  # check the input
  # hash, array?
  # empty block?
  ###############################################
  # considering only arrays
  def my_each
    if block_given?
      for i in 0...length
        yield self[i]
      end
    else
      to_enum(:my_each)
    end
  end

  ############# my each with index #############

  def my_each_with_index
    if block_given?
      for i in (0...length)
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
        return false if item.nil? or item == false
      end
    end
    true
  end
  #################################################

  def my_any?(arg = nil)
    if !arg.nil?
      if arg.is_a? Regexp
        my_each do |item|
          return true if item.to_s.match(arg)
        end
      elsif arg.is_a? Class
        my_each do |item|
          return true if item.instance_of? arg
        end
      else
        my_each do |item|
          return true if item == arg
        end
      end
    elsif block_given?
      my_each do |item|
        eval = yield item
        return true if eval == true
      end
    elsif !block_given? && arg.nil?
      my_each do |item|
        return true if item.nil? == false or item != false
      end
    end
    false
  end
  #########################################################

  def my_none?(arg = nil)
    if !arg.nil?
      if arg.is_a? Regexp
        my_each do |item|
          return false if item.to_s.match(arg)
        end
      elsif arg.is_a? Class
        my_each do |item|
          return false if item.instance_of? arg
        end
      else
        my_each do |item|
          return false if item == arg
        end
      end
    elsif block_given?
      my_each do |item|
        eval = yield item
        return false if eval == true
      end
    elsif !block_given? && arg.nil?
      my_each do |item|
        return false unless item.nil? or item == false
      end
    end
    true
  end

  ########################################################
  def my_count(arg = nil)
    counter = 0
    return length if arg.nil? and !block_given?

    if block_given?
      my_each do |item|
        counter += 1 if yield item
      end
    else
      my_each do |item|
        counter += 1 if item == arg
      end
    end

    counter
  end

  #-----------------------------------#
end

######### End of Enumerable Module ############################

# p [].my_all?
# p [2, 4, 6, 8, 10].my_all?(Numeric)
# p [2, 4, 9].my_all?(&:even?)
# p [8, 'alen', 'smith'].my_all?(String)
# p %w[john john].my_all?('john')

# p { %w[ant bear cat].my_any? { |word| word.length >= 3 } }
# p { %w[ant bear cat].my_any? { |word| word.length > 4 } }
# p [nil, false, nil].my_any?(/t/)
# p [nil, true, 'h'].my_any?(Integer)
# p "#{[nil, true, 99].my_any?} :yeap"
# p [].my_any?
# p(%w[ant bear cat].my_none? { |word| word.length == 5 })
# p(%w[ant bear cat].my_none? { |word| word.length >= 4 })
# p %w[ant bear cat].my_none?(/d/)
# p [1, 2, 3.14, 14, 42].my_none?(Float)
# p [].my_none?
# p [nil].my_none?
# p [nil, false].my_none?
# p [nil, false, true].my_none?

ary = [1, 2, 4, 2]
p ary.my_count
p ary.my_count(2)
p ary.my_count(&:even?)

###########################################################

# rubocop:enable Style/For
# rubocop:enable Style/MultipleComparison
# rubocop:enable Metrics/PerceivedComplexity
# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/ModuleLength
