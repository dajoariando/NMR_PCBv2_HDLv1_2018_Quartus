function compute_t1_meas(path,SpS,enable_figure)
%path : directory path to the samples, with freq_sweep.txt generated by the
%c-code
% enable_figure : enable the figure generated by compute_single
% SpS           : number of scans per t1_180_deg_us step

    fileID = fopen([path,'\t1_meas.txt'],'r');
    param_settings=fscanf(fileID,'%f');
    fclose(fileID);

    start_param = param_settings(1);       % start parameter
    stop_param = param_settings(2);        % stop parameter
    nsteps = param_settings(3);     % spacing parameter
    logspaceyesno = param_settings(4);   % 1 for logspace, 0 for linearspace

    if (logspaceyesno)
        sweep_param = logspace(log10(start_param),log10(stop_param),nsteps);
    else
        sweep_param = linspace(start_param,stop_param,nsteps);
    end

    for m = 1:length(sweep_param)
        name_data = ['\dat_',num2str(sweep_param(m),'%03.3f'),'_'];
        name_avg = ['\avg_',num2str(sweep_param(m),'%03.3f'),'_'];
        view_data (path, SpS, name_data, name_avg, 1);
        pause;
    end
end