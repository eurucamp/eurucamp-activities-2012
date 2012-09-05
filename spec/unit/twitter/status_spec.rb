require "spec_helper"

describe Twitter::Status do

  let(:default_out_text)   { text_with_entities("@eurucamplivetest   #imout   #DRN")         }
  let(:default_in_text)    { text_with_entities("@eurucamplivetest   #imin   #DRN")          }

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
            let(:left_args)  { [merge_args(default_left_args,  default_out_text)] }
            let(:right_args) { [merge_args(default_right_args, default_out_text)] }

            it { should be_false }
          end

          context "with created_at" do
            let(:left_args)  { [merge_args(default_left_args,  default_out_text, :created_at => "2012/10/10 12:01")] }
            let(:right_args) { [merge_args(default_right_args, default_out_text, :created_at => "2012/10/10 12:02")] }

            it { should == -1 }
          end

        end

        context "different to_user" do

          context "no created_at" do
            let(:left_args)  { [merge_args(default_left_args , text_with_entities("@eurucamplivetest1   #imout   #DRN"), :from_user => "zzz", :to_user => "eurucamplivetest1")] }
            let(:right_args) { [merge_args(default_right_args, text_with_entities("@eurucamplivetest2   #imout   #DRN"), :from_user => "zzz", :to_user => "eurucamplivetest2")] }

            it { should be_false }
          end

          context "with created_at" do
            let(:left_args)  { [merge_args(default_left_args,  default_out_text, :created_at => "2012/10/10 12:02")] }
            let(:right_args) { [merge_args(default_right_args, default_out_text, :created_at => "2012/10/10 12:02")] }

            it { should == 0 }
          end

        end

      end

      context "same users" do
        let(:left_args)  { [merge_args(default_left_args,  default_out_text, :created_at => "2012/10/10 12:02")]                      }
        let(:right_args) { [merge_args(default_right_args, default_out_text, :created_at => "2012/10/10 12:04", :from_user => "xxx")] }

        it { should == 0 }
      end

    end

    context "different operations" do

      context "same users" do
        let(:left_args)  { [merge_args(default_left_args,  default_in_text,  :created_at => "2012/10/10 12:02")] }
        let(:right_args) { [merge_args(default_right_args, default_out_text, :created_at => "2012/10/10 12:04")] }

        it { should == -1 }
      end

    end

  end

  describe "#eql?" do
    subject { left.eql?(right) }

    context "same attributes" do
      let(:left_args)  { [merge_args(default_left_args,  default_in_text)]                      }
      let(:right_args) { [merge_args(default_right_args, default_in_text, :from_user => "xxx")] }

      it { should be_true }
    end

    context "different attributes" do
      it { should be_false }
    end

  end

  describe "#hash" do
    subject { left.hash }

    context "same attributes" do
      let(:left_args)  { [merge_args(default_left_args,  default_in_text)]                      }
      let(:right_args) { [merge_args(default_right_args, default_in_text, :from_user => "xxx")] }

      it { should == right.hash }
    end

    context "different attributes" do
      it { should_not == right.hash }
    end

  end

  describe "#valid?" do
    let(:subject) { left.valid? }

    context "invalid attributes" do
      let(:left_args) { [merge_args(default_left_args, text_with_entities("@eurucamplivetest hahha #imin #imout #DRN"))] }

      it { should be_false }
    end

    context "valid attributes" do
      let(:left_args) { [merge_args(default_left_args, text_with_entities("@eurucamplivetest hahha #imin #DRN"))] }

      it { should be_true }
    end

  end

  describe "#code" do
    let(:subject) { left.code }

    context "no hashtags" do
      it { should be_nil }
    end

    context "hashtags contain only action tokens" do
      let(:left_args) { [merge_args(default_left_args, text_with_entities("@eurucamplivetest hahha #imin #imout"))] }

      it { should be_nil }
    end

    context "hashtags contain not only action tokens" do
      let(:left_args) { [merge_args(default_left_args, text_with_entities("@eurucamplivetest hahha #imin #DRN #OY "))] }

      it { should == "drn" }
    end

  end

end