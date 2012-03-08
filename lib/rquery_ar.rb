require 'json'

module RQuery
  module ClassMethods
    def rquery(cmd)
      ar_statement = ''
      ar_statement += where_clause(JSON.parse(cmd[:where])) if cmd[:where]
      # order_clause(JSON.parse(cmd[:order])) if cmd[:order]
      # limit_clause(JSON.parse(cmd[:limit])) if cmd[:limit]
      # count_clause(JSON.parse(cmd[:count])) if cmd[:count]
      # includes_clause(JSON.parse(cmd[:includes])) if cmd[:includes]
      # skip_clause(JSON.parse(cmd[:skip])) if cmd[:skip]
      # joins_clause(JSON.parse(cmd[:joins])) if cmd[:joins]
      eval(ar_statement[1..-1])
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
      value.each{ |k, v| action = replace(k) if k.match(/^\$/); val = v }
      "#{key} #{action} \"" + val + "\""
    end
    ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    def order_clause(cmd)
      order cmd
    end

    def limit_clause(cmd)
      limit cmd
    end

    def count_clause(cmd)
      count cmd
    end

    def includes_clause(cmd)
      includes cmd
    end

    def skip_clause(cmd)
      skip cmd
    end

    def joins_clause(cmd)
      joins cmd
    end

    def replace(match_data)
      case match_data
        when '$gt' then '>'
        when '$lt' then '<'
        when '$gte' then '>='
        when '$lte' then '<='
        when '$ne' then '!='
        when '$in' then 'in'
        when '$nin' then 'not in'
        when '$exists' then 'exists'
        when '$like' then 'like'
        when '$regexp' then 'regexp'
      end
    end

  end

  def self.included(base)
    base.extend(ClassMethods)
  end
end