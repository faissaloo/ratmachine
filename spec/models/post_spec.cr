require "./spec_helper"
require "../../src/models/post.cr"

describe Post do
  Spec.before_each do
    Post.clear
  end
end
