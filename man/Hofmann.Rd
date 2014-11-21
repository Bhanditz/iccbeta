\name{Hofmann}
\alias{Hofmann}
\docType{data}
\title{
A multilevel dataset from Hofmann, Griffin, and Gavin (2000).
}
\description{
A multilevel dataset from Hofmann, Griffin, and Gavin (2000). 
}
\usage{data(Hofmann)}
\format{
  A data frame with 1,000 observations and 7 variables.
  \describe{
    \item{\code{id}}{a numeric vector of group ids.}
    \item{\code{helping}}{a numeric vector of the helping outcome variable construct.}
    \item{\code{mood}}{a level 1 mood predictor.}
    \item{\code{mood_grp_mn}}{a level 2 variable of the group mean of mood.}
    \item{\code{cohesion}}{a level 2 covariate measuring cohesion.}
    \item{\code{mood_grp_cent}}{group-mean centered mood predictor.}
    \item{\code{mood_grd_cent}}{grand-mean centered mood predictor.}
  }
}
%\details{
%%  ~~ If necessary, more details than the __description__ above ~~
%}
\author{
Steven Andrew Culpepper,
Herman Aguinis

Maintainer: Steven Andrew Culpepper <sculpepp@illinois.edu>
}
\source{
Hofmann, D.A., Griffin, M.A., & Gavin, M.B. (2000). The application of hierarchical linear modeling to management research. In K.J. Klein, & S.W.J. Kozlowski (Eds.), Multilevel theory, research, and methods in organizations: Foundations, extensions, and new directions (pp. 467-511).  Hoboken, NJ: Jossey-Bass.
}
\references{
Aguinis, H., & Culpepper, S.A. (in press). An expanded decision making procedure for examining cross-level interaction effects with multilevel modeling. \emph{Organizational Research Methods}. Available at: \url{http://mypage.iu.edu/~haguinis/pubs.html}
}
\seealso{
\code{\link[lme4]{lmer}}, \code{\link{model.matrix}}, \code{\link[lme4]{VarCorr}}, \code{\link[RLRsim]{LRTSim}}, \code{\link{simICCdata}}
}
\examples{
\dontrun{
data(Hofmann)
  require(lme4)

  #Random-Intercepts Model
  lmmHofmann0 = lmer(helping ~ (1|id),data=Hofmann)
  vy_Hofmann = var(Hofmann[,'helping'])
  #computing icca
  VarCorr(lmmHofmann0)$id[1,1]/vy_Hofmann

  #Estimating Group-Mean Centered Random Slopes Model, no level 2 variables
  lmmHofmann1  <- lmer(helping ~ mood_grp_cent + (mood_grp_cent |id),data=Hofmann,REML=F)
  X_Hofmann = model.matrix(lmmHofmann1)
  P = ncol(X_Hofmann)
  T1_Hofmann  = VarCorr(lmmHofmann1)$id[1:P,1:P]
  #computing iccb
  icc_beta(X_Hofmann,Hofmann[,'id'],T1_Hofmann,vy_Hofmann)$rho_beta
  
  #Performing LR test
  #Need to install 'RLRsim' package
  library('RLRsim')
  lmmHofmann1a  <- lmer(helping ~ mood_grp_cent + (1 |id),data=Hofmann,REML=F)
  obs.LRT <- 2*(logLik(lmmHofmann1)-logLik(lmmHofmann1a))[1]
  X <- getME(lmmHofmann1,"X")
  Z <- t(as.matrix(getME(lmmHofmann1,"Zt")))
  sim.LRT <- LRTSim(X, Z, 0, diag(ncol(Z)))
  (pval <- mean(sim.LRT > obs.LRT))
}
  }
\keyword{datasets}