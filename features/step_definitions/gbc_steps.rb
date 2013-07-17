World(ArubaExt)

Then /^the output should contain, ignoring spaces:$/ do |expected|
  assert_partial_output(expected.gsub("\s", ''), all_output.gsub("\s", ''))
end

Then /^I should see:$/ do |expected|
  assert_seen(expected)
end

Then /^the next bit of output should contain, ignoring spaces:$/ do |expected|
  assert_seen(expected)
end

def assert_seen(expected)
  @seen_output ||= ''
  expected = unescape(expected.gsub("\s", ''))
  wait_until_expectation do
    @all_output = only_processes[0].output

    actual = unescape(@all_output[@seen_output.size..-1].gsub("\s", ''))

    actual.should include(expected)
  end
  @seen_output = @all_output
end
