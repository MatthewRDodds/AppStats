require 'fileutils'
require 'open3'

class AppStats
  def initialize
    print_stats
  end

  def print_stats
    puts "Controllers:          #{controller_classes.count}"
    puts "Models:               #{model_classes.count}"
    puts "Controller Methods:   #{controller_methods}"
    puts "Models Methods:       #{model_methods}"
    puts "Total Lines:          #{linecount}"
    puts "Total File Count:     #{filecount}"
  end

  def app_dir
    Rails.root.to_s
  end

  def files_in_dir(dir)
    Dir.glob(dir << "/**/**")
  end

  def controller_classes
    files_in_dir "app/controllers"
  end

  def model_classes
    files_in_dir "app/models"
  end

  def linecount
    Open3.popen3("find . | xargs wc -l") do |stdin, stdout, stderr, thread|
      stdout.to_a[-1].match /\d+/
    end
  end

  def filecount
    files_in_dir(app_dir).count
  end

  def methods_in_file(file)
    File.read(file).scan(/[\s\t]def[\s\t]/).size
  end

  def methods_in_dir(dir)
    files_in_dir(dir).map{ |file| methods_in_file file }.sum
  end

  def controller_methods
    methods_in_dir "app/controllers"
  end

  def model_methods
    methods_in_dir "app/models"
  end

  def filename
    app_dir << "statistics"
  end
end

# AppStats.new