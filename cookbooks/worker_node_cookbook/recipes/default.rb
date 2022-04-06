#
# Cookbook:: worker_node_cookbook
# Recipe:: default
#
# Copyright:: 2022, The Authors, All Rights Reserved.
directory '/etc/systemd/system/kubelet.service.d' do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
end

file '/etc/systemd/system/kubelet.service.d/20-aws.conf' do
    content <<-EOH
    [Service]
    Environment="KUBELET_EXTRA_ARGS=--node-ip=worker-cluster"
    EOH
    mode '0755'
    owner 'root'
    group 'root'
    action :create
end

bash 'daemon reload' do
    code <<-EOH
    sudo systemctl daemon-reload
    EOH
    action :run
end

service 'kubelet' do
    action [:start, :enable]
end

