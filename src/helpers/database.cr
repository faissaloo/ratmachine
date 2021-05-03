require "micrate"
require "log"

def database_name
  URI.parse(Amber.settings.database_url.to_s).path.gsub("/", "")
end

def database_url
  Amber.settings.database_url.to_s
end

def maintainence_database_url
  #This needs to be fixed so it uses different creds for the database we create vs the database we use
  url = Amber.settings.database_url.to_s
  uri = URI.parse(url)
  url.gsub(/#{uri.path}$/, "/#{uri.scheme}")
end

def initialize_database
  Log.info { "Preparing database..." }
  Micrate::DB.connection_url = maintainence_database_url
  begin
    Micrate::DB.connect do |db|
      db.exec "CREATE DATABASE #{database_name};"
    end
    Log.info { "Database created" }
  rescue PQ::PQError
    Log.info { "Database exists" }
  end
  Log.info { "Checking migrations..." }
  Micrate::DB.connection_url = database_url
  Micrate::Cli.run_up
  Log.info { "Migrations run" }
end
