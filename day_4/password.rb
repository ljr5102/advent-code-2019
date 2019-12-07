def possible_password?(input, range, strict_adjacent:)
  digit_array = split_input(input)

  correct_length?(digit_array) &&
    within_range?(digit_array, range) &&
    (strict_adjacent ? small_group_adjacent_digits?(digit_array) : adjacent_digits?(digit_array)) &&
    no_decrease?(digit_array)
end

def correct_length?(digit_array)
  digit_array.length == 6
end

def within_range?(digit_array, range)
  range.include?(digit_array.join("").to_i)
end

def adjacent_digits?(digit_array)
  digit_array.each_index do |idx|
    if digit_array[idx] == digit_array[idx + 1]
      return true
    end
  end
  false
end

def small_group_adjacent_digits?(digit_array)
  match_count = Hash.new(0)
  digit_array.each_index do |idx|
    if digit_array[idx] == digit_array[idx + 1]
      match_count[digit_array[idx]] += 1
    end
  end
  match_count.values.any? { |val| val == 1 }
end

def no_decrease?(digit_array)
  digit_array.each_index do |idx|
    next if idx == digit_array.length - 1
    if digit_array[idx] > digit_array[idx + 1]
      return false
    end
  end
  true
end

def split_input(input)
  digits = []
  until input.zero?
    digits.unshift(input % 10)
    input /= 10
  end
  digits
end

def all_potential_passwords(range, strict_adjacent: false)
  range.select { |el| possible_password?(el, range, strict_adjacent: strict_adjacent) }
end

if __FILE__ == $PROGRAM_NAME
  puts "There are #{all_potential_passwords((172851..675869)).length} potential passwords for the range 172851-675869 with the simple adjacent digit rule"
  puts "There are #{all_potential_passwords((172851..675869), strict_adjacent: true).length} potential passwords for the range 172851-675869 with the strict adjacent digit rule"
end
