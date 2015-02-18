class CatMailer < ActionMailer::Base
  default from: "catbook@esdeluxe.com"
  def welcome(cat)
    @cat = cat
    @url = 'http://localhost:3000'
    mail(to: @cat.email, subject: 'welcome to the Cats relations site')
  end
end
