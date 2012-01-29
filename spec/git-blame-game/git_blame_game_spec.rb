require 'spec_helper'

describe GitBlameGame do

  let(:git_blame_game) { GitBlameGame.new('some_file') }
  let(:sha_list) { %w(de2a1d78 5087eab5 5087eab5 de2a1d78 de2a1d78) }

  before do
    $stdout.stub(:print)
  end

  describe "#get_sha_list" do
    let(:git_blame_out) {
      <<-END.gsub(/^[ \t]+/m, '')
        de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 1) module Add
        5087eab5 (Danny Dover     2012-01-14 14:50:06 -0800 2)   def add_4(y)
        5087eab5 (Danny Dover     2012-01-14 14:50:06 -0800 3)     y + 5
        de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 4)   end
        de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 5) end
      END
    }

    it "should return a list of shas" do
      git_blame_game.get_sha_list(git_blame_out).should == sha_list
    end
  end

  describe "prompt_for_sha" do
    before do
      $stdin.should_receive(:gets).and_return(input)
    end
    context "when user enters a correct sha" do
      let(:input) { '5087eab5' }
      it "should return the correct sha" do
        git_blame_game.prompt_for_sha(sha_list).should == '5087eab5'
      end
    end
    context "when user enters a correct number" do
      let(:input) { '1' }
      it "should return the correct sha" do
        git_blame_game.prompt_for_sha(sha_list).should == 'de2a1d78'
      end
    end
    context "when user enters an incorrect value"
  end

end