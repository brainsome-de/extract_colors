require 'color'

module Utils

  class << self

    # get all scss files except the config
    def all_scss_files(dir)
      excludes = /(_config|reset)\.css\.scss\Z/
      Dir.glob(File.join(dir, '*.scss')).reject { |path| path =~ excludes }
    end

    def colors_in_file(file) 
      colors = File.read(file).scan(Color::REGEX)  
      colors.flatten.map { |color_string| Color.from_string(color_string) }
    end

    def get_all_colors(dir)
      files = Utils.all_scss_files(dir)

      # get all known colors into an array
      all_colors = files.map { |file| Utils.colors_in_file(file) }
      all_colors = all_colors.flatten.uniq { |c| c.rgba }

      # sort by color value
      all_colors.sort { |a, b| a <=> b }
    end

    def replace_colors_with_variables(files, all_colors)
      files.each do |file| 
        
        content = File.read(file)

        File.open(file, 'w') do |f| 

          content.scan(Color::REGEX).each do |color_string|
            p color_string
            color = all_colors.find { |c| Color.from_string(color_string) == c }
            p color
            index = all_colors.index(color)
            p index
            #puts "#{color_string} => $color#{index}"
            content = content.gsub(color_string, "$color#{index}");
          end

          f.write(content)
        end
      end
    end

    # write all colors to colors.css.scss
    def write_colors_css_file(all_colors)
      all_colors_string = ""
      all_colors.each_with_index do |color, index|
        out = "$color#{index}: #{color.rgba}; // #{color.hex}\n"
        all_colors_string << out
      end

      File.open('app/assets/stylesheets/_colors.css.scss', 'w') do |f| 
        f.write(all_colors_string)
      end
    end

    # generate a html file with color swatches
    def generate_swatches_file(all_colors)
      
      color_swatches = ''
      all_colors.each_with_index do |color, index|
        style = "text-align: center; border: 1px solid #bbb; background-color: #{color.rgba}; width: 200px; height: 200px; display: inline-block; margin: 20px; padding: 20px; font-family: Helvetica; font-size: 16px;"
        color_swatches << "<div style='#{style}'>$color#{index}<br />#{color.rgba}<br />#{color.hex}</div>"
      end
      
      require 'tmpdir'
      temp_dir  = Dir.tmpdir() 
      html_file = File.join(temp_dir, 'color_swatches.html')
      File.open(html_file, 'w') { |f| f.write(color_swatches) }
      `open #{html_file}`
    end
  end
end