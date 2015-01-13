class QAE2014Forms
  class << self
    def innovation_step6
      @innovation_step6 ||= Proc.new {
        head_of_business :head_of_business, 'Head of your organisation' do
          required
          ref 'F 1'
        end

        text :head_job_title, 'Job title / Role in the organisation' do
          classes "sub-question"
          required
          context %Q{
            <p>e.g. CEO, Managing Director, Founder, Head of your organisational unit</p>
          }
        end

        text :head_email, 'Email address' do
          classes "sub-question"
          required
        end

        # TODO Pull in info for A13
        confirm :confirmation_of_consent, 'Confirmation of consent' do
          ref 'F 2'
          required
          text '“I confirm that I have the consent of the head of my organisation (as entered in F1 above) to submit this entry form.'
        end

        confirm :entry_confirmation, 'Confirmation of entry' do
          ref 'F 3'
          required
          text %Q{
            By ticking this box, I certify that all the particulars given and those in any accompanying statements are correct to the best of my knowledge and belief and that no material information has been withheld. I undertake to notify The Queen’s Awards Office of any changes to the information I have provided in this entry form.
            <br>
            <br>
            I am not aware of any matter which might cast doubt upon the worthiness of this business unit to receive a Queen’s Award. I consent to all necessary enquiries being made by The Queen’s Awards Office in relation to this entry. This includes enquiries made of Government Departments and Agencies in discharging its responsibilities to vet any business unit which might be granted a Queen’s Award to ensure the highest standards of propriety. 
          }
        end


        submit "Submit application" do
          notice %Q{
            <p>If you have answered all the questions, you can submit your application now. You will be able to edit it any time before 23:59 on the last working day of September.</p>
            <p>
              If you are not ready to submit yet, you can save your application and come back later.
            </p>
          }
          style "large"
        end
      }
    end
  end
end