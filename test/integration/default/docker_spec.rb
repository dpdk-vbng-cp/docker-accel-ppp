describe docker_image('accel-ppp-drivers') do
  it { should exist }
end

describe docker_image('accel-pppd') do
  it { should exist }
end

describe docker_container('accel-ppp-drivers') do
  it { should exist }
  it { should_not be_running }
end

describe docker_container('accel-pppd') do
  it { should exist }
  it { should be_running }
end
