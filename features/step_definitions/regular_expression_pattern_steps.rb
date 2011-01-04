Given /^Cellophane is called with a[n]? (good|bad|invalid) regular expression$/ do |type|
	args = ['-r']
	args <<
		case type
			when 'good'
				'(?:one|four)'
			when 'bad'
				'thisisabadregexp'
			else
				nil
		end
	
	call_cellophane(args)
end

Given /^the command should include only the correct files$/ do
	@command.should =~ /one.feature/
	@command.should =~ /four.feature/
	@command.should_not =~ /two.feature/
	@command.should_not =~ /three.feature/
end

Given /^the ['"]([^"]+)['"] message should display$/ do |message|
	@message.should == message
end
