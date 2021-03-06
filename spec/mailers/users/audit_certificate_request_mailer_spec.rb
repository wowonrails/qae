require "rails_helper"

describe Users::AuditCertificateRequestMailer do
  let!(:user) { create :user }
  let(:form_answer) do
    create :form_answer, :submitted, :innovation, user: user
  end

  let!(:deadline) do
    deadline = Settings.current.deadlines.where(kind: "audit_certificates").first
    deadline.update(trigger_at: Date.current)
    deadline.trigger_at.strftime("%d/%m/%Y")
  end

  let(:award_title) { form_answer.decorate.award_application_title }
  let(:subject) {
    "Queen's Awards for Enterprise: Reminder to submit your Verification of Commercial Figures"
  }

  before do
    form_answer
  end

  describe "#notify" do
    let(:mail) { Users::AuditCertificateRequestMailer.notify(user.id, form_answer.id) }

    it "renders the headers" do
      expect(mail.subject).to eq(subject)
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["no-reply@queens-awards-enterprise.service.gov.uk"])
    end

    it "renders the body" do
      expect(mail.html_part.decoded).to match(user.decorate.full_name)
      expect(mail.html_part.decoded).to have_link("upload your completed Verification of Commercial Figures here.",
                                                  href: users_form_answer_audit_certificate_url(form_answer))
      expect(mail.html_part.decoded).to have_link("download a blank copy of the Verification of Commercial Figures here.",
                                                  href: users_form_answer_audit_certificate_url(form_answer, format: :pdf))
      expect(mail.html_part.decoded).to match(deadline)
    end
  end
end
