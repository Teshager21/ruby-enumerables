# rubocop:disable Style/MultipleComparison
# rubocop:disable Metrics/PerceivedComplexity
# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Style/For
# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/ModuleLength
# rubocop:disable Security/Eval
# rubocop:disable Style/EvalWithLocation

module Enumerable
  # check the input
  # hash, array?
  # empty block?
  ###############################################
  # considering only arrays
  def my_each
    if !is_a? Hash
      if is_a? Range
        temp_self = to_a
      elsif is_a? Array
        temp_self = self
      end

      if block_given?
        for i in 0...to_a.length
          yield temp_self[i]
        end
      else
        to_enum(:my_each)
      end
    elsif is_a? Hash
      for i in 0..keys.length
        yield keys[i], values[i]
      end
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

  ########################################################
  def my_map(&block)
    mapped = []
    exec = block if block_given?
    if exec.is_a? Proc
      my_each do |item|
        mapped << exec.call(item)
      end
      return to_enum(:my_map) unless exec.is_a? Proc
    end

    mapped
  end

  ###########################################

  def my_inject(arg = nil, symb = nil)
    if is_a? Range
      length = to_a.length
      temp_self = to_a
    else
      temp_self = self
    end

    p temp_self
    memo = if arg.nil? or arg.is_a? Symbol
             first
           else
             arg
           end
    symb = arg if arg.is_a? Symbol and symb.nil?
    unless symb.nil?
      mymethod = symb.to_s
      for item in 1...to_a.length

        memo = eval "#{memo}#{mymethod}#{temp_self[item]}"
      end
    end
    if block_given?
      for item in 1...length
        memo = yield memo, self[item]
      end
    end
    memo
  end
  ############################################################

  def multiply_els
    my_inject(:*)
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

# ary = [1, 2, 4, 2]
# p ary.my_count
# p ary.my_count(2)
# p ary.my_count(&:even?)
# s=Proc.new{ |i| i * i }}
# p [1,2,3].s
# p([1, 2, 3, 4].my_map { |i| i * i })
# p [1, 2, 3, 4, 5].my_map
# p [1,2,3,4].my_inject{|sum,a| sum+=a}
# p [1, 2, 3, 4, 5, 8].my_inject(:+)
# p [2, 3, 4].my_inject(:*)
# p (1..4).my_inject(:+)
# p [1, 2, 3, 4].multiply_els
# p [1, 2, 3, 4, 5, 8].my_map(:+)
# p [1, 2, 3, 4, 5, 8].my_map
# p [1,2,3,4].my_each {|item| puts item}
# s={:color => 'white',:age=>20}
#  p s.is_a? Hash
# # p s.values[0]
#  p s.my_each {|item,val| puts val;puts item}

###########################################################

# rubocop:enable Style/For
# rubocop:enable Style/MultipleComparison
# rubocop:enable Metrics/PerceivedComplexity
# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/ModuleLength
# rubocop:enable Security/Eval
# rubocop:enable Style/EvalWithLocation
