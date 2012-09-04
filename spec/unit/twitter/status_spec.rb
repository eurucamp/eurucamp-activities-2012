require "spec_helper"

describe Twitter::Status do

  let(:default_left_args)  { {:id => 1, :from_user => "xxx", :to_user => "eurucamplivetest"} }
  let(:default_right_args) { {:id => 2, :from_user => "yyy", :to_user => "eurucamplivetest"} }
  let(:left_args)          { [default_left_args]                                             }
  let(:right_args)         { [default_right_args]                                            }


  let(:left)               { Twitter::Status.new(*left_args)                                 }
  let(:right)              { Twitter::Status.new(*right_args)                                }

  describe "#<=>" do
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

  describe "#eql?" do
    subject { left.eql?(right) }

    context "same attributes" do
      let(:left_args)  { [default_left_args.merge(:text => "@eurucamplivetest   #imin   #DRN")]}
      let(:right_args) { [default_right_args.merge(:from_user => "xxx", :text => "@eurucamplivetest   #imin   #DRN")] }
      it { should be_true }
    end

    context "different attributes" do
      it { should be_false }
    end

  end

  describe "#hash" do
    subject { left.hash }

    context "same attributes" do
      let(:left_args)  { [default_left_args.merge(:text => "@eurucamplivetest   #imin   #DRN")]}
      let(:right_args) { [default_right_args.merge(:from_user => "xxx", :text => "@eurucamplivetest   #imin   #DRN")] }

      it { should == right.hash }
    end

    context "different attributes" do
      it { should_not == right.hash }
    end

  end

  describe "#valid?" do
    let(:subject)    { left.valid? }

    context "invalid attributes" do
      let(:left_args) { [default_left_args.merge(:text => "@eurucamplivetest hahha #imin #imout #DRN", :entities => {:hashtags => [{:text=>"imin"}, {:text => "imout"}, {:text=>"DRN"}]})] }

      it { should be_false }
    end

    context "valid attributes" do
      let(:left_args) { [default_left_args.merge(:text => "@eurucamplivetest hahha #imin #DRN", :entities => {:hashtags => [{:text=>"imin"}, {:text=>"DRN"}]})] }

      it { should be_true }
    end

  end

  describe "#code" do
    let(:subject)    { left.code }

    context "no hashtags" do
      it { should be_nil }
    end

    context "hashtags contain only action tokens" do
      let(:left_args) { [default_left_args.merge(:text => "@eurucamplivetest hahha #imin #imout", :entities => {:hashtags => [{:text=>"imin"}, {:text=>"imout"}]})] }
      it { should be_nil }
    end

    context "hashtags contain not only action tokens" do
      let(:left_args) { [default_left_args.merge(:text => "@eurucamplivetest hahha #imin #DRN #OY ", :entities => {:hashtags => [{:text=>"imin"}, {:text=>"DRN"}]})] }

      it { should == "drn" }
    end

  end

end