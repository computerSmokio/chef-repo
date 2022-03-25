bash 'deploy backend and frontend' do
    code <<-EOH
    kubectl rollout restart deployment frontend-movie-deployment -n rampup-frontend-ns
    kubectl rollout restart deployment backend-movie-deployment -n rampup-backend-ns
    EOH
    action :run
end