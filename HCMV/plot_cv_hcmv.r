#Plotting cross-validation for HCMV data:

setwd("../Work/VIRUS_DFE")
library("abc")
library("spatstat", lib.loc="/Library/Frameworks/R.framework/Versions/3.5/Resources/library")
library("spatstat", lib.loc="~/R/win-library/3.5")//on laptop


t <- read.table("Stats/VIRUS_DFE_HCMV_mu-5_sumstats.txt", h=T)
t_par <- t[,c(2:5)]
col <- c(6,7,8,11)
t_stats <- t[,col]
t_obs <- c(449.0, 0.00313, 0.00370, -0.51767)

#Cross-valdiation:
cv_ridge <- cv4abc(t_par, t_stats, nval=100, tols=0.05, statistic="median", method="ridge", transf="none")
summary(cv_ridge)

#Plot:
par(mfrow=c(2,2))
par(mar=c(4,5,2,1))
plot(as.numeric(cv_ridge$true$f0), as.numeric(cv_ridge$estim$tol0.05[,1]), xlim=c(0,1), ylim=c(0,1), xlab="True value", ylab="Estimated value", col="gray60", pch=20, cex.lab=1.5)
abline(a=0, b=1, col="black")
plot(as.numeric(cv_ridge$true$f1), as.numeric(cv_ridge$estim$tol0.05[,2]), xlim=c(0,1), ylim=c(0,1), xlab="True value", ylab="Estimated value", col="gray60", pch=20, cex.lab=1.5)
abline(a=0, b=1, col="black")
plot(as.numeric(cv_ridge$true$f2), as.numeric(cv_ridge$estim$tol0.05[,3]), xlim=c(0,1), ylim=c(0,1), xlab="True value", ylab="Estimated value", col="gray60", pch=20, cex.lab=1.5)
abline(a=0, b=1, col="black")
plot(as.numeric(cv_ridge$true$f3), as.numeric(cv_ridge$estim$tol0.05[,4]), xlim=c(0,1), ylim=c(0,1), xlab="True value", ylab="Estimated value", col="gray60", pch=20, cex.lab=1.5)
abline(a=0, b=1, col="black")

>>save as 8.27 x 5