module Pagan
  module RangeParser

    # Range: <field> [[<exclusivity operator>]<start identifier>]]..[<end identifier>][; [max=<max number of results>], [order=[<asc|desc>]]
    # For example "id ]5..10; max=5, order=desc"

    module ModuleFunctions
      def parse(range_header)
        expression, options = range_header.split ";"
        field, identifiers  = expression.split " "

        if identifiers
          case identifiers[0]
          when /\]/
            exclusive = true
            identifiers.slice! 0
          when /\[/
            exclusive = false
            identifiers.slice! 0
          else
            exclusive = false
          end

          start, finish = identifiers.split ".."

        else
          exclusive = false
          start     = ""
          finish    = ""
        end

        if options
          max = options[/\d/] || "200"
          order = options.downcase.include?("desc") ? "desc" : "asc"
        else
          max = "200"
          order = "asc"
        end

        {
          field: field,
          exclusive: exclusive,
          start: start,
          finish: finish,
          max: max,
          order: order
        }
      end
    end
    extend ModuleFunctions

  end
end
