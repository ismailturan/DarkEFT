#!/usr/bin/perl


# This perl function write an BdNMC parameter card


 if($#ARGV < 1 )
 {
 exit;
 }


# It also only consider production channels relevant


my $fmass = abs($ARGV[1])+abs($ARGV[2]);
$outname="parameter.dat";
$BdNMCout=$ARGV[3];
$MDM= -abs($ARGV[1]);
$MDM2= abs($ARGV[2]);
$MDP= 3*abs($ARGV[1]);


my $expnb = 0;



# Checking meta stable dark higgs

$longlived = 1;




 if(!open(FO,">$outname"))
 {
     exit;
   }


  print FO "
#Parameter Card for Various beam dump experiments
#All masses should be provided in GeV, all lengths in meters.
#Lines preceded by a # are ignored by the parser.

#Model Parameters
epsilon 1e-3
dark_matter_mass $MDM
dark_photon_mass $MDP
alpha_D 0.1
dark_matter2_mass $MDM2
dark_higgs_mass $MDP
dark_matter_Z11 0.7
dark_matter_Z12 -0.7
dark_matter_Z21 0.7
dark_matter_Z22 0.7



";



if( $expnb == 0 ){
##################################################################
######          For mBoone                                   #######
##################################################################
     print FO "
#Parameter Card for FNAL Ring -- e.g. a

#Run parameters
POT 1.0e20
pi0_per_POT 3.5
efficiency 1
samplesize 30

max_trials 5000000


#Optionally, you may specify a number of pi0s per meson
meson_per_pi0 1

#The simulation generates dark matter trajectories intersecting the detector, scatters them, and
#throws away the results until burn_max is reached. If the number of attempts exceeds
#burn_max*burn_timeout, the burn_in process aborts early and an alert is written to cerr
#before the simulation resumes.
burn_max 100
burn_timeout 20000

beam_energy 120.


################################
#Production Channel Definitions#
################################

";

 if ($longlived and $fmass < 0.025) {
print FO  "
# First production channel

production_channel pi0_decay
production_distribution bmpt
p_num_target 26
n_num_target 30

";
}

if ($longlived and $fmass > 0.025 and $fmass < 0.134976) {
print FO  "
# First production channel

production_channel pi0_decay
production_distribution bmpt
p_num_target 26
n_num_target 30

production_channel eta_decay
meson_per_pi0 0.1
production_distribution bmpt
p_num_target 26
n_num_target 30

";
}


if($longlived and $fmass<0.546 and $fmass > 0.134976)
{
     print FO  "

production_channel eta_decay
meson_per_pi0 0.1
production_distribution bmpt
p_num_target 26
 n_num_target 30
# For C target

production_channel V_decay
production_distribution proton_brem
ptmax 1
zmin 0.1
zmax 0.9

";
}


if($longlived and $fmass>0.546 )
{
     print FO  "

production_channel V_decay
production_distribution proton_brem
ptmax 1
zmin 0.1
zmax 0.9

";
}

    print FO "

############################
#END OF PRODUCTION CHANNELS#
############################


################
#SIGNAL CHANNEL#
################


signal_channel NCE_electron


########
#OUPTUT#
########

#Where to write events.
output_file Events/events.dat
#Where to write a summary of the run with number of events and paramaters in the format: channel_name V_mass DM_mass num_events epsilon alpha_prime scattering_channel
summary_file $BdNMCout


output_mode summary

#Cuts on the kinetic energy of outgoing nucleon or electron. These default to min=0 and max=1e9 GeV

max_scatter_energy 0.6
min_scatter_energy 0.050
min_scatter_angle 0.035
max_scatter_angle 7

######################
#DETECTOR DECLARATION#
######################

#Detector Parameters
detector sphere
x-position 0.0
y-position -14.0
z-position 990
radius 7.0


#decay_volume cuboid
#x-position_dv 0.0
#y-position_dv 0.0
#z-position_dv 383
#width_dv 2.66
#height_dv 3.0
#length_dv 0.5
#det-theta_dv 0
#det-phi_dv 0
#det-psi_dv 0

decay_volume sphere
x-position_dv 0.0
y-position_dv -14.0
z-position_dv 990
radius_dv 7.0



#Material parameters
#Mass is set in GeV.
#mass is only important for coherent scattering, can be set to anything.
#anything not defined will be set to zero.
material Carbon
number_density 3.63471e22
proton_number 6
neutron_number 6
electron_number 6
mass 11.2593

material Hydrogen
number_density 7.26942e22
proton_number 1
neutron_number 0
electron_number 1
mass 0.945778


 ";
 close F0;
}
else{
 print "Error, invalid experiment number $nbexp";
}
