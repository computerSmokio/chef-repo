bash 'rollout backend' do
    user 'ec2-user'
    environment 'KUBECONFIG' => '/home/ec2-user/.kube/config'
    code <<-EOH
    sudo kubectl rollout restart deployment backend-movie-deployment -n rampup-backend-ns
    EOH
    only_if 'kubectl get deployments backend-movie-deployment -n rampup-backend-ns > /dev/null 2>&1'
    action :run
end
bash 'deploy backend' do
    user 'ec2-user'
    environment 'KUBECONFIG' => '/home/ec2-user/.kube/config'
    code <<-EOH
    sudo kubectl apply -f https://raw.githubusercontent.com/computerSmokio/rampupv2/main/kubernetes_related/backend_deployment.yaml
    EOH
    not_if 'kubectl get deployments backend-movie-deployment -n rampup-backend-ns > /dev/null 2>&1'
    action :run
end