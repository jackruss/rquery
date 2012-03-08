require 'json'

module RQuery
  module ClassMethods
    def rquery(cmd)
      ar_statement = ''
      ar_statement += where_clause(JSON.parse(cmd[:where])) if cmd[:where]
      ar_statement += order_clause(JSON.parse(cmd[:order])) if cmd[:order]
      ar_statement += limit_clause(cmd[:limit]) if cmd[:limit]
      # count_clause(JSON.parse(cmd[:count])) if cmd[:count]
      # includes_clause(JSON.parse(cmd[:includes])) if cmd[:includes]
      # skip_clause(JSON.parse(cmd[:skip])) if cmd[:skip]
      # joins_clause(JSON.parse(cmd[:joins])) if cmd[:joins]
      eval(ar_statement[1..-1]).to_a
    end

  private
    ## WHERE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def where_clause(cmd)
      ar_statement, clause = ""
      cmd.each do |key, value|
        clause = value.kind_of?(Hash) ? build_key_value(key, value) : "#{key} = \"" + value + "\""
        ar_statement += ".where('#{clause}')"
      end
      ar_statement
    end

    def build_key_value(key, value)
      action, val = ''
      value.each do |k, v|
        action = replace(k) if k.match(/^\$/)
        val = v
      end
      build_clause(key, action, val)
    end

    def build_clause(key, action, val)
      if action == 'IS'
        "#{key} #{action} #{val == '1' ? 'NOT NULL' : 'NULL'}"
      elsif action == "IN" || action == "NOT IN"
        "#{key} #{action} #{val.gsub("\'", "\"")}"
      else
        "#{key} #{action} \"" + val + "\""
      end
    end

    ## ORDER ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def order_clause(cmd)
      ar_statement = ""
      cmd.each do |value|
        ar_statement += ".order('#{value}')"
      end
      ar_statement
    end

    ## LIMIT ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def limit_clause(cmd)
      ar_statement = ""
      cmd.each do |value|
        ar_statement += ".limit(#{value})"
      end
      ar_statement
    end

    ## COUNT ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def count_clause(cmd)
      count cmd
    end

    ## INCLUDES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def includes_clause(cmd)
      includes cmd
    end

    ## SKIP ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def skip_clause(cmd)
      skip cmd
    end

    ## JOINS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def joins_clause(cmd)
      joins cmd
    end

    ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def replace(match_data)
      case match_data
        when '$gt' then '>'
        when '$lt' then '<'
        when '$gte' then '>='
        when '$lte' then '<='
        when '$ne' then '!='
        when '$in' then 'IN'
        when '$nin' then 'NOT IN'
        when '$exists' then 'IS'
        when '$like' then 'LIKE'
        when '$ilike' then 'ILIKE'
        when '$regexp' then 'REGEXP'
      end
    end

  end

  def self.included(base)
    base.extend(ClassMethods)
  end
end