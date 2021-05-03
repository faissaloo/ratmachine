require "granite/adapter/pg"

Granite::Connections << Granite::Adapter::Pg.new(name: "pg", url: Amber.settings.database_url)
#Granite.settings.logging = Amber.settings.logging.not_nil!.dup
#Granite.settings.logging.not_nil!.progname = "Granite"
