require 'json'

module RQuery
  module ClassMethods
    def rquery(cmd=nil)
      if cmd
        ar_statement = ''
        # TODO includes_clause(JSON.parse(cmd[:includes])) if cmd[:includes]
        # TODO joins_clause(JSON.parse(cmd[:joins])) if cmd[:joins]
        ar_statement += where_clause(JSON.parse(cmd[:where])) if cmd[:where]
        ar_statement += order_clause(JSON.parse(cmd[:order])) if cmd[:order]
        ar_statement += limit_clause(cmd[:limit]) if cmd[:limit]
        ar_statement += skip_clause(cmd[:skip]) if cmd[:skip]
        ar_statement = (ar_statement == '' ? {:results => eval('all').to_a} : {:results => eval(ar_statement[1..-1]).to_a})
        ar_statement = count_clause(cmd[:count], ar_statement) if cmd[:count]
        ar_statement[:results].present? || ar_statement[:count].present? ? ar_statement : {}
      else
        {}
      end
    end

  private
    ## WHERE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def where_clause(cmd)
      ar_statement, clause = ""
      cmd.each do |key, value|
        clause = value.kind_of?(Hash) ? where_key_value(key, value) : "#{self.name.tableize}.#{key} = \"" + value + "\""
        ar_statement += ".where('#{clause}')"
      end
      ar_statement
    end

    def where_key_value(key, value)
      action, val = ''
      value.each do |k, v|
        action = replace(k) if k.match(/^\$/)
        val = v
      end
      where_build_clause(key, action, val)
    end

    def where_build_clause(key, action, val)
      if action == 'IS'
        "#{key} #{action} #{val == '1' ? 'NOT NULL' : 'NULL'}"
      elsif action == "IN" || action == "NOT IN"
        "#{key} #{action} #{val.gsub("\'", "\"")}"
      else
        "#{key} #{action} \"" + val.to_s + "\""
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
      cmd.each { |value| ar_statement += ".limit(#{value})" }
      ar_statement
    end

    ## COUNT ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def count_clause(cmd, ar_statement)
      if cmd == "1"
        ar_statement.merge(:count => ar_statement[:results].count)
      else
        ar_statement
      end
    end

    ## SKIP ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def skip_clause(cmd)
      ar_statement = ""
      cmd.each { |value| ar_statement += ".offset(#{value})" }
      ar_statement
    end

    #TODO
    ## INCLUDES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def includes_clause(cmd)
      includes cmd
    end

    #TODO
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
