#https://github.com/faissaloo/ratmachine/issues/2
struct Crystal::ThreadLocalValue(T)
  def get(&block : -> T)
    th = Thread.current
    if !@values[th]?
      @values[th] = yield
    else
      @values[th]
    end
  end
end

require "amber"
require "./settings"
require "./initializers/**"

require "../src/core/**"
require "../src/core/usecase/**"
require "../src/models/**"

require "../src/controllers/application_controller"
require "../src/controllers/**"
