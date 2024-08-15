#!/usr/bin/env ruby

STDIN.each_line do |line|
  if line =~ /include <([^)]+)>/
    included = $1
    puts File.read "thingiverse/#{included}"
  else
    puts line
  end
end
