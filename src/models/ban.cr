class Ban < Granite::Base
  connection pg
  table bans

  column id : Int64, primary: true
  column ip_address : String?
  timestamps
end
