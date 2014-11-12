module Pagan
  module Zapps

    module ModuleFunctions
      def get(range)
        if !range[:field] || range[:field].empty?
          field = :id
        else
          field = range[:field].to_sym
        end

        order = range[:order] == "asc" ? Sequel.asc(field) : Sequel.desc(field)

        if !range[:start] && !range[:finish]
          zapps = DB[:zapps].order(order).limit(range[:max])

        else
          if !range[:start]
            if range[:exclusive]
              where = "#{field} <  #{range[:finish]}"
            else
              where = "#{field} <= #{range[:finish]}"
            end

          elsif !range[:finish]
            where = "#{field} >= #{range[:start]}"

          elsif range[:exclusive]
            where = "(#{field} >= '#{range[:start]}') and (#{field} <  '#{range[:finish]}')"

          else
            where = "(#{field} >= '#{range[:start]}') and (#{field} <= '#{range[:finish]}')"
          end

          zapps = DB[:zapps].order(order).limit(range[:max]).where{"#{where}"}
        end

        zapps.all
      end
    end
    extend ModuleFunctions

  end
end
