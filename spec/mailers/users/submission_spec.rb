require "spec_helper"

describe Users::SubmissionMailer do
  let!(:user) { create :user }
  let(:form_answer) do 
    FactoryGirl.create :form_answer, :submitted, :innovation, 
                                                 user: user,
                                                 document: { company_name: "Bitzesty" }
                                     
  end
  let(:urn) { form_answer.urn }
  let(:subject) { "submission successfully created!" }

  before do
    FormAnswer.any_instance.stub(:eligible?) { true }
    form_answer
  end

  describe "Email Me" do
    let(:mail) { Users::SubmissionMailer.success(user.id, form_answer.id) }

    it "renders the headers" do
      expect(mail.subject).to eq("[Queen's Awards for Enterprise] #{subject}")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["support@qae.co.uk"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(user.decorate.full_name)
      expect(mail.body.encoded).to match(user.decorate.general_info)
      expect(mail.body.encoded).to match(form_answer.decorate.award_application_title)
      expect(mail.body.encoded).to match(urn)
    end
  end
end