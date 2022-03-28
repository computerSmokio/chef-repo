bash 'rollout frontend' do
    code <<-EOH
    kubectl rollout restart deployment frontend-movie-deployment -n rampup-frontend-ns
    EOH
    only_if 'kubectl get deployments frontend-movie-deployment -n rampup-frontend-ns > /dev/null 2>&1'
    action :run
end
bash 'deploy frontend' do
    code <<-EOH
    kubectl rollout apply frontend-movie-deployment -n rampup-frontend-ns
    EOH
    not_if 'kubectl get deployments frontend-movie-deployment -n rampup-frontend-ns > /dev/null 2>&1'
    action :run
end