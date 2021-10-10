#This is to write out all the command lines used:

#Step 1: Run the simulations:

#Step 2: calculate the SFS:
python /home/pjohri1/VirusDfe/programs/get_folded_sfs_from_full_output_finitesites_dfealpha.py -regionLen 10000 -input_folder /scratch/pjohri1/VIRUS_DFE/DFEalpha/NoStacking_Nu0_1/sim${s_folder} -output_folder /home/pjohri1/VirusDfe/DFEalpha_noStacking_Nu0_1/sim${s_folder} -output_prefix sim${s_folder} -mutnTypesNeutral m1 -mutnTypesSelected m2,m3,m4

#Step 3: Run DFE-alpha from the pooled SFS:
python dfealpha_replicates.py ${s_folder} _noStacking_Nu0_1

#Step 4: Get the discrete DFE:
Rscript ./summarize_parameters_dfealpha_all.r #change an option internally for the subfolder
