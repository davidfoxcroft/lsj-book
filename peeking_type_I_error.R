# simulations from Danielle's functions for original figure
#P <- readRDS("data_and_tables/P.rds")
#BF <- readRDS("data_and_tables/BF.rds")


########################################################
# revised code - different figure to original lsr book

alpha <- 0.05 # the critical p-value for rejecting the null
bf_crit <- 3 # bayes factor critical value
n_obs <- 1000 # target sample size

# simulation N (n_obs) powered to detect effect size
# library(pwr)
# mde <- 0.1  # minimum detectable effect
# power <- 0.80 # 1-false negative rate
# ptpt <- pwr.t.test(d = mde, sig.level = alpha, power = power, 
#                    type='two.sample', alternative='two.sided')
# n_obs2 <- ceiling(ptpt$n)

peek <- c(seq(1,20,1), seq(22,50,2), seq(55,100,5), seq(110,500,10)) # how frequently to peek, ie test, the data as observations are collected
cores = parallel::detectCores() # speed up processing

# monte carlo function from https://ras44.github.io/blog/2019/04/08/validating-type-i-and-ii-errors-in-a-b-tests-in-r.html
monte_carlo <- function(n_simulations, callback, ...){
  simulations <- 1:n_simulations
  
  sapply(1:n_simulations, function(x){
    callback(...)
  })
}

# (revised) functions from https://ras44.github.io/blog/2019/04/08/validating-type-i-and-ii-errors-in-a-b-tests-in-r.html
peeking_method1 <- function (observations, by=1){
  
  scores_a <- rnorm(observations)
  scores_b <- rnorm(observations)  
  
  reject_t <- FALSE;
  
  for (i in seq(from=by,to=observations,by=by)) {
    tryCatch(
      {
        reject_t <- t.test(scores_a[1:i],scores_b[1:i],
                           var.equal=TRUE)$p.value <= alpha
        
        if(reject_t){
          break;
        }
      }, error=function(e){
        print(e)
      }
    )
  }
  
  reject_t
  
}


peeking_method2 <- function (observations, by=1){
  
  scores_a <- rnorm(observations)
  scores_b <- rnorm(observations)  
  
  reject_BF <- FALSE;
  
  for (i in seq(from=by,to=observations,by=by)) {
    tryCatch(
      {
        bayesttest <- BayesFactor::ttestBF(scores_a[1:i],scores_b[1:i])
        reject_BF <-  BayesFactor::extractBF(bayesttest)["bf"][[1]] >= bf_crit
        
        if(reject_BF){
          break;
        }
      }, error=function(e){
        print(e)
      }
    )
  }
  
  reject_BF
  
}

# quick function for counting how many sig. results
sumT <- function(x) {
  sum(x == 'TRUE', na.rm=TRUE)
}


# run the simulation
library(parallel)
rejected.p <- mclapply(seq_along(peek), function(x) {
  monte_carlo(1000,
              callback=peeking_method1,
              observations=n_obs,
              by=x)
}, mc.cores = cores)

rejected.bf <- mclapply(seq_along(peek), function(x) {
  monte_carlo(1000,
              callback=peeking_method2,
              observations=n_obs,
              by=x)
}, mc.cores = cores)


# put together the rejection tables
str(rejected.p)
str(rejected.bf)
p <- do.call(data.frame, rejected.p)
colnames(p) <- peek
p_peek <- apply(p,2,sumT)
p_peek

bf <- do.call(data.frame, rejected.bf) # computes number of sig. results for each level of peek
colnames(bf) <- peek
bf_peek <- apply(bf,2,sumT)

p_bf <- data.frame(peek,p_peek,bf_peek)
saveRDS(p_bf, "data_and_tables/p_bf.rds")




