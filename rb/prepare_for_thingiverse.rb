#!/usr/bin/env ruby

def replace_contents(pegboard_file_content, file_content)
  return pegboard_file_content + file_content.gsub('use <pegboard.scad>', '')
end

puts 'Generating .scad files for thingiverse'

root = `git rev-parse --show-toplevel`.strip

Dir.chdir root do
  stl_files = `git ls-files ':*.scad' ':!*pegboard.scad'`
                .lines
                .map { |f| f.strip }

  pegboard_file = `git ls-files :*pegboard.scad`.strip
  pegboard_file_content = File.read pegboard_file

  Dir.mkdir 'thingiverse' unless File.exist? 'thingiverse'
  stl_files.each do |filename|
    content = File.read filename

    Dir.chdir 'thingiverse' do
      name = File.basename filename

      puts name

      File.open name, 'w' do |f|
        f << replace_contents(pegboard_file_content, content)
      end
    end
  end
end

