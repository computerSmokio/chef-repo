bash 'deploy backend and frontend' do
    code <<-EOH
    kubectl rollout restart deployment frontend-movie-deployment -n rampup-frontend-ns
    EOH
    action :run
end