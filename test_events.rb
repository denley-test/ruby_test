event 'always success' do
  true
end

event 'always failure' do
  false
end

setup do
  Kernel.puts 'setup 1'
end

setup do
  Kernel.puts 'setup 2'
end