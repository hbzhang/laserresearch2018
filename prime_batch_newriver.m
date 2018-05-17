%% PRIME_BATCH_NEWRIVER uses the BATCH command to run the PRIME code on Virginia Tech's NewRiver cluster.
%
%  Discussion:
%
%    The PRIME code is a function, so first we must write a script
%    called PRIME_SCRIPT that runs the function.
%
%  Licensing:
%
%    This code is distributed under the GNU LGPL license.
%
%  Modified:
%
%    12 July 2016 by Justin Krometis
%
%  Author:
%
%    John Burkardt
%
  clear

  fprintf ( 1, '\n' );
  fprintf ( 1, 'PRIME_BATCH_NEWRIVER\n' );
  fprintf ( 1, '  Run PRIME_SCRIPT on NewRiver.\n' );

% This command sets the walltime for the job (10 minutes) and sends the job to the open_q queue.
  PBSClusterInfo.setExtraParameter('-l walltime=0:10:00 -q open_q');
  %PBSClusterInfo.setExtraParameter('-l walltime=0:30:00 -Ayouralloc'); %Production (normal_q) job requires an allocation
%
%  BATCH defines the job and sends it for execution.
%  - 'prime_script' is the script to be run
%  - The Profile flag tells MATLAB to use the newriver_R2015a cluster profile. Removing it will use the default.
%  - The AttachedFiles flag says that prime_script needs prime_fun to run
%  - This example runs on 2 NewRiver nodes (48 cores: the master core + 47 more)
%  - Including the CurrentFolder flag avoids some warning messages. Set it to /home/yourpid/somedir to switch to a specific folder on NewRiver.
%
  my_job = batch ( 'prime_script', ...
    'Profile', 'newriver_R2015a', ...
    'CaptureDiary', true, ...
    'CurrentFolder', '.', ...
    'AttachedFiles', { 'prime_fun' }, ...
    'Pool', 47 );

% NOTE: For production jobs - when you are ready to run more than one job at
% a time - you willl likely want to remove the following lines
%
%  WAIT pauses the MATLAB session until the job completes.
%
  wait ( my_job );
%
%  DIARY displays any messages printed during execution.
%
  diary ( my_job );
%
%  LOAD makes the script's workspace available.
%
%  total = total number of primes.
%
  load ( my_job );

  fprintf ( 1, '\n' );
  fprintf ( 1, '  Total number of primes = %d\n', total );
%
%  These commands clean up data about the job we no longer need.
%
%  destroy ( my_job ); %Use destroy() for R2011b or earlier
  delete ( my_job ); %Use delete() for R2012a or later

  fprintf ( 1, '\n' );
  fprintf ( 1, 'PRIME_BATCH_NEWRIVER\n' );
  fprintf ( 1, '  Normal end of execution.\n' );
