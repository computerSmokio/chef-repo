#
# Cookbook:: install_dependencies
# Recipe:: Install Kubernetes
#
# Copyright:: 2022, Matias Vargas, All Rights Reserved.

yum_repository 'Kubernetes' do
    baseurl 'https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch'
    enabled true
    gpgcheck true
    repo_gpgcheck false
    gpgkey 'https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg'
end

['docker','kubeadm', 'kubelet', 'kubectl'].each do |p|
    package p do
        action :install
    end
end

file '/etc/docker/daemon.json' do
    content '{ "exec-opts": ["native.cgroupdriver=systemd"] }'
    mode '0755'
    owner 'root'
    group 'docker'
end

user 'ec2-user' do
    action :modify
    gid 'docker'
end

['docker', 'kubelet'].each do |p|
    service p do
        action :enable
    end
end

service 'docker' do
    action :start
end