class Results < Struct.new(:file, :variables, :name_length)

  class << self
    def for(type)
      const_get type.to_s.capitalize
    end
  end

  def display
    formatted(variables).unshift(header).join("\n") unless variables.empty?
  end

  def to_s
    display or ''
  end

private

  def formatted(variables)
    variables.map do |name, value|
      format_variable name, value
    end
  end

  class Applied < self

    def header
      "Applied variables from #{file}:"
    end

    def format_variable(name, value)
      format "  %-#{name_length}s => %s", name, value
    end

  end

  class Ignored < self

    def header
      'Ignored already set variables:'
    end

    def format_variable(name, value)
      format "  %-#{name_length}s => %s\n   %-#{length-1}s => %s", name, value, 'already', ENV[name]
    end

  end

end
