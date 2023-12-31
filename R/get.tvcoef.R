#' helper function to get time-varying coefficients
#' 
#' The function gives the time-varying coefficients based on a fitted `coxtv` or `coxtp` subject. 
#' Users can specify the time points to calculate the time-varying coefficients.
#'
#' @param fit model from `coxtv` or `coxtp`.
#' @param time time points to calculate the time-varying coefficients. If `NULL`, the observed event times for fitting the model will be used.
#' 
#' @return A matrix of the time-varying coefficients. The dimension is the length of `time` by `nvars`, where `nvars` is the number
#' of covariates in the fitted mode.
#' Each row represents the time-varying coefficients at the corresponding time.
#' 
#' @export
#' 
#' @examples 
#' z     <- ExampleData$z
#' time  <- ExampleData$time
#' event <- ExampleData$event
#' fit   <- coxtv(event = event, z = z, time = time, degree = 2)
#' coef  <- get.tvcoef(fit)
#' 
#' 
get.tvcoef <- function(fit, time) {
  if (missing(fit)) stop ("Argument fit is required!")
  if (!class(fit)%in%c("coxtv","coxtp")) stop("Object fit is not of the classes 'coxtv' or 'coxtp'!")
  if (missing(time)) time <- fit$times
  if (!is.numeric(time) | min(time)<0) stop("Invalid times!")
  time <- time[order(time)]; nsplines <- attr(fit, "nsplines")
  spline <- attr(fit, "spline"); degree <- attr(fit, "degree.spline")
  knots <- fit$internal.knots; term.tv <- rownames(fit$ctrl.pts)
  # if (missing(parm)) {
  parm <- term.tv
  # } else if (length(parm)>0) {
  # indx <- pmatch(parm, term.tv, nomatch=0L)
  # if (any(indx==0L))
  # stop(gettextf("%s not matched!", parm[indx==0L]), domain=NA)
  # } else stop("Invalid parm!")
  # if (spline=="B-spline") {
  bases <- splines::bs(time, degree=degree, intercept=T, knots=knots, 
                       Boundary.knots=range(fit$times))
  # int.bases <- splines2::ibs(times, degree=degree, intercept=T, knots=knots, 
  #                            Boundary.knots=range(fit$times))
  ctrl.pts <- matrix(fit$ctrl.pts[term.tv%in%parm,], ncol=nsplines)
  mat.tvef <- bases%*%t(ctrl.pts) 
  # mat.cumtvef <- int.bases%*%t(ctrl.pts)
  colnames(mat.tvef) <- parm 
  # colnames(mat.cumtvef) <- parm
  rownames(mat.tvef) <- time
  # rownames(mat.cumtvef) <- times
  # ls <- list(tvef=mat.tvef)
  return(mat.tvef)
  # return(ls)
  # } else if (spline=="P-spline") {
  
  # }
}



