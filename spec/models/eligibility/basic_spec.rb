require 'rails_helper'

RSpec.describe Eligibility::Basic, :type => :model do
  let(:account) { FactoryGirl.create(:account) }

  context 'answers storage' do
    it 'saves and reads answers' do
      eligibility = Eligibility::Basic.new(account: account)
      eligibility.kind = 'application'
      eligibility.based_in_uk = '1'

      expect { eligibility.save }.to change {
        Eligibility::Basic.count
      }.by(1)

      eligibility = Eligibility::Basic.last

      expect(eligibility.account).to eq(account)
      expect(eligibility.kind).to eq('application')
      expect(eligibility).to be_based_in_uk
    end
  end

  describe '#eligible?' do
    let(:eligibility) { Eligibility::Basic.new(account: account) }

    it 'is not eligible by default' do
      expect(eligibility).not_to be_eligible
    end

    it 'is eligible in the middle of the survey' do
      eligibility.current_step = :based_in_uk
      eligibility.kind = 'application'
      eligibility.organization_kind = 'charity'
      eligibility.based_in_uk = true

      expect(eligibility).to be_eligible
    end

    it 'is eligible when all questions are answered correctly' do
      eligibility.kind = 'application'
      eligibility.organization_kind = 'charity'
      eligibility.based_in_uk = true
      eligibility.self_contained_enterprise = true
      eligibility.has_management_and_two_employees = true

      expect(eligibility).to be_eligible
    end

    it 'is not eligible when not all answers are correct' do
      eligibility.kind = 'application'
      eligibility.organization_kind = 'charity'
      eligibility.based_in_uk = true
      eligibility.self_contained_enterprise = true
      eligibility.has_management_and_two_employees = false

      expect(eligibility).not_to be_eligible
    end
  end

  describe '#questions' do
    let(:eligibility) { Eligibility::Basic.new(account: account) }

    it 'returns all questions for new eligibility' do
      expect(eligibility.questions).to eq([:kind, :based_in_uk, :has_management_and_two_employees, :organization_kind, :industry, :self_contained_enterprise, :current_holder])
    end

    it 'returns only kind for nominations' do
      eligibility.kind = 'nomination'
      expect(eligibility.questions).to eq([:kind])
    end

    it 'does not return industry for charity' do
      eligibility.organization_kind = 'charity'
      expect(eligibility.questions).not_to include(:industry)
    end
  end
end
