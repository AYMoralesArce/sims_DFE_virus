#This is to run DFE-alpha across replicates and save the results:

import sys
import os
simID = sys.argv[1] #1/2/3...12 OR 1_WF, 2_WF, 3_WF
subfolder = sys.argv[2] #_Stacking or _noStacking
num_reps = 10

#Modify the config file
#l_reps = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "all"]
l_reps = ["all"]
for repID in l_reps:
    print ("Replicate number: " + str(repID))
    #modify the neutral config file:
    f_neu = open("/home/pjohri1/VirusDfe/DFEalpha" + subfolder + "/est_dfe_config_file_neu.txt", 'r')
    result_neu = open("/home/pjohri1/VirusDfe/DFEalpha" + subfolder + "/est_dfe_config_file_neu_modified.txt", 'w+')
    for line in f_neu:
        new_line1 = line.replace("$SIMID$", str(simID))
        new_line2 = new_line1.replace("$REPID$", str(repID))
        result_neu.write(new_line2)
    f_neu.close()
    result_neu.close()
    #modify the selection config file:
    f_sel = open("/home/pjohri1/VirusDfe/DFEalpha" + subfolder + "/est_dfe_config_file_sel.txt", 'r')
    result_sel = open("/home/pjohri1/VirusDfe/DFEalpha" + subfolder + "/est_dfe_config_file_sel_modified.txt", 'w+')
    for line in f_sel:
        new_line1 = line.replace("$SIMID$", str(simID))
        new_line2 = new_line1.replace("$REPID$", str(repID))
        result_sel.write(new_line2)
    f_sel.close()
    result_sel.close()

    #Run DFE-alpha
    os.system("/home/pjohri1/bin/DFEalpha/dfe-alpha-release-2.16/est_dfe -c /home/pjohri1/VirusDfe/DFEalpha" + subfolder + "/est_dfe_config_file_neu_modified.txt")
    os.system("/home/pjohri1/bin/DFEalpha/dfe-alpha-release-2.16/est_dfe -c /home/pjohri1/VirusDfe/DFEalpha" + subfolder + "/est_dfe_config_file_sel_modified.txt")

    #Get DFE classes:
    os.system("/home/pjohri1/bin/DFEalpha/dfe-alpha-release-2.16/prop_muts_in_s_ranges -c /home/pjohri1/VirusDfe/DFEalpha" + subfolder + "/sim" + str(simID) + "_sel/est_dfe.out -o /home/pjohri1/VirusDfe/DFEalpha" + subfolder + "/sim" + str(simID) + "_sel/dfe_classes")

    #Rename output files
    l_files = ["dfe_classes", "est_dfe.out", "sel_egf.out", "sel_exp_obs_allele_freqs.csv"]
    for s_out in l_files:
        filename = s_out.split(".")[0]
        os.system("mv /home/pjohri1/VirusDfe/DFEalpha" + subfolder + "/sim" + str(simID) + "_sel/" + s_out + " /home/pjohri1/VirusDfe/DFEalpha" + subfolder + "/sim" + str(simID) + "_sel/" + filename + "_rep" + str(repID) + ".txt")
    
    #Remove temporary files:
    os.system("rm /home/pjohri1/VirusDfe/DFEalpha" + subfolder + "/est_dfe_config_file_neu_modified.txt")
    os.system("rm /home/pjohri1/VirusDfe/DFEalpha" + subfolder + "/est_dfe_config_file_sel_modified.txt")

    #repID += 1

print ("done")

