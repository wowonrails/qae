require "qae_2014_forms/international_trade/international_trade_step1"
require "qae_2014_forms/international_trade/international_trade_step2"
require "qae_2014_forms/international_trade/international_trade_step3"
require "qae_2014_forms/international_trade/international_trade_step4"
require "qae_2014_forms/international_trade/international_trade_step5"
require "qae_2014_forms/international_trade/international_trade_step6"

class QAE2014Forms
  class << self
    def trade
      @trade ||= QAEFormBuilder.build "International Trade Award Application" do
        step "Company Information",
             "Company Information",
             &QAE2014Forms.trade_step1

        step "Your International Trade",
             "Your International Trade",
             &QAE2014Forms.trade_step2

        step "Commercial Performance",
             "Commercial Performance",
             &QAE2014Forms.trade_step3

        step "Declaration of Corporate Responsibility",
             "Declaration of Corporate Responsibility",
             &QAE2014Forms.trade_step4

        step "Add Website Address/Documents",
             "Add Website Address/Documents",
             { id: :add_website_address_documents_step },
             &QAE2014Forms.trade_step5

        step "Authorise & Submit",
             "Authorise & Submit",
             &QAE2014Forms.trade_step6
      end
    end
  end
end
