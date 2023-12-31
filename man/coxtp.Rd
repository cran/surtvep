% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/coxtp.R
\name{coxtp}
\alias{coxtp}
\title{fit a Cox non-proportional hazards model with P-spline or Smoothing-spline, with penalization tuning parameter chosen by information criteria or cross-validation}
\usage{
coxtp(
  event,
  z,
  time,
  strata = NULL,
  penalty = "Smooth-spline",
  nsplines = 8,
  lambda = c(0.1, 1, 10),
  degree = 3L,
  knots = NULL,
  ties = "Breslow",
  tol = 1e-06,
  iter.max = 20L,
  method = "ProxN",
  gamma = 1e+08,
  btr = "dynamic",
  tau = 0.5,
  stop = "ratch",
  parallel = FALSE,
  threads = 2L,
  fixedstep = FALSE
)
}
\arguments{
\item{event}{failure event response variable of length \code{nobs}, where \code{nobs} denotes the number of observations. It should be a vector containing 0 or 1.}

\item{z}{input covariate matrix, with \code{nobs} rows and \code{nvars} columns; each row is an observation.}

\item{time}{observed event times, which should be a vector with non-negative values.}

\item{strata}{a vector of indicators for stratification.
Default = \code{NULL} (i.e. no stratification group in the data), an unstratified model is implemented.}

\item{penalty}{a character string specifying the spline term for the penalized Newton method.
This term is added to the log-partial likelihood, and the penalized log-partial likelihood serves as the new objective function to
control the smoothness of the time-varying coefficients.
Default is \code{P-spline}. Three options are \code{P-spline}, \code{Smooth-spline} and \code{NULL}.
If \code{NULL}, the method will be the same as \code{coxtv} (unpenalized time-varying effects models) and \code{lambda} (defined below)
will be set as 0.

\code{P-spline} stands for Penalized B-spline. It combines the B-spline basis with a discrete quadratic penalty on the difference of basis coefficients between adjacent knots.
When \code{lambda} goes to infinity, the time-varying effects are reduced to be constant.

\code{Smooth-spline} refers to the Smoothing-spline, the derivative-based penalties combined with B-splines. See \code{degree} for different choices.
When \code{degree=3}, we use the cubic B-spline penalizing the second-order derivative, which reduces the time-varying effect to a linear term when \code{lambda} goes to infinity.
When \code{degree=2}, we use the quadratic B-spline penalizing first-order derivative, which reduces the time-varying effect to a constant when \code{lambda} goes to infinity. See Wood (2017) for details.

If \code{P-spline} or \code{Smooth-spline}, then \code{lambda} is initialized as a sequence (0.1, 1, 10). Users can modify \code{lambda}. See details in \code{lambda}.}

\item{nsplines}{number of basis functions in the splines to span the time-varying effects. The default value is 8.
We use the R function \code{splines::bs} to generate the B-splines.}

\item{lambda}{a user-specified \code{lambda} sequence as the penalization coefficients in front of the spline term specified by \code{penalty}.
This is the tuning parameter for penalization. The function \code{IC} can be used to select the best tuning parameter based on the information criteria.
Alternatively, cross-validation can be used via the \code{cv.coxtp} function.
When \code{lambda} is \code{0}, Newton method without penalization is fitted.}

\item{degree}{degree of the piecewise polynomial for generating the B-spline basis functions---default is 3 for cubic splines.
\code{degree = 2} results in the quadratic B-spline basis functions.

If the \code{penalty} is \code{P-spline} or \code{NULL}, \code{degree}'s default value is 3.

If the \code{penalty} is \code{Smooth-spline}, \code{degree}'s default value is 2.}

\item{knots}{the internal knot locations (breakpoints) that define the B-splines.
The number of the internal knots should be \code{nsplines}-\code{degree}-1.
If \code{NULL}, the locations of knots are chosen as quantiles of distinct failure time points.
This choice leads to more stable results in most cases.
Users can specify the internal knot locations by themselves.}

\item{ties}{a character string specifying the method for tie handling. If there are no tied events,
the methods are equivalent.
By default \code{"Breslow"} uses the Breslow approximation, which can be faster when many ties are present.
If \code{ties = "none"}, no approximation will be used to handle ties.}

\item{tol}{tolerance used for stopping the algorithm. See details in \code{stop} below.
The default value is  \code{1e-6}.}

\item{iter.max}{maximum iteration number if the stopping criterion specified by \code{stop} is not satisfied. The default value is  20.}

\item{method}{a character string specifying whether to use Newton method or proximal Newton method.  If \code{Newton} then Hessian is used,
while the default method \code{"ProxN"} implements the proximal Newton which can be faster and more stable when there exists ill-conditioned second-order information of the log-partial likelihood.
See details in Wu et al. (2022).}

\item{gamma}{parameter for proximal Newton method \code{"ProxN"}. The default value is \code{1e8}.}

\item{btr}{a character string specifying the backtracking line-search approach. \code{"dynamic"} is a typical way to perform backtracking line-search.
See details in Convex Optimization by Boyd and Vandenberghe (2004).
\code{"static"} limits Newton's increment and can achieve more stable results in some extreme cases, such as ill-conditioned second-order information of the log-partial likelihood,
which usually occurs when some predictors are categorical with low frequency for some categories.
Users should be careful with \code{static}, as this may lead to under-fitting.}

\item{tau}{a positive scalar used to control the step size inside the backtracking line-search. The default value is 0.5.}

\item{stop}{a character string specifying the stopping rule to determine convergence.
\code{"incre"} means we stop the algorithm when Newton's increment is less than the \code{tol}. See details in Convex Optimization (Chapter 10) by Boyd and Vandenberghe (2004).
\code{"relch"} means we stop the algorithm when the \eqn{(loglik(m)-loglik(m-1))/(loglik(m))} is less than the \code{tol},
where \eqn{loglik(m)} denotes the log-partial likelihood at iteration step m.
\code{"ratch"} means we stop the algorithm when \eqn{(loglik(m)-loglik(m-1))/(loglik(m)-loglik(0))} is less than the \code{tol}.
\code{"all"} means we stop the algorithm when all the stopping rules (\code{"incre"}, \code{"relch"}, \code{"ratch"}) are met.
The default value is \code{ratch}.
If \code{iter.max} is achieved, it overrides any stop rule for algorithm termination.}

\item{parallel}{if \code{TRUE}, then the parallel computation is enabled. The number of threads in use is determined by \code{threads}.}

\item{threads}{an integer indicating the number of threads to be used for parallel computation. The default value is \code{2}. If \code{parallel} is false, then the value of \code{threads} has no effect.}

\item{fixedstep}{if \code{TRUE}, the algorithm will be forced to run \code{iter.max} steps regardless of the stopping criterion specified.}
}
\value{
A list of objects with S3 class \code{"coxtp"}. The length is the same as that of \code{lambda}; each represents the model output with each value of the tuning parameter \code{lambda}.
\item{call}{the call that produced this object.}
\item{beta}{the estimated time-varying coefficient for each predictor at each unique time.
It is a matrix of dimension \code{len_unique_t} by \code{nvars},
where \code{len_unique_t} is the length of unique observed event \code{time}s.}

\item{bases}{the basis matrix used in model fitting. If \code{ties="none"}, the dimension of the basis matrix is \code{nvars} by \code{nsplines};
if \code{ties="Breslow"}, the dimension is \code{len_unique_t} by \code{nsplines}. The matrix is constructed using the \code{bs::splines} function.}
\item{ctrl.pts}{estimated coefficient of the basis matrix of dimension \code{nvars} by \code{nsplines}.
Each row represents a covariate's coefficient on the \code{nsplines}-dimensional basis functions.}
\item{Hessian}{the Hessian matrix of the log-partial likelihood, of which the dimension is \code{nsplines * nvars} by \code{nsplines * nvars}.}
\item{internal.knots}{the internal knot locations (breakpoints) that define the B-splines.}
\item{nobs}{number of observations.}
\item{penalty}{the spline term \code{penalty} specified by user.}
\item{theta.list}{the history of \code{ctrl.pts} of length \code{m} (the length of algorithm iterations), including \code{ctrl.pts} for each algorithm iteration.}
\item{VarianceMatrix}{the variance matrix of the estimated coefficients of the basis matrix,
which is the inverse of the negative Hessian matrix.}
}
\description{
Fit a Cox non-proportional hazards model via penalized maximum likelihood.
}
\details{
The sequence of models implied by \code{lambda.spline} is fit by the (proximal) Newton method.
The objective function is \deqn{loglik - P_{\lambda},}
where \eqn{P_{\lambda}} is a penalty matrix for \code{P-spline} or \code{Smooth-spline}.
The \eqn{\lambda} is the tuning  parameter (See details in \code{lambda}). Users can define the initial sequence.
The function \code{IC} below provides different information criteria to choose the tuning parameter \eqn{\lambda}. Another function \code{cv.coxtp} uses the cross-validation to choose the tuning parameter.
}
\examples{
data(ExampleData)
z <- ExampleData$z
time  <- ExampleData$time
event <- ExampleData$event

lambda  = c(0,1)
fit   <- coxtp(event = event, z = z, time = time, lambda=lambda)



}
\references{
Boyd, S., and Vandenberghe, L. (2004) Convex optimization.
\emph{Cambridge University Press}.
\cr

Gray, R. J. (1992) Flexible methods for analyzing survival data using splines, with applications to breast cancer prognosis.
\emph{Journal of the American Statistical Association}, \strong{87(420)}: 942-951.
\cr

Gray, R. J. (1994) Spline-based tests in survival analysis.
\emph{Biometrics}, \strong{50(3)}: 640-652.
\cr

Luo, L., He, K., Wu, W., and Taylor, J. M. (2023) Using information criteria to select smoothing parameters when analyzing survival data with time-varying coefficient hazard models.
\emph{Statistical Methods in Medical Research}, \strong{in press}.
\cr

Perperoglou, A., le Cessie, S., and van Houwelingen, H. C. (2006) A fast routine for fitting Cox models with time varying effects of the covariates.
\emph{Computer Methods and Programs in Biomedicine}, \strong{81(2)}: 154-161.
\cr

Wu, W., Taylor, J. M., Brouwer, A. F., Luo, L., Kang, J., Jiang, H., and He, K. (2022) Scalable proximal methods for cause-specific hazard modeling with time-varying coefficients.
\emph{Lifetime Data Analysis}, \strong{28(2)}: 194-218.
\cr

Wood, S. N. (2017) P-splines with derivative based penalties and tensor product smoothing of unevenly distributed data.
\emph{Statistics and Computing}, \strong{27(4)}: 985-989.
\cr
}
\seealso{
\code{\link{IC}}, \code{\link{cv.coxtp}} \code{\link{plot}}, \code{\link{get.tvcoef}} and \code{\link{baseline}}.
}
