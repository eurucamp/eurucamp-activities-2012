# encoding: UTF-8

require 'spec_helper'

describe FetchStatusesJob do

  subject { FetchStatusesJob.new.run! }

  let!(:activity) {
    Activity.create(
      :code => "DRN",
      :when => Time.now,
      :where => "Bar",
      :name => "Beer",
      :published => true
    )
  }

  let!(:other_activity) {
    Activity.create(
      :code => "FTB",
      :when => Time.now,
      :where => "stadium",
      :name => "Football game",
      :published => true
    )
  }

  before do
    Twitter.stub_chain(:search, :results).and_return(statuses)
  end

  context "user is not participating in any activity" do

    let(:statuses) {
      [
        im_in("DRN", 1.minutes.ago)
      ]
    }

    specify do
      expect do
        subject
      end.to change(activity.participations, :count).to(1)
    end

    specify do
      expect do
        subject
      end.to_not change(other_activity.participations, :count)
    end

  end

  context "user is participating in some activity" do

    let(:statuses) {
      [
        im_out("DRN", 1.minutes.ago),
      ]
    }

    before do
      activity.participations.create(:account => "yomakov")
    end

    specify do
      expect do
        subject
      end.to change(activity.participations, :count).to(0)
    end

    specify do
      expect do
        subject
      end.to_not change(other_activity.participations, :count)
    end

  end

  context "user sends many messages" do

    let(:statuses) {
      [
        im_out("FTB", 10.minutes.ago),
        im_in( "DRN",  1.minutes.ago),
        im_out("DRN",  3.minutes.ago),
        im_out("DRN",  5.minutes.ago),
        im_out("DRN",  1.seconds.ago),
        im_in( "DRN",  4.minutes.ago),
        im_out("DRN",  6.minutes.ago),
        im_in( "DRN",  2.minutes.ago),
        im_in( "FTB",  9.minutes.ago)
      ]
    }

    specify do
      expect do
        subject
      end.to_not change(activity.participations, :count)
    end

    specify do
      expect do
        subject
      end.to change(other_activity.participations, :count).to(1)
    end

    specify do
      subject
      other_activity.participations.map(&:account).should =~ %w(yomakov)
    end

  end


end