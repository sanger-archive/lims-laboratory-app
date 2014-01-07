module Lims::LaboratoryApp
  class BooleanUtils

    TRUE_VALUES = [true, 1, '1', 't', 'T', 'true', 'TRUE', 'on', 'ON'].to_set
    FALSE_VALUES = [false, 0, '0', 'f', 'F', 'false', 'FALSE', 'off', 'OFF'].to_set

    def value_to_boolean(value)
      if value.is_a?(String) && value.empty?
        nil
      else
        TRUE_VALUES.include?(value)
      end
    end
  end
end
