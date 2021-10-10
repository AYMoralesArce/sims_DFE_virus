#This is to write out all the command lines used:

#Step 1: Run the simulations:
#For a diploid WF model:
>> slim -d d_seed=${repID} -d d_f1=0.7 -d d_f2=0.0 -d d_f3=0.0 -d "d_rep='${repID}'" -d "d_folder='/path/sim13'" virus_eqm_dfe_WF_diploid_noStacking.slim
>> slim -d d_seed=${repID} -d d_f1=0.0 -d d_f2=0.7 -d d_f3=0.0 -d "d_rep='${repID}'" -d "d_folder='/path/sim14'" virus_eqm_dfe_WF_diploid_noStacking.slim
>> slim -d d_seed=${repID} -d d_f1=0.0 -d d_f2=0.0 -d d_f3=0.7 -d "d_rep='${repID}'" -d "d_folder='/path/sim15'" virus_eqm_dfe_WF_diploid_noStacking.slim

#For a diploid non-WF population with psi and h=0.5
>> slim -d d_seed=seed -d d_psi=0.075 -d d_f1=0.7 -d d_f2=0.0 -d d_f3=0.0 -d "d_rep='replicate number'" -d "d_folder='path/to/sim16'" virus_eqm_dfe_psi_noStacking_diploid.slim
>> slim -d d_seed=seed -d d_psi=0.075 -d d_f1=0.0 -d d_f2=0.7 -d d_f3=0.0 -d "d_rep='replicate number'" -d "d_folder='path/to/sim17'" virus_eqm_dfe_psi_noStacking_diploid.slim
>> slim -d d_seed=seed -d d_psi=0.075 -d d_f1=0.0 -d d_f2=0.0 -d d_f3=0.7 -d "d_rep='replicate number'" -d "d_folder='path/to/sim18'" virus_eqm_dfe_psi_noStacking_diploid.slim

>> slim -d d_seed=seed -d d_psi=0.15 -d d_f1=0.7 -d d_f2=0.0 -d d_f3=0.0 -d "d_rep='replicate number'" -d "d_folder='path/to/sim19'" virus_eqm_dfe_psi_noStacking_diploid.slim
>> slim -d d_seed=seed -d d_psi=0.15 -d d_f1=0.0 -d d_f2=0.7 -d d_f3=0.0 -d "d_rep='replicate number'" -d "d_folder='path/to/sim20'" virus_eqm_dfe_psi_noStacking_diploid.slim
>> slim -d d_seed=seed -d d_psi=0.15 -d d_f1=0.0 -d d_f2=0.0 -d d_f3=0.7 -d "d_rep='replicate number'" -d "d_folder='path/to/sim21'" virus_eqm_dfe_psi_noStacking_diploid.slim


#Step 2: calculate the SFS:
folders=("13" "14" "15" "16" "17" "18" "19" "20" "21")
for s_folder in "${folders[@]}"
do
    echo "folder sim"${s_folder}
    mkdir /home/pjohri1/VirusDfe/DFEalpha_noStacking_Nu0_1/sim${s_folder}
    python /home/pjohri1/VirusDfe/programs/get_folded_sfs_from_full_output_finitesites_dfealpha.py -regionLen 10000 -input_folder /scratch/pjohri1/VIRUS_DFE/DFEalpha/NoStacking_Nu0_1/sim${s_folder} -output_folder /home/pjohri1/VirusDfe/DFEalpha_noStacking_Nu0_1/sim${s_folder} -output_prefix sim${s_folder} -mutnTypesNeutral m1 -mutnTypesSelected m2,m3,m4
done

#Step 3: Run DFE-alpha from the pooled SFS:
for s_folder in "${folders[@]}"
do
    echo "folder sim"${s_folder}
    python dfealpha_replicates.py ${s_folder} _noStacking_Nu0_1
done

#Step 4: Get the discrete DFE:
>> Rscript ./summarize_parameters_dfealpha_all.r #change an option internally for the subfolder
