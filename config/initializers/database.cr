require "granite/adapter/pg"

Granite::Connections << Granite::Adapter::Pg.new(name: "pg", url: Amber.settings.database_url)
Granite.settings.logger = Amber.settings.logger.dup
Granite.settings.logger.progname = "Granite"
