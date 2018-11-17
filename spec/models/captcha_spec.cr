require "./spec_helper"
require "../../src/models/captcha.cr"

describe Captcha do
  Spec.before_each do
    Captcha.clear
  end
end
