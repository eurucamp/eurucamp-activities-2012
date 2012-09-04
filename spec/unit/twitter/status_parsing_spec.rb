require "spec_helper"

describe "Twitter::Status - parsing" do

  subject { object_under_test }

  let(:object_under_test) { Twitter::Status.new(*args) }
  let(:default_args) { {:id => 1, :from_user => "xxx", :to_user => "eurucamplivetest"} }

  context "valid structure" do

    let(:args) { [default_args.merge(:text => "@eurucamplivetest   #iMout   #drN", :entities => {:hashtags => [{:text=>"iMout"}, {:text=>"drN"}]})] }

    its(:in?)  { should_not be     }
    its(:out?) { should     be     }
    its(:code) { should == "drn"   }

    context "'in' message" do
      let(:args) { [default_args.merge(:text => "@eurucamplivetest: #imin #DRN  ", :entities => {:hashtags => [{:text => "imin"}, {:text => "DRN"}]})] }

      its(:in?)  { should     be     }
      its(:out?) { should_not be     }
      its(:code) { should == "drn"   }
    end

    context "'out' message" do
      let(:args) { [default_args.merge(:text => "@eurucamplivetest   #imout   #DRN", :entities => {:hashtags => [{:text=>"imout"}, {:text=>"DRN"}]})] }

      its(:in?)  { should_not be     }
      its(:out?) { should     be     }
      its(:code) { should == "drn"   }
    end

    context "other message" do
      let(:args) { [default_args.merge(:text => "@eurucamplivetest #nice #T-Shirt Alex!", :entities => {:hashtags => [{:text=>"nice"}, {:text=>"T-Shirt"}]})] }

      its(:in?)  { should_not be       }
      its(:out?) { should_not be       }
      it {         should_not be_valid }
      its(:code) { should  == "nice"   }
    end

    context "wrong order" do
      let(:args) { [default_args.merge(:text => "@eurucamplivetest hahha #imin #DRN", :entities => {:hashtags => [{:text=>"imin"}, {:text=>"DRN"}]})] }
      its(:in?)  { should     be }
      its(:out?) { should_not be }
      its(:code) { should ==  "drn" }
    end

    context "two codes" do
      let(:args) { [default_args.merge(:text => "@eurucamplivetest #xxx #imin #drn joker  ", :entities => {:hashtags => [{:text=>"imin"}, {:text=>"xxx"}, {:text => "drn"}]})] }
      its(:in?)  { should     be     }
      its(:out?) { should_not be     }
      it {         should     be_valid }
      its(:code) { should ==  "xxx" }
    end

  end

  context "invalid structure" do

    context "two tokens" do

      context "no code" do
        let(:args) { [default_args.merge(:text => "@eurucamplivetest #imin #imout joker  ", :entities => {:hashtags => [{:text=>"imin"}, {:text=>"imout"}]})] }
        its(:in?)  { should     be     }
        its(:out?) { should     be     }
        it {         should_not be_valid }
        its(:code) { should     be_nil }
      end

      context "with code" do
        let(:args) { [default_args.merge(:text => "@eurucamplivetest #imin #imout joker #DRN ", :entities => {:hashtags => [{:text=>"imin"}, {:text=>"imout"}, {:text => "DRN"}]})] }
        its(:in?)  { should     be     }
        its(:out?) { should     be     }
        it {         should_not be_valid }
        its(:code) { should  == "drn" }
      end

    end

  end

end