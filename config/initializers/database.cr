require "granite/adapter/pg"

Granite::Adapters << Granite::Adapter::Pg.new({name: "pg", url: Amber.settings.database_url})
Granite.settings.logger = Amber.settings.logger.dup
Granite.settings.logger.progname = "Granite"

