require "spec_helper"

describe "Activities - web app" do

  subject { get "/" }

  context "without data" do
    it         { should be_ok }
    its(:body) { should include("Activities") }
  end

  context "with data" do

    before do
      Eurucamp::Activities::Settings.stub!(:activities).and_return(
        [{
           "name"  => "Popijawa",
           "where" => "Bar",
           "when"  => "Today",
           "code"  => "Popijawa"
         }]
      )
    end

    it         { should be_ok }
    its(:body) { should include("Activities") }
    its(:body) { should include("Popijawa") }
  end

end