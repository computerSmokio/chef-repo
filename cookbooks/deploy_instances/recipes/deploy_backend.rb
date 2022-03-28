bash 'rollout backend' do
    code <<-EOH
    kubectl rollout restart deployment backend-movie-deployment -n rampup-backend-ns
    EOH
    only_if 'kubectl get deployments backend-movie-deployment -n rampup-backend-ns > /dev/null 2>&1; echo $?'
    action :run
end
bash 'deploy backend' do
    code <<-EOH
    kubectl rollout apply backend-movie-deployment -n rampup-backend-ns
    EOH
    not_if 'kubectl get deployments backend-movie-deployment -n rampup-backend-ns > /dev/null 2>&1; echo $?'
    action :run
end