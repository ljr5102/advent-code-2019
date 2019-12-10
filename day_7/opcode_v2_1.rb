def collect_input
  File.readlines("./input.txt").first.strip.split(",").map(&:to_i)
end

def run(input_array, user_inputs)
  pos = 0
  val = input_array[pos]
  op_code = parse_op_code(val)
  user_input_idx = 0
  until op_code == 99
    if [1, 2, 5, 6, 7, 8].include?(op_code)
      input_pos_one = input_array[pos + 1]
      input_pos_two = input_array[pos + 2]
      first_param = parse_parameter_mode(val, 1)
      second_param = parse_parameter_mode(val, 2)
      third_param = parse_parameter_mode(val, 3) # not really necessary
      output_pos = input_array[pos + 3]
      first_val = val_by_param(input_array, input_pos_one, first_param)
      second_val = val_by_param(input_array, input_pos_two, second_param)
      if op_code == 1
        input_array[output_pos] = first_val + second_val
        pos += 4
      elsif op_code == 2
        input_array[output_pos] = first_val * second_val
        pos += 4
      elsif op_code == 5
        pos = first_val.positive? ? second_val : pos + 3
      elsif op_code == 6
        pos = first_val.zero? ? second_val : pos + 3
      elsif op_code == 7
        input_array[output_pos] = first_val < second_val ? 1 : 0
        pos += 4
      elsif op_code == 8
        input_array[output_pos] = first_val == second_val ? 1 : 0
        pos += 4
      end
    elsif op_code == 3 || op_code == 4
      output_pos = input_array[pos + 1]
      first_param = parse_parameter_mode(val, 1)
      output_val = val_by_param(input_array, output_pos, first_param)
      if op_code == 3
        # print "Please enter input: "
        # input_array[output_pos] = gets.chomp.to_i
        input_array[output_pos] = user_inputs[user_input_idx]
        user_input_idx += 1
      elsif op_code == 4
        return output_val
      end
      pos += 2
    else
      raise "hell"
    end
    val = input_array[pos]
    op_code = parse_op_code(val)
  end
  input_array
end

def parse_op_code(val)
  val % 10
end

def parse_parameter_mode(val, parameter)
  if parameter == 1
    val / 100 % 10
  elsif parameter == 2
    val / 1000 % 10
  elsif parameter == 3
    val / 10000 % 10
  else
    raise "hell"
  end
end

def val_by_param(array, pos, param)
  if param == 0
    array[pos]
  elsif param == 1
    pos
  else
    raise "hell"
  end
end

def run_series
  settings = [0, 1, 2, 3, 4]
  max = 0
  max_combo = []
  settings.permutation.map(&:to_a).each do |combo|
    secondary_input = 0
    combo.each_with_index do |setting, idx|
      input = collect_input
      initial_input = setting
      secondary_input = run(input, [initial_input, secondary_input])
    end
    new_max = secondary_input > max
    if new_max
      max = secondary_input
      max_combo = combo
    end
  end
  { max_val: max, combo: max_combo }
end

if __FILE__ == $PROGRAM_NAME
  result = run_series
  puts "The max signal is #{result[:max_val]} with a combination of #{result[:combo].join(",")}"
end
