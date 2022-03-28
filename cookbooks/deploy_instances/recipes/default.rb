#
# Cookbook:: deploy_instances
# Recipe:: default
#
# Copyright:: 2022, The Authors, All Rights Reserved.
bash 'deploy backend and frontend' do
    user 'ec2-user'
    environment 'KUBECONFIG' => '/home/ec2-user/.kube/config'
    code <<-EOH
    sudo kubectl apply -f https://raw.githubusercontent.com/computerSmokio/rampupv2/main/kubernetes_related/backend_deployment.yaml
    sudo kubectl apply -f https://raw.githubusercontent.com/computerSmokio/rampupv2/main/kubernetes_related/frontend_deployment.yaml
    EOH
    action :run
end
