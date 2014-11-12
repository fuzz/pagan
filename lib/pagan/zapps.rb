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
        elsif !range[:start]
          if range[:exclusive]
            zapps = DB[:zapps].order(order).limit(range[:max]).where{"#{field} <  #{range[:finish]}"}
          else
            zapps = DB[:zapps].order(order).limit(range[:max]).where{"#{field} <= #{range[:finish]}"}
          end
        elsif !range[:finish]
          zapps = DB[:zapps].order(order).limit(range[:max]).where{"#{field} >= #{range[:start]}"}
        elsif range[:exclusive]
          zapps = DB[:zapps].order(order).limit(range[:max]).where(field => range[:start]...range[:finish])
        else
          zapps = DB[:zapps].order(order).limit(range[:max]).where(field => range[:start]..range[:finish])
        end

        zapps.all
      end
    end
    extend ModuleFunctions

  end
end
