#!/usr/bin/env Rscript
figure <- function()
{
  par(mfrow=c(2,2))
  # Divide the figure window into four parts.
  mydata <- read.csv("data.csv")
  attach(mydata)
  #Those codes above are data-reading.
  T = 1978:2014
  plot(T,GDP);abline(v=1993,lty=3)
  plot(T,TAX);abline(v=1993,lty=3)
  D = ifelse(T>1993,1,0)
  plot(GDP,TAX)
  abline(h=mydata[T==1993,'TAX'],v=mydata[T==1993,'GDP'],lty=3)
  summary(lm(TAX~GDP+GDP*D))
  plot(TAX~GDP)
  abline(3.1137,0.11787,lty=3);abline(3.1137-79.51279,0.11787+0.08319)
  #Those codes above are mix return.
  return(0)
}
