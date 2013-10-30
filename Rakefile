$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'utils'

task :extract do
  root = ENV['ROOT']
  if (!root || !File.exist?(root))
    puts 'please specify a valid root directory with ROOT=/path/to/dir'
    exit
  end
  colors = Utils.get_all_colors(root)
  p colors
  # Utils.replace_colors_with_variables(Utils.all_scss_files, colors)
  # Utils.write_colors_css_file(colors)
  # Utils.generate_swatches_file(colors)  
end