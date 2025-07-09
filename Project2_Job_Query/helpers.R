## Helper functions for app
# Results of all job postings 
APIkey <- "625d2b5b-7b88-4f51-864f-134f416e6dbe"
search_URL <- "https://www.reed.co.uk/api/1.0/search?"
all <- httr::GET(search_URL, 
                 httr::authenticate(user = APIkey, password = "", type = "basic"))
parsed_all <- fromJSON(rawToChar(all$content))
parsed_all2 <- parsed_all$results
# List of locations
list_locations <- sort(parsed_all2$locationName)
# List of employers
list_employers <- sort(parsed_all2$employerName)

# Use GET from httr package
query_func <- function(keyword="", location="", employer="", minSalary=""){
  search_URL <- "https://www.reed.co.uk/api/1.0/search?"
  criteria_URL <- paste0(search_URL, "keyword=", keyword,
                         "&locationName=", location)
  APIkey <- "625d2b5b-7b88-4f51-864f-134f416e6dbe"
  return <- httr::GET(criteria_URL, 
                      httr::authenticate(user = APIkey, password = "", type = "basic"))
  parsed <- fromJSON(rawToChar(return$content))
  parsed_return <- as_tibble(parsed$results)
  #filtered_return <- parsed_return %>% 
   # filter((employerName == employer)) %>%
    #filter((minimumSalary > minSalary))
}
results <- query_func()
