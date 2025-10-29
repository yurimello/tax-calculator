#!/usr/bin/env ruby
require 'optparse'
require_relative '../lib/autoload'

options = {}

# Define and parse options
OptionParser.new do |opts|
  opts.banner = "Usage: #{File.basename(__FILE__)} [options]"

  opts.on("-f", "--file FILE", "Path to a .txt file") do |file|
    options[:file] = file
  end

  opts.on("-h", "--help", "Show this help message") do
    puts opts
    exit
  end
end.parse!

if options[:file].nil?
  puts "Error: No file provided."
  puts "Use -h for help."
  exit 1
end

file_path = options[:file]

unless File.exist?(file_path)
  puts "Error: '#{file_path}' is not a valid .txt file."
  exit 1
end

cart = CartImporterService.call(file_path).cart