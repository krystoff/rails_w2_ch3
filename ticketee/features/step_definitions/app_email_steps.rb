Then /^the email should contain (\d+) parts$/ do |num|
  current_email.parts.size.should eql(num.to_i)
end

Given /^Action Mailer delivers via SMTP$/ do
  ActionMailer::Base.delivery_method = :smtp
end

When /^I log into gmail with:$/ do |table|
  details = table.hashes.first
  @gmail = Gmail.connect(details["username"], details["password"])
  puts "---< Inbox Count= #{@gmail.inbox.count} >---"
  puts "---< Inbox Unread= #{@gmail.inbox.count(:unread)} >---"
  puts "---< Inbox Read= #{@gmail.inbox.count(:read)} >---"
end

Then /^there should be an email from Ticketee in my inbox$/ do
  @mails = @gmail.inbox.find(:unread, :from => "ticketee@gmail.com") do |mail|
    # Get counts for messages in the inbox
    if mail.message.subject =~ /^\[Ticketee\]/
      mail.delete!
      @received_mail = true
    end
  end
  @received_mail.should be_true
end

Then /^there should be a part with content type "([^"]*)"$/ do |content_type |
  current_email.parts.detect do |p|
    p.content_type.include?(content_type)
  end.should_not be_nil
end

