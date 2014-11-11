require "json"
require "sequel"
require "sinatra"

require "pagan"

DB = Sequel.connect("postgres://localhost/pagan")

get "/" do
  range = RangeParser.parse request.env["HTTP_RANGE"] || {}

  set_headers range

  Zapps.get range
end

def set_headers(range)
  headers["Content-Range"] = "#{range[:field]} #{range[:start]}..#{range[:finish]}"

  if range[:exclusive]
    headers["Next-Range"]    = "]#{range[:finish]}; max=#{range[:max]}, order=#{range[:order]}"
  else
    headers["Next-Range"]    = "#{range[:finish]}; max=#{range[:max]}, order=#{range[:order]}"
  end
end
