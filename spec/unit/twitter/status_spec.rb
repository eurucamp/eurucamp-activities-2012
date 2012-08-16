require "spec_helper"

describe Twitter::Status do
  subject { Twitter::Status.new(*args) }
  let(:default_args) { {:id => 1, :from_user => "xxx", :to_user => "eurucamplivetest"} }

  context "valid structure" do
    context "'in' message" do
      let(:args) { [default_args.merge(:text => "@eurucamplivetest: #imin#DRN  ")] }

      its(:in?)  { should     be     }
      its(:out?) { should_not be     }
      its(:code) { should == "#DRN"  }
    end

    context "'out' message" do
      let(:args) { [default_args.merge(:text => "@eurucamplivetest   #imout   #DRN")] }

      its(:in?)  { should_not be     }
      its(:out?) { should     be     }
      its(:code) { should == "#DRN"  }
    end

    context "other message" do
      let(:args) { [default_args.merge(:text => "@eurucamplivetest #nice #T-Shirt Alex!")] }

      its(:in?)  { should_not be     }
      its(:out?) { should_not be     }
      its(:code) { should     be_nil }
    end
  end

  context "invalid structure" do

    context "'in' token first" do
      let(:args) { [default_args.merge(:text => "@eurucamplivetest #imin #imout joker  ")] }
      its(:in?)  { should     be     }
      its(:out?) { should_not be     }
      its(:code) { should == "#imout joker" }
    end

    context "'out' token first" do
      let(:args) { [default_args.merge(:text => "@eurucamplivetest, #imout #imin joker  ")] }
      its(:in?)  { should_not be     }
      its(:out?) { should     be     }
      its(:code) { should == "#imin joker" }
    end

  end
end