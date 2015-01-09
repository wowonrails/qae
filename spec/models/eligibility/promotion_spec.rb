require 'rails_helper'

RSpec.describe Eligibility::Promotion, :type => :model do
  let(:user) { FactoryGirl.create(:user) }

  context 'answers storage' do
    it 'saves and reads answers' do
      eligibility = Eligibility::Promotion.new(user: user)
      eligibility.nominee = 'someone_else'
      eligibility.nominee_contributes_to_promotion_of_business_enterprise = true
      eligibility.contribution_is_outside_requirements_of_activity = true
      eligibility.nominee_is_active = true
      eligibility.nominee_was_active_for_two_years = true
      eligibility.contributed_to_enterprise_promotion_within_uk = true
      eligibility.nominee_is_qae_ep_award_holder = false
      eligibility.nominee_was_put_forward_for_honours_this_year = false
      eligibility.able_to_get_two_letters_of_support = true

      expect { eligibility.save! }.to change {
        Eligibility::Promotion.count
      }.by(1)

      eligibility = Eligibility::Promotion.last

      expect(eligibility.user).to eq(user)
      expect(eligibility).to be_able_to_get_two_letters_of_support
    end
  end

  describe '#eligible?' do
    let(:eligibility) { Eligibility::Promotion.new(user: user) }

    it 'is not eligible by default' do
      expect(eligibility).not_to be_eligible
    end

    it 'is eligible when all questions are answered correctly' do
      eligibility.nominee = 'someone_else'
      eligibility.nominee_contributes_to_promotion_of_business_enterprise = true
      eligibility.contribution_is_outside_requirements_of_activity = true
      eligibility.nominee_is_active = true
      eligibility.nominee_was_active_for_two_years = true
      eligibility.contributed_to_enterprise_promotion_within_uk = true
      eligibility.nominee_is_qae_ep_award_holder = false
      eligibility.nominee_was_put_forward_for_honours_this_year = false
      eligibility.able_to_get_two_letters_of_support = true

      expect(eligibility).to be_eligible
    end

    it 'is not eligible when not all answers are correct' do
      eligibility.nominee = 'someone_else'
      eligibility.nominee_contributes_to_promotion_of_business_enterprise = true
      eligibility.contribution_is_outside_requirements_of_activity = true
      eligibility.nominee_is_active = true
      eligibility.nominee_was_active_for_two_years = true
      eligibility.contributed_to_enterprise_promotion_within_uk = false
      eligibility.nominee_is_qae_ep_award_holder = false
      eligibility.nominee_was_put_forward_for_honours_this_year = false
      eligibility.able_to_get_two_letters_of_support = true

      expect(eligibility).not_to be_eligible
    end
  end

  describe '#questions' do
    let(:eligibility) { Eligibility::Promotion.new(user: user) }

    it 'returns all questions for new eligibility' do
      expect(eligibility.questions).to eq([:nominee, :nominee_contributes_to_promotion_of_business_enterprise, :contribution_is_outside_requirements_of_activity, :nominee_is_active, :nominee_was_active_for_two_years, :contributed_to_enterprise_promotion_within_uk, :nominee_is_qae_ep_award_holder, :lifetime_achievement_award_nomination, :nominee_was_put_forward_for_honours_this_year, :nomination_for_honours_based_on_their_contribution_to_ep, :able_to_get_two_letters_of_support])
    end

    it 'does not return lifetime_achievement_award_nomination question if nominee is not QAE EP award holder' do
      eligibility.nominee_is_qae_ep_award_holder = false
      expect(eligibility.questions).not_to include(:lifetime_achievement_award_nomination)
    end

    it 'does not return nomination_for_honours_based_on_their_contribution_to_ep question if nominee was not forwarded for honours this year' do
      eligibility.nominee_was_put_forward_for_honours_this_year = false
      expect(eligibility.questions).not_to include(:nomination_for_honours_based_on_their_contribution_to_ep)
    end
  end
end