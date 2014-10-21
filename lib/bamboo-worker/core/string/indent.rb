# Add methods to StringClass
class String
  # Indent string from level
  #
  # Examples:
  #
  # "test".indent(1)
  # # => "  test"
  #
  # @param [String] level Level to indent multiplied by two
  # return [String]
  def indent(level)
    split("\n").map { |line| ' ' * (level * 2) + line }.join("\n")
  end
end
