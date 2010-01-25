ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
	:address => "smtp.student.uva.nl",
	:port => 25,
	:domain => "www.student.uva.nl"
}	
	