bash 'rollout frontend' do
    user 'ec2-user'
    environment 'KUBECONFIG' => '/home/ec2-user/.kube/config'
    code <<-EOH
    kubectl rollout restart deployment frontend-movie-deployment -n rampup-frontend-ns
    EOH
    only_if 'kubectl get deployments frontend-movie-deployment -n rampup-frontend-ns > /dev/null 2>&1'
    action :run
end
bash 'deploy frontend' do
    user 'ec2-user'
    environment 'KUBECONFIG' => '/home/ec2-user/.kube/config'
    code <<-EOH
    kubectl apply -f https://raw.githubusercontent.com/computerSmokio/rampupv2/main/kubernetes_related/frontend_deployment.yaml
    EOH
    not_if 'kubectl get deployments frontend-movie-deployment -n rampup-frontend-ns > /dev/null 2>&1'
    action :run
end