module Pagan
  module Zapps

    module ModuleFunctions
      def get(range)
        field = range[:field].to_sym
        order = range[:order] == "asc" ? Sequel.asc(field) : Sequel.desc(field)

        if range[:exclusive]
          zapps = DB[:zapps].order(order).limit(range[:max]).where(field => range[:start]...range[:finish])
        else
          zapps = DB[:zapps].order(order).limit(range[:max]).where(field => range[:start]..range[:finish])
        end

        zapps.all.to_json
      end
    end
    extend ModuleFunctions

  end
end
