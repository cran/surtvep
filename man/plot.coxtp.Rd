% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/coxtp.plot.R
\name{plot.coxtp}
\alias{plot.coxtp}
\title{plotting results from a fitted \code{coxtp} object}
\usage{
\method{plot}{coxtp}(
  x,
  parm,
  CI = TRUE,
  level = 0.95,
  exponentiate = FALSE,
  xlab,
  ylab,
  xlim,
  ylim,
  allinone = FALSE,
  title,
  linetype,
  color,
  fill,
  time,
  ...
)
}
\arguments{
\item{x}{model obtained from \code{coxtp}.}

\item{parm}{covariate names fitted in the model to be plotted. If \code{NULL}, all covariates are plotted.}

\item{CI}{if \code{TRUE}, confidence intervals are displayed. The default value is \code{TRUE}.}

\item{level}{the level of confidence intervals. The default value is \code{0.95}.}

\item{exponentiate}{if \code{TRUE}, exponential scale of the fitted coefficients (hazard ratio) for each covariate is plotted.
If \code{FALSE}, the fitted time-varying coefficients (log hazard ratio) are plotted.}

\item{xlab}{the title for the x axis.}

\item{ylab}{the title for the y axis.}

\item{xlim}{the limits for the x axis.}

\item{ylim}{the limits for the y axis.}

\item{allinone}{if \code{TRUE}, the time-varying trajectories for different covariates are combined into a single plot. The default value is \code{FALSE}.}

\item{title}{the title for the plot.}

\item{linetype}{the line type for the plot.}

\item{color}{the aesthetics parameter for the plot.}

\item{fill}{the aesthetics parameter for the plot.}

\item{time}{the time points for which the time-varying coefficients to be plotted.
The default value is the unique observed event times in the dataset fitting the time-varying effects model.}

\item{\dots}{other graphical parameters to plot}
}
\value{
A plot is produced, and nothing is returned.
}
\description{
This function creates a plot of the time-varying coefficients from a fitted \code{coxtp} model.
}
\examples{
data(ExampleData)
z <- ExampleData$z
time <- ExampleData$time
event <- ExampleData$event
fit <- coxtp(event = event, z = z, time = time)
plot(fit$lambda1)
}
