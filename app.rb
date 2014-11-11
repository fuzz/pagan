require "json"
require "pagan"
require "sequel"
require "sinatra"

DB = Sequel.connect("postgres://localhost/pagan")

get "/" do
  range = Pagan::RangeParser.parse request.env["HTTP_RANGE"] || {}

  set_headers range

  Pagan::Zapps.get(range).to_json
end

def set_headers(range)
  headers["Content-Range"] = "#{range[:field]} #{range[:start]}..#{range[:finish]}"

  if range[:exclusive]
    headers["Next-Range"]  = "]#{range[:finish]}; max=#{range[:max]}, order=#{range[:order]}"
  else
    headers["Next-Range"]  = "#{range[:finish]}; max=#{range[:max]}, order=#{range[:order]}"
  end
end
