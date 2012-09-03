require "spec_helper"

describe Twitter::Status do

  context "parser" do
    subject { Twitter::Status.new(*args) }
    let(:default_args) { {:id => 1, :from_user => "xxx", :to_user => "eurucamplivetest"} }

    context "returns downcased code" do
      let(:args) { [default_args.merge(:text => "@eurucamplivetest   #iMout   #drN", :entities => {:hashtags => [{:text=>"iMout"}, {:text=>"drN"}]})] }
      its(:code) { should == "drn"  }
    end

    context "is not case-sensitive" do
      let(:args) { [default_args.merge(:text => "@eurucamplivetest   #iMout   #drN", :entities => {:hashtags => [{:text=>"iMout"}, {:text=>"drN"}]})] }

      its(:in?)  { should_not be     }
      its(:out?) { should     be     }
      its(:code) { should == "drn"  }
    end

    context "valid structure" do
      #context "'in' message" do
      #  pending
      #  let(:args) { [default_args.merge(:text => "@eurucamplivetest: #imin#DRN  ", :entities => {:hashtags => []})] }
      #
      #  its(:in?)  { should     be     }
      #  its(:out?) { should_not be     }
      #  its(:code) { should == "drn"  }
      #end

      context "'out' message" do
        let(:args) { [default_args.merge(:text => "@eurucamplivetest   #imout   #DRN", :entities => {:hashtags => [{:text=>"imout"}, {:text=>"DRN"}]})] }

        its(:in?)  { should_not be     }
        its(:out?) { should     be     }
        its(:code) { should == "drn"  }
      end

      context "other message" do
        let(:args) { [default_args.merge(:text => "@eurucamplivetest #nice #T-Shirt Alex!", :entities => {:hashtags => [{:text=>"nice"}, {:text=>"T-Shirt"}]})] }

        its(:in?)  { should_not be     }
        its(:out?) { should_not be     }
        its(:code) { should  == "nice" }
      end
    end

    context "invalid structure" do

      context "two tokens" do

        context "'in' token first" do
          let(:args) { [default_args.merge(:text => "@eurucamplivetest #imin #imout joker  ", :entities => {:hashtags => [{:text=>"imin"}, {:text=>"imout"}]})] }
          its(:in?)  { should     be     }
          its(:out?) { should     be     }
          its(:code) { should     be_nil }
        end

        context "'out' token first" do
          let(:args) { [default_args.merge(:text => "@eurucamplivetest, #imout #imin joker  ", :entities => {:hashtags => [{:text=>"imout"}, {:text=>"imin"}]})] }
          its(:in?)  { should     be     }
          its(:out?) { should     be     }
          its(:code) { should     be_nil }
        end

      end

      context "wrong order" do
        let(:args) { [default_args.merge(:text => "@eurucamplivetest hahha #imin #DRN", :entities => {:hashtags => [{:text=>"imin"}, {:text=>"DRN"}]})] }
        its(:in?)  { should     be }
        its(:out?) { should_not be }
        its(:code) { should ==  "drn" }
      end

    end
  end

  context "#<=>" do
    let(:default_left_args)  { {:id => 1, :from_user => "xxx", :to_user => "eurucamplivetest"} }
    let(:default_right_args) { {:id => 2, :from_user => "yyy", :to_user => "eurucamplivetest"} }

    let(:left)         { Twitter::Status.new(*left_args)  }
    let(:right)        { Twitter::Status.new(*right_args) }

    subject { left <=> right }

    context "the same tweet" do
      let(:left_args)  { [default_left_args] }
      let(:right_args) { [default_left_args] }

      it { should == 0 }
    end

    context "the same operation"  do

      context "different users" do

        context "different from_user" do

          context "no created_at" do
            let(:left_args)  { [default_left_args.merge(:text => "@eurucamplivetest   #imout   #DRN", :entities => {:hashtags => [{:text=>"imout"}, {:text=>"DRN"}]})] }
            let(:right_args) { [default_right_args.merge(:text => "@eurucamplivetest   #imout   #DRN", :entities => {:hashtags => [{:text=>"imout"}, {:text=>"DRN"}]})] }

            it { should_not be }
          end

          context "with created_at" do
            let(:left_args)  { [default_left_args.merge(:created_at => "2012/10/10 12:01", :text => "@eurucamplivetest   #imout   #DRN", :entities => {:hashtags => [{:text=>"imout"}, {:text=>"DRN"}]})] }
            let(:right_args) { [default_right_args.merge(:created_at => "2012/10/10 12:02", :text => "@eurucamplivetest   #imout   #DRN", :entities => {:hashtags => [{:text=>"imout"}, {:text=>"DRN"}]})] }

            it { should == -1 }
          end

        end

        context "different to_user" do

          context "no created_at" do
            let(:left_args)  { [default_left_args.merge(:from_user => "zzz", :to_user => "eurucamplivetest1", :text => "@eurucamplivetest1   #imout   #DRN", :entities => {:hashtags => [{:text=>"imout"}, {:text=>"DRN"}]})] }
            let(:right_args) { [default_right_args.merge(:from_user => "zzz", :to_user => "eurucamplivetest2", :text => "@eurucamplivetest2   #imout   #DRN", :entities => {:hashtags => [{:text=>"imout"}, {:text=>"DRN"}]})] }

            it { should_not be }
          end

          context "with created_at" do
            let(:left_args)  { [default_left_args.merge(:created_at => "2012/10/10 12:02", :text => "@eurucamplivetest   #imout   #DRN", :entities => {:hashtags => [{:text=>"imout"}, {:text=>"DRN"}]})] }
            let(:right_args) { [default_right_args.merge(:created_at => "2012/10/10 12:02", :text => "@eurucamplivetest   #imout   #DRN", :entities => {:hashtags => [{:text=>"imout"}, {:text=>"DRN"}]})] }

            it { should == 0 }
          end

        end

      end

      context "same users" do
        let(:left_args)  { [default_left_args.merge(:created_at => "2012/10/10 12:02", :text => "@eurucamplivetest   #imout   #DRN")] }
        let(:right_args) { [default_right_args.merge(:created_at => "2012/10/10 12:04", :from_user => "xxx", :text => "@eurucamplivetest   #imout   #DRN")] }

        it { should == 0 }
      end

    end

    context "different operations" do

      context "same users" do
        let(:left_args)  { [default_left_args.merge(:created_at => "2012/10/10 12:02",  :text => "@eurucamplivetest   #imin   #DRN")] }
        let(:right_args) { [default_right_args.merge(:created_at => "2012/10/10 12:04", :text => "@eurucamplivetest   #imout   #DRN")] }

        it { should == -1 }
      end

    end

  end

end