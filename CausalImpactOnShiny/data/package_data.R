library(pipeR)
set.seed(1)
x1 <- as.numeric(100 + arima.sim(model = list(ar = 0.999), n = 100))
y <- 1.2 * x1 + rnorm(100)
y[71:100] <- y[71:100] + 10
data <- data.frame(y=y, x1=x1, period=c(rep(0, 70), rep(1, 30)))
data %>>% write.csv("package_data.csv", row.names=FALSE)
