require "json"
require "pagan"
require "sequel"
require "sinatra"

DB = Sequel.connect("postgres://localhost/pagan")

get "/" do
  if request.env["HTTP_RANGE"]
    range = Pagan::RangeParser.parse request.env["HTTP_RANGE"]
  else
    range = {}
  end

  set_headers range

  Pagan::Zapps.get(range).to_json
end

# TODO horribly broken
def set_headers(range)
  headers["Content-Range"] = "#{range[:field]} #{range[:start]}..#{range[:finish]}"

  if range[:exclusive]
    headers["Next-Range"]  = "]#{range[:finish]}; max=#{range[:max]}, order=#{range[:order]}"
  else
    headers["Next-Range"]  = "#{range[:finish]}; max=#{range[:max]}, order=#{range[:order]}"
  end
end
