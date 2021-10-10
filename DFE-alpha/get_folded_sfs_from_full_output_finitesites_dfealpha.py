#How to run:
#python get_folded_sfs_from_full_output_finitesites_dfealpha.py -regionLen 10000 -input_folder /scratch/amoral70/sim1 -output_folder -output_prefix -mutn_types_neutral m1 -mutn_types_selected m2,m3,m4

import sys
import argparse
import os
import numpy

#parsing user given constants
parser = argparse.ArgumentParser(description='Information about number of sliding windows and step size')
parser.add_argument('-regionLen', dest = 'regionLen', action='store', nargs = 1, type = int, help = 'length in bp of region simulated')#Length of coding region simulated
parser.add_argument('-input_folder', dest = 'input_folder', action='store', nargs = 1, type = str, help = 'full path to folder with .ms files')
parser.add_argument('-output_folder', dest = 'output_folder', action='store', nargs = 1, type = str, help = 'full path to folder where you want to write the output')
parser.add_argument('-output_prefix', dest = 'output_prefix', action='store', nargs = 1, type = str, help = 'full path to output file')
parser.add_argument('-mutnTypesNeutral', dest = 'mutnTypesNeutral', action='store', nargs = 1, default="m1", type = str, help = 'list of mutation types separated by only a comma')
parser.add_argument('-mutnTypesSelected', dest = 'mutnTypesSelected', action='store', nargs = 1, default="m2,m3,m4", type = str, help = 'list of mutation types separated by only a comma')

#read input parameters
args = parser.parse_args()
region_len =  args.regionLen[0]
in_folder = args.input_folder[0]
out_folder = args.output_folder[0]
prefix = args.output_prefix[0]
mutn_types_neutral = args.mutnTypesNeutral[0]
mutn_types_selected = args.mutnTypesSelected[0]

print (out_folder)
num_indv = 100

tot_neu = round(float(region_len)*0.3)
tot_sel = (region_len) - tot_neu

def get_unfolded_sfs_count(l_af, s_num_samples):
    d_sfs = {}
    #s_seg = 0 #total number of truly segregating sites
    for x in l_af:
        if x > int(s_num_samples)/2:
            y = int(s_num_samples) - int(x)
        else:
            y = x
        try:
            d_sfs[y] = d_sfs[y] + 1
        except:
            d_sfs[y] = 1
        #if int(y) > 0 and int(y) < int(s_num_samples):
        #    s_seg += 1
    #print("total number of mutations of type selected:" + str(s_seg))
    return(d_sfs)

def get_sfs_freq(d_sfs_count):
    d_sfs_freq = {}
    s_tot = 0
    for x in d_sfs_count.keys():
        s_tot = s_tot + int(d_sfs_count[x])
    for x in d_sfs_count.keys():
        d_sfs_freq[x] = float(d_sfs_count[x])/float(s_tot)
    return (d_sfs_freq)

def get_allele_count(f_txt):
    d_af, d_mutns = {}, {} #posn -> af/mutn_types
    for line in f_txt:
        line1 = line.strip('\n')
        if "#" not in line1:
            if "Mutations" not in line1:
                if "m" in line1:
                    line2 = line1.split()
                    if len(line2) == 9:
                        s_mutn_type = line2[2]
                        s_posn = line2[3]
                        s_af = int(line2[8])
                        d_af[s_posn] = d_af.get(s_posn, 0) + s_af
                        if s_posn in d_mutns:
                            d_mutns[s_posn].append(s_mutn_type)
                        else:
                            d_mutns[s_posn] = []
                            d_mutns[s_posn].append(s_mutn_type)
    return(d_af, d_mutns)

#filter sites that have multiple mutations (irrespesctive of mutation type):
def filter_multiple_mutations(d_af, d_mutns, MUTN_TYPES):
    l_af_filtered = []
    num_sites_to_throw = 0
    for s_posn in d_af.keys():
        if len(d_mutns[s_posn]) == 1:
            if d_mutns[s_posn][0] in MUTN_TYPES:
                l_af_filtered.append(d_af[s_posn])
        else:
            num_sites_to_throw += 1
            #print (s_posn)
            #print (d_mutns[s_posn])
    return(l_af_filtered, num_sites_to_throw)

#filter sites that have multiple mutations of different mutation types:
def filter_multiple_mutation_types(d_af, d_mutns, MUTN_TYPES):
    l_af_filtered = {}
    num_sites_to_throw = 0
    for s_posn in d_af.keys():
        if len(numpy.unique(d_mutns[s_posn])) == 1:
            if numpy.unique(d_mutns[s_posn])[0] in MUTN_TYPES:
                l_af_filtered.append(d_af[s_posn])
        else:
            num_sites_to_throw += 1
    return(l_af_filtered, num_sites_to_throw)

