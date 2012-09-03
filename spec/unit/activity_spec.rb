require "spec_helper"

describe Activity do

  let(:default_args) { [{:code => "Xx", :name => "X event", :where => "X room", :when => Time.now}] }
  subject { Activity.new(*args) }

  context "with valid attributes" do
    let(:args) { default_args }

    before do
      subject.save
    end

    it { should be_valid }
    its(:code) { should == "xx" }

    it "validates uniqueness of normalized code" do
      subject.clone.save.should == false
    end

  end

end