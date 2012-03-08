require 'json'

module RQuery
  module ClassMethods
    def rquery(cmd)
      # This where the magic happens
      statement = JSON.parse(cmd[:where])

      where statement
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end
end