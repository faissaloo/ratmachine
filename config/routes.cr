Amber::Server.configure do
  pipeline :web do
    # Plug is the method to use connect a pipe (middleware)
    # A plug accepts an instance of HTTP::Handler
    plug Amber::Pipe::PoweredByAmber.new
    # plug Amber::Pipe::ClientIp.new(["X-Forwarded-For"])
    plug Citrine::I18n::Handler.new
    #plug Amber::Pipe::Error.new
    plug Amber::Pipe::Logger.new
    plug Amber::Pipe::Session.new
    plug Amber::Pipe::Flash.new
    plug Amber::Pipe::CSRF.new
  end

  pipeline :api do
    plug Amber::Pipe::PoweredByAmber.new
    #plug Amber::Pipe::Error.new
    plug Amber::Pipe::Logger.new
    plug Amber::Pipe::Session.new
    plug Amber::Pipe::CORS.new
  end

  # All static content will run these transformations
  pipeline :static do
    plug Amber::Pipe::PoweredByAmber.new
    #plug Amber::Pipe::Error.new
    plug Amber::Pipe::Static.new("./public")
  end

  routes :static do
    get "/robots.txt", Amber::Controller::Static, :index
    get "/favicon.ico", Amber::Controller::Static, :index
    get "/favicon.png", Amber::Controller::Static, :index
  end

  routes :web do
    delete "/post/delete", PostController, :delete
    delete "/filter/delete", FilterController, :delete
    get "/mod/login", ModController, :login_page
    post "/mod/authenticate", ModController, :authenticate
    get "/mod/:id", ModController, :mod
    get "/mod", ModController, :mod

    post "/post/create/:id", PostController, :create
    post "/filter/create", FilterController, :create
    post "/post/create", PostController, :create
    get "/:id", IndexController, :index
    get "/", IndexController, :index
  end

  routes :static do
    get "/*", Amber::Controller::Static, :index
  end

  routes :api do
  end
end
