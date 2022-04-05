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

file '/etc/systemd/system/kubelet.service.d/20-aws.conf' do
    content <<-EOH
    [Service]
    Environment="KUBELET_EXTRA_ARGS=--node-ip=master-cluster"
    EOH
    mode '0755'
    owner 'root'
    group 'root'
    action :create
end

bash 'Change hostname, Create the cluster and install basic pods' do
    code <<-EOH
    sudo hostnamectl set-hostname master-cluster
    kubeadm init --ignore-preflight-errors=NumCPU --ignore-preflight-errors=Mem --pod-network-cidr=10.244.0.0/16
    mkdir -p /home/ec2-user/.kube
    sudo cp -rf /etc/kubernetes/admin.conf /home/ec2-user/.kube/config
    sudo chown ec2-user /home/ec2-user/.kube/config
    export KUBECONFIG=/home/ec2-user/.kube/config
    kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
    kubectl apply -f https://raw.githubusercontent.com/computerSmokio/rampupv2/main/kubernetes_related/ingress_nginx.yaml
    kubectl delete -A ValidatingWebhookConfiguration -n ingress-nginx ingress-nginx-admission
    EOH
    guard_interpreter :bash
    not_if 'kubectl get pods> /dev/null 2>&1'
    action :run
end

service 'kubelet' do
    action :enable
end