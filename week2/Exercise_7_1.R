pop.2 <- read.csv("pop2.csv")

#1Compute the population average of the variable "bmi".

population_avg <-  mean(pop.2$bmi)
population_avg

#2 Compute the population standard deviation of the variable "bmi".

standard_deviation <- sd(pop.2$bmi)
standard_deviation

#3 Compute the expectation of the sampling distribution for the sample average of the variable

pop_mean <- rep(0, 10^5)
for(i in 1:10^5)
{
  pop_samp <- sample(pop.2$bmi, 150)
  pop_mean[i] <-mean(pop_samp)
}
mean(pop_mean)

#4Compute the standard deviation of the sampling distribution for the sample average of the variable
pop_mean <- rep(0, 10^5)
for(i in 1:10^5)
{
  pop_samp <- sample(pop.2$bmi, 150)
  pop_mean[i] <-mean(pop_samp)
}
sd(pop_mean)

#5Identify, using simulations, the central region that contains 80% of the sampling distribution of the sample average
quantile(pop_mean, c(0.1, 0.9))

#6  Identify, using the Central Limit Theorem, an approximation of the central region that contains 80% of the sampling distribution of the sample average.
qnorm(c(0.1, 0.9),mean(pop_mean),sd(pop_mean))
