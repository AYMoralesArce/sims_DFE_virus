#!/bin/env Rscript
#chmod +x get_final_statistics.R
#Rscript ./summarize_parameters_dfealpha.r

#This is to summarize the parameters from dfealpha infernece files:
subfolder <- "_noStacking_Nu0_1"

v_folders <- c("sim4", "sim5", "sim6", "sim7", "sim8", "sim9", "sim1_WF", "sim2_WF", "sim3_WF", "sim13", "sim14", "sim15", "sim16", "sim17", "sim18", "sim19", "sim20", "sim21")
t_all <- c()
for (folder in v_folders){
    filename_est <- paste("/home/pjohri1/VirusDfe/DFEalpha", subfolder, "/", folder, "_sel/est_dfe_repall.txt", sep="")
    filename_dfe <- paste("/home/pjohri1/VirusDfe/DFEalpha", subfolder, "/", folder, "_sel/dfe_classes_repall.txt",sep="")
    if (file.exists(filename_est)==T & file.exists(filename_dfe)==T){
        t_est <- read.table(filename_est, h=F)
        t_dfe <- read.table(filename_dfe, h=F)
        t_all <- rbind(t_all, c(folder, "mean", mean(t_est$V2), mean(t_est$V4), mean(t_est$V6), mean(t_est$V8), mean(t_est$V10), mean(t_est$V12), mean(t_dfe$V3), mean(t_dfe$V6), mean(t_dfe$V9), mean(t_dfe$V12)))
        }
    }
colnames(t_all) <- c("folder", "stat", "N1", "N2", "t2", "Nw", "b", "Es", "f0", "f1", "f2", "f3")

write.table(t_all, file=paste("/home/pjohri1/VirusDfe/DFEalpha", subfolder, "/final_parameters_all.txt", sep=""), append=F, sep='\t', row.names=F)

