% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/baseline.R
\name{plot.baseline}
\alias{plot.baseline}
\title{plotting the baseline hazard}
\usage{
\method{plot}{baseline}(x, xlab, ylab, xlim, ylim, title, ...)
}
\arguments{
\item{x}{fitted object from \code{baseline} function.}

\item{xlab}{the title for the x axis.}

\item{ylab}{the title for the y axis.}

\item{xlim}{the limits of the x axis.}

\item{ylim}{the limits of the y axis.}

\item{title}{the title for the plot.}

\item{\dots}{other graphical parameters to plot}
}
\value{
A plot is produced, and nothing is returned.
}
\description{
Plotting the baseline hazard from a fitted \code{baseline} object.
}
\examples{
data(ExampleData)
z <- ExampleData$z
time  <- ExampleData$time
event <- ExampleData$event

fit   <- coxtv(event = event, z = z, time = time)
base.est <- baseline(fit)
plot(base.est)
}
