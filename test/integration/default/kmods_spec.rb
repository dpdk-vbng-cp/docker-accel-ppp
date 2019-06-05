describe kernel_module('ipoe') do
      it { should be_loaded }
end

describe kernel_module('vlan_mon') do
      it { should be_loaded }
end
