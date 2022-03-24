#
# Cookbook:: master_node_cookbook
# Recipe:: default
#
# Copyright:: 2022, The Authors, All Rights Reserved.
directory '/etc/systemd/system/kubelet.service.d' do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
end

bash 'change hostname' do
    code <<-EOH
    sudo hostnamectl set-hostname master-cluster
    EOH
    action :run
end


file '/etc/systemd/system/kubelet.service.d/20-aws.conf' do
    content <<-EOH
    [Service]
    Environment="KUBELET_EXTRA_ARGS=--node-ip=master-cluster"
    EOH
    mode '0755'
    owner 'root'
    group 'root'
end

bash 'execute kubeadm init' do
    code <<-EOH
    kubeadm init --token-ttl 0 --ignore-preflight-errors=NumCPU --ignore-preflight-errors=Mem --pod-network-cidr=10.244.0.0/16
    EOH
    action :run
end

service 'kubelet' do
    action :enable
end

directory '/home/ec2-user/.kube' do
    owner 'ec2-user'
    mode '0755'
    action :create
end

bash 'execute kubeadm init' do
    code <<-EOH
    sudo cp -i /etc/kubernetes/admin.conf /home/ec2-user/.kube/config
    sudo chown ec2-user /home/ec2-user/.kube/config
    kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
    EOH
    action :run
end