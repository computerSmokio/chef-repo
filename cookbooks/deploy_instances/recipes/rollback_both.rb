bash 'rollback backend and frontend' do
    code <<-EOH
    sudo kubectl rollout restart deployment frontend-movie-deployment -n rampup-frontend-ns
    sudo kubectl rollout restart deployment backend-movie-deployment -n rampup-backend-ns
    EOH
    action :run
end