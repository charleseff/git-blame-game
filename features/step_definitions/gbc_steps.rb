Then /^the output should contain, ignoring spaces:$/ do |expected|
  assert_partial_output(expected.gsub("\s",''), all_output.gsub("\s",''))
end
