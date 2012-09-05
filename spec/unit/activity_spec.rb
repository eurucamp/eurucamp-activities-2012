require "spec_helper"

describe Activity do

  let(:args) { [{:code => "Xx", :name => "X event", :where => "X room", :when => Time.now}] }
  subject    { Activity.new(*args)                                                          }

  context "with valid attributes" do

    before do
      subject.save
    end

    it         { should be_valid }
    its(:code) { should == "xx"  }

    it "validates uniqueness of normalized code" do
      subject.clone.save.should == false
    end

  end

end