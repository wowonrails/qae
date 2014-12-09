class AwardEligibilitiesController < ApplicationController
  include Wicked::Wizard

  before_action :authenticate_user!
  before_action :load_eligibilities

  steps :trade, :innovation, :development

  def show
    if all_eligibilities_passed?
      render :result
      return
    end

    unless step
      redirect_to wizard_path(:trade)
      return
    end
  end

  def update
    eligibility = case step
    when :trade
      @trade_eligibility
    when :innovation
      @innovation_eligibility
    when :development
      @development_eligibility
    end

    if eligibility.update(send("#{step}_eligibility_params"))
      if step == :development
        redirect_to action: :result
      else
        redirect_to next_wizard_path
      end
    else
      render :show
    end
  end

  def result
  end

  private

  def trade_eligibility_params
    params.require(:eligibility).permit(*Eligibility::Trade.questions)
  end

  def innovation_eligibility_params
    params.require(:eligibility).permit(*Eligibility::Innovation.questions)
  end

  def development_eligibility_params
    params.require(:eligibility).permit(*Eligibility::Development.questions)
  end

  def all_eligibilities_passed?
    [@trade_eligibility, @innovation_eligibility, @development_eligibility].all?(&:passed?)
  end
  helper_method :all_eligibilities_passed?
end