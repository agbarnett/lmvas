#' Bayesian linear model for EQ-5D using the score and visual analogue scale (VAS)
#'
#' Runs a Bayesian multivariate linear regression model using INLA.
#' The two dependent variables are the EQ-5D score and VAS which are assumed to be correlated.
#'
#' inputs:
#' @param vas_name variable containing the VAS (character)
#' @param eq_name variable containing the EQ-5D score (character)
#' @param independent_vars vector of independent variables (vector)
#' @param data data frame containing the independent variables and EQ-5D outcomes
#'
#' @return inla
#' @export
#' @import INLA
#' @importFrom dplyr bind_cols
#' @importFrom stats as.formula
#' @examples
#' model = res = lmvas(vas_name='EQ5D_VAS', eq_name='EQ5D', independent_vars =
#' c('age','sex'), data=arthritis)
#' summary(model)

lmvas = function(vas_name, eq_name, independent_vars = NULL, data){

  # to do, add random effects
  # to do, silence rename messages for bind_cols

  # slim down the data
  if(is.null(independent_vars)==FALSE){
    for_model = data[, c(eq_name, vas_name, independent_vars)]
  }
  if(is.null(independent_vars)==TRUE){
    for_model = data[, c(eq_name, vas_name)]
  }

  ## checks
  # check for missing data
  if(any(missing(for_model))){
    warning('Some missing data.\n')
  }
  # check scale of VAS
  if(any(for_model[,2]<0) | any(for_model[,2]>1)){ # VAS is in second column
    stop('VAS must be between 0 and 1.\n')
  }
  # check scale of EQ-5D
  if(any(for_model[,1]>1)){ # score is in first column
    stop('eq-5d score must not be greater than 1.\n')
  }

  # arrange data for INLA set-up
  n = nrow(for_model)
  for_model2 = with(for_model,
                   data.frame(
                     type_vas = c(rep(0, n), rep(1, n)), # binary outcome type (0 = score, 1 = VAS)
                     ID = 1:(2*n)))
  # add dependent variable
  to_bind = unlist(c(for_model[,1], for_model[,2])) # score then VAS
  for_model2 = bind_cols(for_model2, to_bind)
  names(for_model2)[3] = 'eq'
  # add independent variable(s)
  if(is.null(independent_vars)==FALSE){
    for (var in independent_vars){
      to_bind = unlist(c(for_model[,var], for_model[,var]))
      for_model2 = bind_cols(for_model2, to_bind)
      names(for_model2)[ncol(for_model2)] = var # rename
    }
  } # end of if

  # set up the formula
  if(length(independent_vars) == 0 ){ # no independent variables
    formula = paste('eq ~ type_vas + f(ID, model = "iid2d", n = 2 * n)', sep='')
  }
  if(length(independent_vars)> 0 ){ # some independent variables
    formula = paste('eq ~ type_vas + ', paste(independent_vars, collapse=' + ', sep=''), '+ f(ID, model = "iid2d", n = 2 * n)', sep='')
  }

  # run the multivariate model
  m.iid2d <- inla(as.formula(formula),
                  data = for_model2, family = "normal")

  # return the model
  return(m.iid2d)

}
