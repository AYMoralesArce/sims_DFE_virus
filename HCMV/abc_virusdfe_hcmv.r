#ABC for HCMV data:
par(mfrow=c(2,2))
par(mar=c(4,4,2,1))

setwd("../Work/VIRUS_DFE")
library("abc")
library("spatstat", lib.loc="/Library/Frameworks/R.framework/Versions/3.5/Resources/library")
library("spatstat", lib.loc="~/R/win-library/3.5")#on laptop


t <- read.table("Stats/VIRUS_DFE_HCMV_mu-5_sumstats.txt", h=T)
t_par <- t[,c(2:5)]
col <- c(6,7,8,11)
t_stats <- t[,col]
t_obs <- c(449.0, 0.00313, 0.00370, -0.51767)


#Performing inference:
abc_ridge <- abc(target=t_obs, param=t_par, sumstat=t_stats, tol=0.05, method="ridge")
summary(abc_ridge)
plot(abc_ridge, t_par, subsample = 100)

#With ridge:
Weighted Median:        0.5257  0.2446  0.1289  0.1345
Weighted Mean:          0.4771  0.3068  0.1259  0.1275



#Getting absolute error estimates
num_rep <- 100
tot_sims <- dim(t_stats)[1]
abs_err1 <- c() 
abs_err2 <- c()
abs_err3 <- c()
abs_err4 <- c()
i = 1
while(i<=num_rep){
	j <- sample(((2):(tot_sims-1)), 1)
	print (j)
	print (i)
	to_remove <- paste("sim", j, sep="")
	t_stats_sub <- rbind(t_stats[1:(j-1),], t_stats[(j+1):tot_sims,])
	t_par_sub <- rbind(t_par[1:(j-1),], t_par[(j+1):tot_sims,])
	t_obs <- t_stats[j,]
	t_true <- t_par[j,]
	abc_ridge <- abc(target=t_obs, param=t_par_sub, sumstat=t_stats_sub, tol=0.05, method="ridge")
	#calculating errors:
	est1 <- weighted.median(abc_ridge$adj.values[,1], abc_ridge$weights, na.rm = TRUE)
	est2 <- weighted.median(abc_ridge$adj.values[,2], abc_ridge$weights, na.rm = TRUE)
	est3 <- weighted.median(abc_ridge$adj.values[,3], abc_ridge$weights, na.rm = TRUE)
	est4 <- weighted.median(abc_ridge$adj.values[,4], abc_ridge$weights, na.rm = TRUE)
	abs_err1 <- c(abs_err1, abs(est1-t_true[1,1]))
	abs_err2 <- c(abs_err2, abs(est2-t_true[1,2]))
	abs_err3 <- c(abs_err3, abs(est3-t_true[1,3]))
	abs_err4 <- c(abs_err4, abs(est4-t_true[1,4]))
	i = i + 1
	}	
mean(abs_err1)
mean(abs_err2)
mean(abs_err3)
mean(abs_err4)
