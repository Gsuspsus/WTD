# frozen_string_literal: true
require 'json'
require_relative 'lexer_rule'

# Loads lexing rules stored in a json format
class LexerRulesLoader
  def self.load(path)
    rules_data = JSON.parse(File.read(path))
    rules_data.map do |regex, type|
      LexerRule.new(Regexp.new(regex), type.to_sym)
    end
  end
end
