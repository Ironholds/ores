ores_query <- function(path, ...){
  
  url <- paste0("http://ores.wmflabs.org/", path)
  ua <- httr::user_agent("ORES R Client - https://github.com/Ironholds/ores")
  result <- httr::GET(url, ua, ...)
  httr::stop_for_status(result)
  return(httr::content(result))
}

list_wikis <- function(...){
  
  result <- ores_query("scores/", ...)
  return(result$contexts)
}

#'@title List Model Information
#'@description \code{\link{list_models}} lists information about
#'the models for a particular wiki, including what models are available,
#'how they have been trained, information about the model's accuracy and
#'ROC, and the model's version.
#'
#'@param project a project. Supported projects can be obtained with
#'\code{\link{list_wikis}}.
#'
#'@param ... further arguments to pass to httr's GET.
#'
#'@examples
#'# Get model information for the English-language Wikipedia
#'model_data <- list_models("enwiki")
#'
#'@seealso \code{\link{list_wikis}} for retrieving the list of supported projects,
#'and \code{\link{check_reverted}} and similar for actual checking
#'against models.
#'
#'@export
list_models <- function(project, ...){
  result <- ores_query(paste0("scores/", project, "/", ...))
  return(result$models)
}

#'@title Check Revert Probabilities
#'@description \code{check_reverted} identifies
#'whether or not an edit is considered likely, by
#'the ORES models, to be reverted.
#'
#'@param project the project the edit is on. Supported
#'projects can be found with \code{\link{list_wikis}}
#'or \code{\link{list_models}}.
#'
#'@param edits a vector of edit IDs, as integers.
#'
#'@param ... further arguments to pass to httr's GET.
#'
#'@return a data.frame of five columns; \code{edit}, the
#'edit ID, \code{project}, the project, \code{prediction},
#'whether the model predicts that the edit will be reverted,
#'\code{false_prob}, the probability that the model's prediction
#'is wrong, and \code{true_prob}, the probability that the model's
#'prediction is correct. In the event of an error (due to the edit
#'not being available) NAs will be returned in that row.
#'
#'@examples
#'# A simple, single-diff example
#'revert_data <- check_reverted("enwiki", 34854345)
#'@export
check_reverted <- function(project, edits, ...){

  result <- lapply(edits, function(id, project, ...){
    
    data <- ores_query(path = paste0("scores/", project, "/reverted/", id),
                       ...)
    if("error" %in% names(data[[1]])){
      return(data.frame(edit = names(data),
                        project = project,
                        prediction = NA,
                        false_prob = NA,
                        true_prob = NA,
                        stringsAsFactors = FALSE))
    }
    return(data.frame(edit = names(data),
                      project = project,
                      prediction = data[[1]]$prediction,
                      false_prob = data[[1]]$probability$false,
                      true_prob = data[[1]]$probability$true,
                      stringsAsFactors = FALSE))
    
  }, project = project)
  
  return(do.call("rbind", result))
}