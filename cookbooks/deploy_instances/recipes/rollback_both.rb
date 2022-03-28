bash 'rollback backend and frontend' do
    user 'ec2-user'
    environment 'KUBECONFIG' => '/home/ec2-user/.kube/config'
    code <<-EOH
    kubectl rollout restart deployment frontend-movie-deployment -n rampup-frontend-ns
    kubectl rollout restart deployment backend-movie-deployment -n rampup-backend-ns
    EOH
    action :run
end