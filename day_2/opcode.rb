def collect_input
  File.readlines("./input.txt").first.strip.split(",").map(&:to_i)
end

def prepare(input_array, value_one = 12, value_two = 2)
  input_array[1] = value_one
  input_array[2] = value_two
  input_array
end

def run(input_array)
  pos = 0
  val = input_array[pos]
  until val == 99
    input_pos_one = input_array[pos + 1]
    input_pos_two = input_array[pos + 2]
    output_pos = input_array[pos + 3]
    if val == 1
      input_array[output_pos] = input_array[input_pos_one] + input_array[input_pos_two]
    elsif val == 2
      input_array[output_pos] = input_array[input_pos_one] * input_array[input_pos_two]
    else
      raise "hell"
    end
    pos += 4
    val = input_array[pos]
  end
  input_array
end

def find_correct_inputs
  (0..99).each do |i|
    (0..99).each do |j|
      input = prepare(collect_input, i, j)
      executed = run(input)
      return [i, j] if executed.first == 19690720
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  input = prepare(collect_input)
  executed = run(input)
  puts "First value in executed program is #{executed.first}."
  correct_inputs = find_correct_inputs
  puts "Inputs that produce value 19690720 are #{correct_inputs.first} and #{correct_inputs.last}"
end
