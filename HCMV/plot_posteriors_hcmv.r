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

#Inference:
abc_ridge <- abc(target=t_obs, param=t_par, sumstat=t_stats, tol=0.05, method="ridge")
summary(abc_ridge)

#Plot:
par(mfrow=c(2,2))
par(mar=c(4,5,2,1))
est1 <- weighted.median(abc_ridge$adj.values[,1], abc_ridge$weights, na.rm = TRUE)
est2 <- weighted.median(abc_ridge$adj.values[,2], abc_ridge$weights, na.rm = TRUE)
est3 <- weighted.median(abc_ridge$adj.values[,3], abc_ridge$weights, na.rm = TRUE)
est4 <- weighted.median(abc_ridge$adj.values[,4], abc_ridge$weights, na.rm = TRUE)

h_f0_pos <- hist(abc_ridge$adj.values[,1], plot=F)
h_f0_pos$counts <- h_f0_pos$counts/sum(h_f0_pos$counts)
plot(h_f0_pos, main="", xlab="f0", ylab="Frequency", cex.lab=1.5, xlim=c(0,1), ylim=c(0,0.65))
h_f0_prior <- hist(t_par$f0, plot=F)
h_f0_prior$counts <- h_f0_prior$counts/sum(h_f0_prior$counts)
h_f0_prior$mids <- c(0.0, h_f0_prior$mids, 1.0)
h_f0_prior$counts <- c(0.0, h_f0_prior$counts, 0.0)
lines(h_f0_prior$mids, h_f0_prior$counts, type="l", lty=2)
abline(v=est1, col="red")

h_f1_pos <- hist(abc_ridge$adj.values[,2], plot=F)
h_f1_pos$counts <- h_f1_pos$counts/sum(h_f1_pos$counts)
plot(h_f1_pos, main="", xlab="f1", ylab="Frequency", cex.lab=1.5, xlim=c(0,1), ylim=c(0,0.65))
h_f1_prior <- hist(t_par$f1, plot=F)
h_f1_prior$counts <- h_f1_prior$counts/sum(h_f1_prior$counts)
h_f1_prior$mids <- c(0.0, h_f1_prior$mids, 1.0)
h_f1_prior$counts <- c(0.0, h_f1_prior$counts, 0.0)
lines(h_f1_prior$mids, h_f1_prior$counts, type="l", lty=2)
abline(v=est2, col="red")

h_f2_pos <- hist(abc_ridge$adj.values[,3], plot=F)
h_f2_pos$counts <- h_f2_pos$counts/sum(h_f2_pos$counts)
plot(h_f2_pos, main="", xlab="f2", ylab="Frequency", cex.lab=1.5, xlim=c(0,1), ylim=c(0,0.65))
h_f2_prior <- hist(t_par$f2, plot=F)
h_f2_prior$counts <- h_f2_prior$counts/sum(h_f2_prior$counts)
h_f2_prior$mids <- c(0.0, h_f2_prior$mids, 1.0)
h_f2_prior$counts <- c(0.0, h_f2_prior$counts, 0.0)
lines(h_f2_prior$mids, h_f2_prior$counts, type="l", lty=2)
abline(v=est3, col="red")

h_f3_pos <- hist(abc_ridge$adj.values[,4], plot=F)
h_f3_pos$counts <- h_f3_pos$counts/sum(h_f3_pos$counts)
plot(h_f3_pos, main="", xlab="f3", ylab="Frequency", cex.lab=1.5, xlim=c(0,1), ylim=c(0,0.65))
h_f3_prior <- hist(t_par$f3, plot=F)
h_f3_prior$counts <- h_f3_prior$counts/sum(h_f3_prior$counts)
h_f3_prior$mids <- c(0.0, h_f3_prior$mids, 1.0)
h_f3_prior$counts <- c(0.0, h_f3_prior$counts, 0.0)
lines(h_f3_prior$mids, h_f3_prior$counts, type="l", lty=2)
abline(v=est4, col="red")

>>save as 8.27 x 5