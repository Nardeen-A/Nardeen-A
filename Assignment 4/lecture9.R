install.packages("lfe")
library(lfe)

install.packages('rdrobust')
library(rdrobust)

data <-read.csv("C:/Users/nickl/Dropbox/TMU/teaching/ECN726/2024/lecture 5/assignment2_trackingRD.csv", header=TRUE)

#1.
rct<- lm(totalscore~tracking+percentile+tracking:percentile,data=data)
summary(rct)

#what not to estimate
rct<- lm(totalscore~tracking+tracking:percentile,data=data)
summary(rct)

#2.Quantile treatment effects
install.packages("qte")
library(qte)

rct<- lm(totalscore~tracking,data=data)
summary(rct)

output <- ci.qte(totalscore ~ tracking, data=subset(data_1,totalscore>0), se=T, probs=seq(0.05,0.95,0.05), iters=10)
summary(output)

ggqte(output)


