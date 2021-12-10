#To plot cross-validation in R for IAV
setwd("../Work/VIRUS_DFE")
library("abc")
library("spatstat", lib.loc="/Library/Frameworks/R.framework/Versions/3.5/Resources/library")#on desktop
library("spatstat", lib.loc="~/R/win-library/3.5")#on laptop

#Read data:
t <- read.table("IAVSims/filtered3/VIRUS_DFE_filtered3_sumstats.txt", h=T)
t_data <- read.table("FollData/Run_all.stats", h=T)
t_par <- t[,c(2:5)]
col <- c(6,7,8,9, 10,11,18, 19,20,21,22,23)
t_stats <- t[,col]

col <- c(3,4,5,6,7,8)
t_data_sub <- t_data[,col]
t_means <- c(mean(t_data_sub[,1]), mean(t_data_sub[,2]), mean(t_data_sub[,3]), mean(t_data_sub[,4]), mean(t_data_sub[,5]), mean(t_data_sub[,6]))
t_sds <- c(sd(t_data_sub[,1]), sd(t_data_sub[,2]), sd(t_data_sub[,3]), sd(t_data_sub[,4]), sd(t_data_sub[,5]), sd(t_data_sub[,6]))
t_obs <- c(t_means, t_sds)

#perform cross validation:
cv_nnet <- cv4abc(t_par, t_stats, nval=100, tols=0.05, statistic="median", method="neuralnet", transf="none")
summary(cv_nnet)

#Plot:
par(mfrow=c(2,2))
par(mar=c(4,5,2,1))
plot(as.numeric(cv_nnet$true$f0), as.numeric(cv_nnet$estim$tol0.05[,1]), xlim=c(0,1), ylim=c(0,1), xlab="True value", ylab="Estimated value", col="gray60", pch=20, cex.lab=1.5)
abline(a=0, b=1, col="black")
plot(as.numeric(cv_nnet$true$f1), as.numeric(cv_nnet$estim$tol0.05[,2]), xlim=c(0,1), ylim=c(0,1), xlab="True value", ylab="Estimated value", col="gray60", pch=20, cex.lab=1.5)
abline(a=0, b=1, col="black")
plot(as.numeric(cv_nnet$true$f2), as.numeric(cv_nnet$estim$tol0.05[,3]), xlim=c(0,1), ylim=c(0,1), xlab="True value", ylab="Estimated value", col="gray60", pch=20, cex.lab=1.5)
abline(a=0, b=1, col="black")
plot(as.numeric(cv_nnet$true$f3), as.numeric(cv_nnet$estim$tol0.05[,4]), xlim=c(0,1), ylim=c(0,1), xlab="True value", ylab="Estimated value", col="gray60", pch=20, cex.lab=1.5)
abline(a=0, b=1, col="black")

>>save as 8.27 x 5