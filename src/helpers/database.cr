require "micrate"

def database_name
  URI.parse(Amber.settings.database_url.to_s).path.gsub("/", "")
end

def database_url
  Amber.settings.database_url.to_s
end

def maintainence_database_url
  url = Amber.settings.database_url.to_s
  uri = URI.parse(url)
  url.gsub(/#{uri.path}$/, "/#{uri.scheme}")
end

def initialize_database
  Amber.settings.logger.info "Preparing database..."
  Micrate::DB.connection_url = maintainence_database_url
  begin
    Micrate::DB.connect do |db|
      db.exec "CREATE DATABASE #{database_name};"
    end
    Amber.settings.logger.info "Database created"
  rescue PQ::PQError
    Amber.settings.logger.info "Database exists"
  end
  Amber.settings.logger.info "Checking migrations..."
  Micrate::DB.connection_url = database_url
  Micrate::Cli.run_up
  Amber.settings.logger.info "Migrations run"
end
