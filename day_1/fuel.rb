def total_fuel
  fuel_per_mass = mass_input_values.map { |mass| fuel_for(mass) }
  fuel_per_mass.inject(&:+)
end

def absolute_total_fuel
  fuel_per_mass = mass_input_values.map { |mass| absolute_fuel_for(mass) }
  fuel_per_mass.inject(&:+)
end

def mass_input_values
  File.readlines("./input.txt").map(&:strip).map(&:to_i)
end

def fuel_for(mass)
  [(mass / 3) - 2, 0].max
end

def absolute_fuel_for(mass)
  total = 0
  until mass <= 0
    mass = fuel_for(mass)
    total += mass
  end
  total
end

if __FILE__ == $PROGRAM_NAME
  puts "Total fuel for input: #{total_fuel}"
  puts "Absolute total fuel for input: #{absolute_total_fuel}"
end
