class Users::BuckinghamPalaceInviteMailer < ApplicationMailer
  def invite(invite_id)
    invite = PalaceInvite.find(invite_id)
    @token = invite.token
    @form_answer = invite.form_answer.decorate
    account_holder = @form_answer.user

    @name = "#{account_holder.title} #{account_holder.last_name}"

    @deadline = Settings.current.deadlines.where(kind: "buckingham_palace_attendees_details").first
    @deadline = @deadline.trigger_at
    @media_deadline = Settings.current.deadlines.where(kind: "buckingham_palace_media_information").first
    @media_deadline = @media_deadline.try :strftime, "%H.%M on %A %d %B %Y"
    @book_notes_deadline = Settings.current.deadlines.where(kind: "buckingham_palace_confirm_press_book_notes").first
    @book_notes_deadline = @book_notes_deadline.try :strftime, "%l %p on %A %d %B"
    @attendees_invite_date = Settings.current.deadlines.where(kind: "buckingham_palace_attendees_invite").first
    @attendees_invite_date = @attendees_invite_date.try :strftime, "%A %d %B %Y"

    subject = "Important information about your Queen’s Award"
    mail to: invite.email, subject: subject
  end
end
