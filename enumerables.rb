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

  def my_each_with_index
    if block_given?
      for i in (0...length)
        yield i, self[i]
      end
    else
      to_enum
    end
  end

  def my_select
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
        return true if item.nil? == false or item != false
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

  def multiply_els
    my_inject(:*)
  end
end

# rubocop:enable all
