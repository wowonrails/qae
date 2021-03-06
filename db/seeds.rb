unless Admin.exists?
  admin_args = {
    email: "admin@example.com",
    password: "^#ur9EkLm@1W",
    first_name: "First name",
    last_name: "Last name",
    confirmed_at: DateTime.now
  }

  Admin.create!(admin_args)
end

unless Assessor.exists?
  assessor_args = {
    email: "assessor@example.com",
    password: "^#ur9EkLm@1W",
    first_name: "First name",
    last_name: "Last name",
    confirmed_at: DateTime.now
  }

  Assessor.create!(assessor_args)
end

roles = ["lead", "regular", "none"]
awards = ["trade", "innovation", "development", "promotion", "mobility"]

awards.each do |award|
  roles.each do |role|
    assessor_args = {
      email: "#{role}-assessor-#{award}@example.com",
      first_name: "#{role}-assessor",
      last_name: "#{award}",
      confirmed_at: DateTime.now
    }
    role_args = {
      "#{award}_role" => (role == "none" ? nil : role)
    }

    assessor_args.merge!(role_args)

    a = Assessor.where(assessor_args).first_or_initialize
    a.password = "^#ur9EkLm@1W"
    a.save!
  end
end
