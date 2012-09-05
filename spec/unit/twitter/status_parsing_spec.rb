require "spec_helper"

describe "Twitter::Status - parsing" do

  subject { object_under_test }

  let(:object_under_test) { Twitter::Status.new(*args) }
  let(:default_args) { {:id => 1, :from_user => "xxx", :to_user => "eurucamplivetest"} }

  context "valid structure" do

    let(:args)   { [merge_args(default_args, text_with_entities("@eurucamplivetest   #iMout   #drN"))] }

    its(:in?)    { should     be_false  }
    its(:out?)   { should     be_true   }
    its(:code)   { should     == "drn"  }

    context "'in' message" do
      let(:args) { [merge_args(default_args, text_with_entities("@eurucamplivetest: #imin #DRN  "))] }

      its(:in?)  { should     be_true   }
      its(:out?) { should     be_false  }
      its(:code) { should     == "drn"  }
    end

    context "'out' message" do
      let(:args) { [merge_args(default_args, text_with_entities("@eurucamplivetest   #imout   #DRN"))] }

      its(:in?)  { should     be_false  }
      its(:out?) { should     be_true   }
      its(:code) { should     == "drn"  }
    end

    context "other message" do
      let(:args) { [merge_args(default_args, text_with_entities("@eurucamplivetest #nice #T-Shirt Alex!"))] }

      its(:in?)  { should     be_false  }
      its(:out?) { should     be_false  }
      it         { should_not be_valid  }
      its(:code) { should     == "nice" }
    end

    context "wrong order" do
      let(:args) { [merge_args(default_args, text_with_entities("@eurucamplivetest hahha #imin #DRN"))] }

      its(:in?)  { should     be_true   }
      its(:out?) { should     be_false  }
      its(:code) { should     == "drn"  }
    end

    context "two codes" do
      let(:args) { [merge_args(default_args, text_with_entities("@eurucamplivetest #xxx #imin #drn joker  "))] }
      its(:in?)  { should     be_true   }
      its(:out?) { should     be_false  }
      it         { should     be_valid  }
      its(:code) { should     ==  "xxx" }
    end

  end

  context "invalid structure" do

    context "two tokens" do

      context "no code" do
        let(:args) { [merge_args(default_args, text_with_entities("@eurucamplivetest #imin #imout joker  "))] }
        its(:in?)  { should     be_true  }
        its(:out?) { should     be_true  }
        it         { should_not be_valid }
        its(:code) { should     be_nil   }
      end

      context "with code" do
        let(:args) { [merge_args(default_args, text_with_entities("@eurucamplivetest #imin #imout joker #DRN "))] }
        its(:in?)  { should     be_true  }
        its(:out?) { should     be_true  }
        it         { should_not be_valid }
        its(:code) { should     == "drn" }
      end

    end

  end

end