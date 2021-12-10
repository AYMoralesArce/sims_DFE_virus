
setwd("../Work/VIRUS_DFE")
library("abc")
library("spatstat", lib.loc="/Library/Frameworks/R.framework/Versions/3.5/Resources/library")#on desktop
library("spatstat", lib.loc="~/R/win-library/3.5")#on laptop

par(mfrow=c(2,2))
par(mar=c(4,4,2,1))

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


#Perform Inference
abc_ridge <- abc(target=t_obs, param=t_par, sumstat=t_stats, tol=0.08, method="ridge")
abc_nnet <- abc(target=t_obs, param=t_par, sumstat=t_stats, tol=0.05, method="neuralnet")
summary(abc_nnet)
Nnet (tol=0.05):
0.8122  0.1673  0.0001  0.0629
plot(abc_nnet, t_par, subsample = 100)


#Getting absolute errors:

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
	nnet <- abc(target=t_obs, param=t_par_sub, sumstat=t_stats_sub, tol=0.05, method="neuralnet")
	#calculating errors:
	est1 <- weighted.median(nnet$adj.values[,1], nnet$weights, na.rm = TRUE)
	est2 <- weighted.median(nnet$adj.values[,2], nnet$weights, na.rm = TRUE)
	est3 <- weighted.median(nnet$adj.values[,3], nnet$weights, na.rm = TRUE)
	est4 <- weighted.median(nnet$adj.values[,4], nnet$weights, na.rm = TRUE)
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
sd(abs_err1)
sd(abs_err2)
sd(abs_err3)
sd(abs_err4)