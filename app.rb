require "json"
require "sequel"
require "sinatra"

require_relative "lib/range_parser"

DB = Sequel.connect("postgres://localhost/pagan")

#
# = Examples
#
# To encode JSON:
#
#   JSON.generate([1, 2, 3])
#
# Get a query parameter:
#
#   params[:max]
#
# Get a request header:
#
#   request.env["HTTP_RANGE"]
#
# Set a response header:
#
#   headers["Range"] = "hello"
#
# Connect to a database using Sequel:
#
#   DB = Sequel.connect(ENV["DATBASE_URL"])
#   DB[:items].limit(5).all
#

get "/" do
  range = RangeParser.parse request.env["HTTP_RANGE"]

  if range[:field] == "id"
    if range[:order] == "asc"
      if range[:exclusive]
        zapps = DB[:zapps].order(:id).limit(range[:max]).where(id: range[:start]...range[:finish])
      else
        zapps = DB[:zapps].order(:id).limit(range[:max]).where(id: range[:start]..range[:finish])
      end
    else
      if range[:exclusive]
        zapps = DB[:zapps].reverse_order(:id).limit(range[:max]).where(id: range[:start]...range[:finish])
      else
        zapps = DB[:zapps].reverse_order(:id).limit(range[:max]).where(id: range[:start]..range[:finish])
      end
    end

  else
    if range[:order] == "asc"
      if range[:exclusive]
        zapps = DB[:zapps].order(:name).limit(range[:max]).where(name: range[:start]...range[:finish])
      else
        zapps = DB[:zapps].order(:name).limit(range[:max]).where(name: range[:start]..range[:finish])
      end
    else
      if range[:exclusive]
        zapps = DB[:zapps].reverse_order(:name).limit(range[:max]).where(name: range[:start]...range[:finish])
      else
        zapps = DB[:zapps].reverse_order(:name).limit(range[:max]).where(name: range[:start]..range[:finish])
      end
    end
  end

  headers["Content-Range"] = "#{range[:field]} #{range[:start]}..#{range[:finish]}"

  if range[:exclusive]
    headers["Next-Range"]    = "]#{range[:finish]}; max=#{range[:max]}, order=#{range[:order]}"
  else
    headers["Next-Range"]    = "#{range[:finish]}; max=#{range[:max]}, order=#{range[:order]}"
  end

  zapps.all.to_json
end
