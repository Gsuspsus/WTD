# frozen_string_literal: true

# Loads lexing rules stored in a json format
class LexerRulesLoader
  def self.load(path)
    require 'json'
    require_relative 'LexerRule'
    rules = JSON.parse(File.read(path))
    rules.map do |regex, type|
      LexerRule.new(Regexp.new(regex), type.to_sym)
    end
  end
end
