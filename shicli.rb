require 'bundler'
require 'json'
require 'pry'
require 'colorize'

Bundler.require

class Shicli

  def self.find(id,token=nil,email=nil)
    new(token, email).find(id)
  end

  def self.massive_request(number=1, token=nil,email=nil)
    new(token, email).massive_request(number)
  end

  def self.by_request(number=1, token=nil,email=nil)
    new(token, email).by_request(number)
  end

  def self.by_request_to_json(number=0)
    #reference: no puede ser mayor a 11 digitos
    object = {
      "packages": [
        {
          "reference": "test-api1",
          "full_name": "Matias doren",
          "email": "email@valido.com",
          "items_count": 1,
          "cellphone": "99999999",
          "is_payable": false,
          "packing": "Sin empaque",
          "shipping_type": "Normal",
          "destiny": "Domicilio",
          "approx_size": "Mediano (30x30x30cm)",
          "address_attributes": {
            "commune_id": 308,
            "street": "Hernán Díaz Arrieta",
            "number": "1231231",
            "complement": "Padre hurtado con bilbao"
          }
        }
      ]
    }

  end

  def self.massive_to_json(number=0)
    object = {
       "packages": [
       ]
    }

    number.to_i.times do |x|
      object[:packages] << {
        "reference": "xsn#{number}",
        "full_name": "xsn#{number}",
        "email": "emailvalido@gmail.com",
        "items_count": 1,
        "cellphone": "+99999999",
        "is_payable": "",
        "packing": "Sin empaque",
      "shipping_type": "Normal",
      "destiny": "Domicilio",
      "courier_for_client": "",
      "approx_size": "Mediano (30x30x30cm)",
      "length": "30",
      "width": "30",
      "height": "30",
      "weight": "1",
        "address_attributes": {
          "commune_id": 317,
          "street": "Av providencia",
          "number": "101",
          "complement": "oficina 10"
        }
      }
    end

    object
  end

  def initialize(token,email)
    @base = "http://api.shipit.cl/v"
    @headers = { 'Accept': 'application/vnd.shipit.v2', 'X-Shipit-Email': email, 'X-Shipit-Access-Token': token }
  end

  def find(id)
    response = RestClient.get("#{@base}/packages/#{id}", @headers)
    puts JSON.parse(response.body)
  end

  def massive_request(number)
    post(number)
  end

  def by_request(number)
    number.to_i.times { |x| post(x, true) }
  end

  def post(number, by_request=false)
    json = by_request ? Shicli.by_request_to_json(number) : Shicli.massive_to_json(number)
    response = RestClient.post("#{@base}/packages/mass_create", json, @headers)
    puts response.to_s
  end

end
