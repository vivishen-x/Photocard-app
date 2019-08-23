class EmployeeMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.employee_mailer.account_activation.subject
  #
  def account_activation(employee)
    @employee = employee

    mail to: employee.email, subject: "Account activation"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.employee_mailer.password_reset.subject
  #
  def password_reset(employee)
    @employee = employee

    mail to: employee.email, subject: "Password reset"
  end
end
