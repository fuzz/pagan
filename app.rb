require "json"
require "sequel"
require "sinatra"

require_relative "lib/range_parser"

DB = Sequel.connect("postgres://localhost/pagan")

get "/" do
  range = RangeParser.parse request.env["HTTP_RANGE"] || {}

  set_headers(range)

  get_zapps(range)
end

def get_zapps(range)
  field  = range[:field].to_sym
  order  = range[:order] == "asc" ? Sequel.asc(field) : Sequel.desc(field)

  if range[:exclusive]
    zapps = DB[:zapps].order(order).limit(range[:max]).where(field => range[:start]...range[:finish])
  else
    zapps = DB[:zapps].order(order).limit(range[:max]).where(field => range[:start]..range[:finish])
  end

  zapps.all.to_json
end

def set_headers(range)
  headers["Content-Range"] = "#{range[:field]} #{range[:start]}..#{range[:finish]}"

  if range[:exclusive]
    headers["Next-Range"]    = "]#{range[:finish]}; max=#{range[:max]}, order=#{range[:order]}"
  else
    headers["Next-Range"]    = "#{range[:finish]}; max=#{range[:max]}, order=#{range[:order]}"
  end
end
