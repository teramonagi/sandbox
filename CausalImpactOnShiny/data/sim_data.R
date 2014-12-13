library(pipeR)
set.seed(1)
x1 <- 100 + arima.sim(model = list(ar = 0.999), n = 100)
x2 <- 212 + arima.sim(model = list(ar = 0.59), n = 100)
y <- 1.2*x1 + 0.5*x2 + 4*rnorm(100)
y[71:100] <- y[71:100] + 50*exp(- 0.1*((71:100) - 71))
data.frame(y=y, x1=x1, x2=x2, period=c(rep(0, 70), rep(1, 30))) %>>%
  write.csv("sim_data.csv", row.names=FALSE)

read.csv("sim_data.csv", row.names=FALSE) %>>%
  matplot