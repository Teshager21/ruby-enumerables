# rubocop:disable Style/MultipleComparison, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity, Style/For, Metrics/MethodLength, Metrics/ModuleLength, Security/Eval, Style/EvalWithLocation

module Enumerable
  def my_each
    if !is_a? Hash
      if is_a? Range
        temp_self = to_a
      elsif is_a? Array
        temp_self = self
      end

      if block_given?
        for i in temp_self
          yield i
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

  def my_each_with_index
    return to_enum unless block_given?

    for i in (0...length)
      yield self[i], i
    end
    self
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    temp = []
    my_each do |i|
      temp << i if yield i
    end
    temp
  end

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
        return true if item.nil? == false and item != false
      end
    end
    false
  end

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

  def my_map(arg = nil)
    mapped = []
    if arg.is_a? Proc
      my_each do |item|
        mapped << arg.call(item)
      end
    end
    if block_given? and !arg.is_a? Proc
      my_each do |item|
        mapped << yield(item)
      end
    elsif !block_given? and !arg.is_a? Proc
      return to_enum(:my_map)
    end

    mapped
  end

  def my_inject(arg = nil, symb = nil)
    temp_self = if is_a? Range
                  to_a
                else
                  self
                end

    memo = if arg.nil? or arg.is_a? Symbol
             first
           else
             arg
           end

    symb = arg if arg.is_a? Symbol
    mymethod = symb.to_s unless symb.nil?
    if !block_given?

      if arg.nil? or arg.is_a? Symbol
        for item in 1...to_a.length
          memo = eval "#{memo}#{mymethod}#{temp_self[item]}"
        end
      elsif !arg.nil? and !arg.is_a? Symbol or (!arg.nil? and !symb.nil?)
        for item in 0...temp_self.length

          memo = eval "#{memo}#{mymethod}#{temp_self[item]}"

        end
      end

    elsif arg.nil? and block_given?
      for item in 1...length
        memo = yield memo, self[item]
      end
    elsif block_given? and !arg.nil?
      for item in 0...temp_self.length
        memo = yield memo, temp_self[item]
      end
    end
    memo
  end
end

def multiply_els(arr)
  arr.my_inject(:*)
end

# rubocop:enable all
