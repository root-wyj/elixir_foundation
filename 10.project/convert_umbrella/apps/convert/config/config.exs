use Mix.Config

config :arc, 
    storage: Arc.Storage.Local

import_config "#{Mix.env()}.exs"
