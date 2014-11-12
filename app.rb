require "json"
require "pagan"
require "sequel"
require "sinatra"

DB = Sequel.connect("postgres://localhost/pagan")

get "/" do
  if request.env["HTTP_RANGE"]
    range = Pagan::RangeParser.parse request.env["HTTP_RANGE"]
  else
    range = {
      field: "id",
      max:   "200",
      order: "asc"
    }
  end

  results = Pagan::Zapps.get(range)

  set_headers range, results

  results.to_json
end

def set_headers(range, results)
  start  = results.first[range[:field].to_sym]
  finish = results.last[range[:field].to_sym]

  headers["Content-Range"] = "#{range[:field]} #{start}..#{finish}"

  if range[:exclusive]
    headers["Next-Range"]  = "]#{finish}; max=#{range[:max]}, order=#{range[:order]}"
  else
    headers["Next-Range"]  = "#{finish}; max=#{range[:max]}, order=#{range[:order]}"
  end
end
