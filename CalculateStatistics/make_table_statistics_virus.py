#This is to make a final table of all statistics:                               
#How to run:
#python make_table_statistics_virus.py VIRUS_DFE filtered5 IVA_sim_200                                                                                
#python make_table_statistics_virus.py VIRUS_DFE filtered4 iav_experimental_data_1e-4
#python make_table_statistics_virus.py VIRUS_DFE filtered3_1 iav_experimental_data_1e-3
#python make_table_statistics_virus.py VIRUS_DFE filtered3_2 iav_experimental_data_1e-3_300
#python make_table_statistics_virus.py VIRUS_DFE HCMV/mu-7 hcmv/20_parameters_mu1e7
#python make_table_statistics_virus.py VIRUS_DFE HCMV/mu-5 hcmv/OSG_output_mu_1e5/tars
import sys                                                                      
myfolder = sys.argv[1]
subfolder = sys.argv[2]                                                         
anafolder = sys.argv[3]
tot_sims = 500
s_window = 23500

result = open("/scratch/pjohri1/" + myfolder + "/" + subfolder + "/" + myfolder + "_" + subfolder.replace("/", "_") + "_sumstats.txt", 'w+')

l_stats = ["S_m", "thetapi_m","thetaw_m","thetah_m", "hprime_m", "tajimasd_m", "numSing_m", "hapdiv_m", "rsq_m", "D_m", "Dprime_m", "div_m", "S_sd", "thetapi_sd", "thetaw_sd", "thetah_sd", "hprime_sd", "tajimasd_sd", "numSing_sd", "hapdiv_sd", "rsq_sd", "D_sd", "Dprime_sd", "div_sd"]
result.write("simID" + '\t' + "f0" + '\t' + "f1" + '\t' + "f2" + '\t' + "f3")

for stat in l_stats:
    result.write('\t' + stat)
result.write('\n')

simID = 1                                                                           
mark = 0                                                                        
while simID <= tot_sims:
    mark = 0
    try:
        f_stats = open("/scratch/pjohri1/" + myfolder + "/" + subfolder + "/sim" + str(simID) + "_" + str(s_window) + ".summary", 'r')
        if subfolder == "HCMV/mu-5":
            f_para = open("/scratch/pjohri1/eqm_disc_parameters+5.txt", 'r')
            mark = 2
        else:
            f_para = open("/scratch/amoral70/" + anafolder + "/" + str(simID) + "/row_parameters.csv", 'r')
            mark = 1
        #f_stats = open("/scratch/pjohri1/" + myfolder + "/" + subfolder + "/sim" + str(simID) + "_" + str(s_window) + ".summary", 'r')
    except:
        print ("sim " + str(simID) + " not present")
    if mark == 1:
        for line in f_para:
            line1 = line.strip('\n')
            line2 = line1.split(",")
            if line2[0] == '"1"':
                s_tot = int(line2[1]) + int(line2[2]) + int(line2[3]) + int(line2[4])
                result.write("sim" + str(simID) + '\t' + str(float(line2[1])/float(s_tot)) + '\t' + str(float(line2[2])/float(s_tot)) + '\t' + str(float(line2[3])/float(s_tot)) + '\t' + str(float(line2[4])/float(s_tot)))
        f_para.close()
    if mark == 2:
        for line in f_para:
            line1 = line.strip('\n')
            if len(line1) > 0:
                line2 = line1.split('\t')
                if line2[0] == "sim" + str(simID):
                    s_tot = int(line2[1]) + int(line2[2]) + int(line2[3]) + int(line2[4])
                    result.write("sim" + str(simID) + '\t' + str(float(line2[1])/float(s_tot)) + '\t' + str(float(line2[2])/float(s_tot)) + '\t' + str(float(line2[3])/float(s_tot)) + '\t' + str(float(line2[4])/float(s_tot)))
        f_para.close()
    if mark == 1 or mark == 2:
        f_stats = open("/scratch/pjohri1/" + myfolder + "/" + subfolder + "/sim" + str(simID) + "_" + str(s_window) + ".summary", 'r')
        for line in f_stats:
            line1 = line.strip('\n')
            line2 = line1.split('\t')
            if "stats" not in line:
                for x in line2[1:]:
                    if x != "NA":
                        result.write('\t' + str(round(float(x),5)))
                    else:
                        result.write('\t' + x)
        result.write('\n')
        f_stats.close()
    simID = simID + 1

result.close()
print ("done")