#Make a list of all .txt files:
os.system("ls " + in_folder + "/*.txt > " + out_folder + "/" + prefix + ".list")

d_SFS_neu_all, d_SFS_sel_all = {}, {}
d_SFS_neu_all[0] = 0
d_SFS_sel_all[0] = 0
f_list = open(out_folder + "/" + prefix + ".list", 'r')
for Aline in f_list:
    Aline1 = Aline.strip('\n')
    f_name = Aline1.split("/").pop()
    print ("Reading file:" + Aline1)
    f_txt = open(in_folder + "/" + f_name, 'r')
    #Get a count of all alleles and mutation types at each site:
    t_ac = get_allele_count(f_txt)
    d_counts = t_ac[0]
    d_mutations = t_ac[1]
    f_txt.seek(0)
    #print (d_counts)

    #filter sites that have multiple mutations or multiple mutation types:
    t_counts_filtered_neutral = filter_multiple_mutations(d_counts, d_mutations, mutn_types_neutral)
    t_counts_filtered_selected = filter_multiple_mutations(d_counts, d_mutations, mutn_types_selected)
    #t_counts_filtered_neutral = filter_multiple_mutation_types(d_counts, d_mutations, mutn_types_neutral)
    #t_counts_filtered_selected = filter_multiple_mutation_types(d_counts, d_mutations, mutn_types_selected)
    l_counts_filtered_neutral = t_counts_filtered_neutral[0]
    s_exclude_sites_all = int(t_counts_filtered_neutral[1])
    l_counts_filtered_selected = t_counts_filtered_selected[0]
    
    #Recalculate the class 0 number:
    tot_neu = round(float(region_len - s_exclude_sites_all)*0.3)
    tot_sel = (region_len - s_exclude_sites_all) - tot_neu
    print ("total number of sites: " + str(region_len))
    print ("number of sites to be excluded: " + str(s_exclude_sites_all))
    print ("number of neutral sites: " + str(tot_neu))
    print ("number of selected sites: " + str(tot_sel))

    #Calculate the SFS
    d_SFS_count_neu = get_unfolded_sfs_count(l_counts_filtered_neutral, num_indv)
    d_SFS_count_sel = get_unfolded_sfs_count(l_counts_filtered_selected, num_indv)
    print (d_SFS_count_neu)
    f_txt.close()   
    
    #Add the SFS from this rep into the SFS for all:
    for x in d_SFS_count_neu.keys():
        try:
            d_SFS_neu_all[x] = d_SFS_neu_all[x] + d_SFS_count_neu[x]
        except:
            d_SFS_neu_all[x] = 0
            d_SFS_neu_all[x] = d_SFS_neu_all[x] + d_SFS_count_neu[x]
    d_SFS_neu_all[0] = d_SFS_neu_all[0] + tot_neu - len(l_counts_filtered_neutral)
    for y in d_SFS_count_sel.keys():
        try:
            d_SFS_sel_all[y] = d_SFS_sel_all[y] + d_SFS_count_sel[y]
        except:
            d_SFS_sel_all[y] = 0
            d_SFS_sel_all[y] = d_SFS_sel_all[y] + d_SFS_count_sel[y]
    d_SFS_sel_all[0] = d_SFS_sel_all[0] + tot_sel - len(l_counts_filtered_selected)

    #Write the full result in the DFE-alpha format:
    result = open(out_folder + "/" + f_name + "_" + str(num_indv)  + ".sfs", 'w+')
    result.write("1" + '\n')
    result.write(str(num_indv) + '\n')
    result.write(str(tot_sel - len(l_counts_filtered_selected)))
    i = 1
    while i <= int(num_indv):
        result.write('\t' + str(d_SFS_count_sel.get(i, 0)))
        i = i + 1
    result.write('\n')
    result.write(str(tot_neu - len(l_counts_filtered_neutral)))
    i = 1
    while (i <= int(num_indv)):
        result.write('\t' + str(d_SFS_count_neu.get(i, 0)))
        i = i + 1
    result.write('\n')

f_list.close()

#Write the summed SFS in the DFE-alpha format:
result = open(out_folder + "/outputall.txt" + "_" + str(num_indv)  + ".sfs", 'w+')
result.write("1" + '\n')
result.write(str(num_indv) + '\n')
result.write(str(d_SFS_sel_all[0]))
i = 1
while i <= int(num_indv):
    result.write('\t' + str(d_SFS_sel_all.get(i, 0)))
    i = i + 1
result.write('\n')
result.write(str(d_SFS_neu_all[0]))
i = 1
while (i <= int(num_indv)):
    result.write('\t' + str(d_SFS_neu_all.get(i, 0)))
    i = i + 1
result.write('\n')
print ("done")




