class Color

  attr_reader :rgba
  
  REGEX = /#[a-f0-9]{3}(?![-\w0-9_])|#[a-f0-9]{6}(?![-\w0-9_])|rgba?\(.+?\)/i

  def self.from_string(string)
    raise "Invalid color string: '#{string}'" if string !~ REGEX
    new(string)
  end

  def initialize(string)
    @rgba = (string[0] == '#') ? hex_to_rgba(string) : rgb_to_rgba(string)
  end

  def ==(other)
    @rgba == other.rgba
  end

  def <=>(other)
    # yay for recursion! :->
    comparsion = r <=> other.r
    if (comparsion == 0) 
      comparsion = g <=> other.g
      if (comparsion == 0) 
        comparsion = b <=> other.b
        if (comparsion == 0) 
          comparsion = a <=> other.a
        end
      end
    end
    comparsion
  end

  def to_s
    "<Color #{rgba}, hex: #{hex}>"
  end

  %w(r g b a).each_with_index do |letter, index|
    define_method(letter) do
      color_value_at(index)
    end
  end

  def hex
    '#' + (0..2).map do |offset| 
      hex_value = color_value_at(offset).to_s(16)
      # 0 => 00
      hex_value = "0#{hex_value}" if (hex_value.length == 1)
      hex_value
    end.join
  end

  private

    # #00ff99 => rgb(0, 255, 158, 0)
    def hex_to_rgba(hex)
      hex = hex.gsub('#', '')
      if (hex.length == 3)
        rgb_parts = hex.scan(/.{1}/)
        rgb_parts = rgb_parts.map { |part| "#{part}#{part}" }
      elsif (hex.length == 6)
        rgb_parts = hex.scan(/.{2}/)
      else 
        raise "Error on #{hex}, length without # must be 3 or 6"
      end
      rgb_parts = rgb_parts.map { |part| part.to_i(16) }
      "rgba(%s, 1)" % rgb_parts.join(', ')
    end

    # rgb(255,255,255) => rgba(255, 255, 255, 1)
    # rgba(255,255,255, 1) --> rgba(255, 255, 255, 1)
    def rgb_to_rgba(rgb)
      # normalize white-space
      rgb = rgb.gsub(/,[ ]*/, ", ") 
      if rgb =~ /rgba/
        rgb 
      else
        # add alpha value
        values = rgb.scan(/\d+/)
        "rgba(%s, 1)" % values.join(', ')
      end
    end

    def color_value_at(offset)
      @color_values ||= @rgba.scan(/\d+/).map { |v| v.to_i }
      @color_values[offset]
    end

end