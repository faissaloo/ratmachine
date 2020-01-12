require "spec"

def usecase
  Usecase::CheckDigits.new
end

describe Usecase::CheckDigits do
  it "given no consecutive digits at the beginning of the number" do
    usecase.call(post_id: 25565).should eq({
      clear: false,
      checked: 1
    })
  end

  it "given dubs" do
    usecase.call(post_id: 399).should eq({
      clear: false,
      checked: 2
    })
  end

  it "given clear dubs" do
    usecase.call(post_id: 300).should eq({
      clear: true,
      checked: 2
    })
  end

  it "given trips" do
    usecase.call(post_id: 333).should eq({
      clear: false,
      checked: 3
    })
  end

  it "given clear trips" do
    usecase.call(post_id: 3000).should eq({
      clear: true,
      checked: 3
    })
  end
end
