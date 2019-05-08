clear
clc

%% Options
opts = get_opts_aic();
opts.experiment_name = 'aic_zju';
% opts.detections = 'yolo3';
% basis setting for DeepCC
opts.tracklets.window_width = 10;
opts.trajectories.window_width = 50;
% correlation threshold setting according to `view_distance_distribution(opts)`
opts.feature_dir = 'det_features_zju_lr001_test_ssd';
opts.tracklets.threshold    = 4.5;
opts.trajectories.threshold = 4.5;
opts.identities.threshold   = 4.9;
opts.tracklets.diff_p    = 1.82;
opts.trajectories.diff_p = 1.82;
opts.identities.diff_p   = 1.82;
opts.tracklets.diff_n    = 1.82;
opts.trajectories.diff_n = 1.82;
opts.identities.diff_n   = 1.82;

create_experiment_dir(opts);

%% Setup Gurobi
if ~exist('setup_done','var')
    setup;
    setup_done = true;
end

%% Run Tracker
% opts.visualize = true;
opts.sequence = 6;

%% Tracklets
opts.tracklets.spatial_groups = 0;
opts.optimization = 'KL';
compute_L1_tracklets_aic(opts);

%% Single-camera trajectories
opts.trajectories.appearance_groups = 0;
compute_L2_trajectories_aic(opts);

%% remove waiting cars
removeOverlapping(opts);

%% Multi-camera identities
opts.identities.consecutive_icam_matrix = ones(40);
opts.identities.reintro_time_matrix = ones(1,40)*inf;
opts.identities.appearance_groups = 0;
compute_L3_identities_aic(opts);

prepareMOTChallengeSubmission_aic(opts);
