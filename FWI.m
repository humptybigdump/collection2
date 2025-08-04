clc; clear; close all
% Load data
% load('sample_data.mat')
% load('Ghazaleh.mat')
load('Runa.mat')

% slowness      
m0 = 1./v0.^2;
mu = 1./1400.^2;
ml = 1./4500.^2;
for i = 1 : 50

    parfor j = 1 : size(Sloc,1)
        % STFI
        [~,~,d_est(:,:,j)] = forward(v0,h,dt,t,Lpml,f0,s(:,j),Sloc(j,:),Rloc);
        s(:,j) = stfi(d_obs(:,:,j),d_est(:,:,j),s(:,j));
        % Forward
        [~,dtt_wf,d_est(:,:,j)] = forward(v0,h,dt,t,Lpml,f0,s(:,j),Sloc(j,:),Rloc);
        % Backward
        [wb,~,~] = forward(v0,h,dt,t,Lpml,f0,flipud(d_obs(:,:,j) - d_est(:,:,j)),Rloc,Rloc);
        % Gradient
        g(:,:,j) = sum(dtt_wf.*flip(wb,3),3);
        % Hessian approximation
        H(:,:,j) = sum(dtt_wf.^2,3);
    end


    % Gradient Preconditioning with Hessian aprox.
    g = sum(g,3)./sum(H,3);


    % step-length
    epsl = max(abs(m0(:)))/(max(abs(g(:)))*100);
    m_temp = m0 - epsl*g;
    
    parfor j = 1 : size(Sloc,1)
        [~,~,d_temp(:,:,j)] = forward(sqrt(1./m_temp),h,dt,t,Lpml,f0,s(:,j),Sloc(j,:),Rloc);
    end
    d_temp = (d_temp - d_est)./epsl;
    alfa = ((d_obs(:) - d_est(:))'*d_temp(:))/(d_temp(:)'*d_temp(:));


    % model update
    m0 = m0 - alfa.*g;
    m0(m0<ml) = ml;
    m0(m0>mu) = mu;
    v0 = sqrt(1./m0);

    missfit(i) = norm(sum(d_est - d_obs,3),'fro');
    subplot(121); plot(missfit);
    subplot(122); imagesc(v0); clim([2000,5000]);

    colormap jet
    drawnow;
end