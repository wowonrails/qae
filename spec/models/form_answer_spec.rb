require "rails_helper"

RSpec.describe FormAnswer, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "validations" do
    %w(user).each do |field_name|
      it { should validate_presence_of field_name }
    end

    it "award_type" do
      should validate_inclusion_of(:award_type)
        .in_array(FormAnswer::POSSIBLE_AWARDS)
    end
  end

  it "sets account on creating" do
    form_answer = FactoryGirl.create(:form_answer)
    expect(form_answer.account).to eq(form_answer.user.account)
  end

  context "URN" do
    before do
      %w(urn_seq_trade urn_seq_innovation urn_seq_development urn_seq_promotion).each do |seq|
        FormAnswer.connection.execute("ALTER SEQUENCE #{seq} RESTART")
      end

      allow_any_instance_of(FormAnswer).to receive(:eligible?) { true }
    end
    let!(:form_answer) { FactoryGirl.create(:form_answer, submitted: true) }
    let(:award_year) { (Date.today.year + 1).to_s[2..-1] }

    it "creates form with URN" do
      expect(form_answer.urn).to eq("QA0001/#{award_year}T")
    end

    it "increments URN" do
      other_form_answer = FactoryGirl.create(:form_answer, submitted: true)
      expect(other_form_answer.urn).to eq("QA0002/#{award_year}T")
    end
  end

  describe "#company_or_nominee_from_document" do
    subject { build(:form_answer, kind, document: doc) }
    let(:c_name) { "company name" }

    context "promotion form" do
      let(:doc) { { "organization_name" => " #{c_name} " } }
      let(:kind) { :promotion }
      it "gets the orgzanization name first" do
        expect(subject.company_or_nominee_from_document).to eq(c_name)
      end

      context "organization name blank" do
        let(:doc) { { "nominee_info_first_name" => c_name } }
        it "gets the nominee name" do
          expect(subject.company_or_nominee_from_document).to eq(c_name)
        end
      end
    end

    context "innovation form" do
      let(:doc) { { "company_name" => c_name } }
      let(:kind) { :innovation }
      it "gets the company name" do
        expect(subject.company_or_nominee_from_document).to eq(c_name)
      end
    end
  end

  describe "#fill_progress_in_percents" do
    it "returns fill progress as formatted string" do
      form_answer = build(:form_answer, fill_progress: 0.11)
      expect(form_answer.fill_progress_in_percents).to eq("11%")
    end
  end
end
