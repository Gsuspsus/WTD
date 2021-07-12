# frozen_string_literal: true

# Loads lexing rules stored in a json format
class LexerRulesLoader
  def self.load(path)
    require 'json'
    rules = JSON.parse(File.read(path))
    rules.map { |regex, type| [Regexp.new(regex), type.to_sym] }.to_h
  end
end
