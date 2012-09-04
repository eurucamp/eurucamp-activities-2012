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

  let(:t) { Time.zone.now }

  before do
    Twitter.stub_chain(:search, :results).and_return statuses
  end

  context "user is not participating in any activity" do

    let(:statuses) {
      [
          im_in("DRN", t + 1.minutes)
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

    before do
      activity.participations.create(:account => "yomakov")
    end

    let(:statuses) {
      [
        im_out("DRN", t + 1.minutes),
      ]
    }

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
          im_out("FTB", t - 10.minutes),
          im_in("DRN", t + 1.minutes),
          im_out("DRN", t + 3.minutes),
          im_out("DRN", t + 5.minutes),
          im_out("DRN", t),
          im_in("DRN", t + 4.minutes),
          im_out("DRN", t + 6.minutes),
          im_in("DRN", t + 2.minutes),
          im_in("FTB", t + 10.minutes)
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