

# Study ID Endpoints -----------------------------------------------------------

# * General Tests -----------------
test_that("With study_id-  works fine", {

  skip_on_cran()
  skip_if(httr::http_error("www.cbioportal.org/api"))

  db_test <- "public"
  set_cbioportal_db(db = db_test)
  study_id = "mpnst_mskcc"

  endpoint_funs <- c(available_profiles = available_profiles,
                     available_clinical_attributes = available_clinical_attributes,
                     get_clinical_by_study = get_clinical_by_study,
                     get_study_info = get_study_info,
                     available_samples = available_samples,
                     available_patients = available_patients,
                     available_sample_lists = available_sample_lists,

                     get_mutations_by_study = get_mutations_by_study,
                     get_cna_by_study = get_cna_by_study,
                     get_fusions_by_study = get_fusions_by_study,
                     get_genetics_by_study = get_genetics_by_study
                     )

  res <- expect_error(
    purrr::map(endpoint_funs,
               function(fn) rlang::exec(fn, study_id = study_id)), NA)

  expect_equal(names(res), names(endpoint_funs))

})

test_that("Missing study_id - arg throws an error", {

  skip_on_cran()
  skip_if(httr::http_error("www.cbioportal.org/api"))

  db_test <- "public"
  set_cbioportal_db(db = db_test)

  study_id = NULL
  endpoint_funs <- c(available_clinical_attributes = available_clinical_attributes,
                     get_clinical_by_study = get_clinical_by_study,
                     get_study_info = get_study_info,
                     available_samples = available_samples,
                     available_patients = available_patients,
                     available_sample_lists = available_sample_lists,

                     get_mutations_by_study = get_mutations_by_study,
                     get_cna_by_study = get_cna_by_study,
                     get_fusions_by_study = get_fusions_by_study
                     # throws a message instead
#                     get_genetics_by_study = get_genetics_by_study
                     )

  # **is there a better way??!?!

  purrr::map(endpoint_funs, function(fn) {
    expect_error(rlang::exec(fn), "*")
  })


})


test_that("Incorrect study_id - API error", {

  skip_on_cran()
  skip_if(httr::http_error("www.cbioportal.org/api"))

  db_test <- "public"
  set_cbioportal_db(db = db_test)
  study_id = "blerg"

  endpoint_funs <- c(available_clinical_attributes = available_clinical_attributes,
                     get_clinical_by_study = get_clinical_by_study,
                     get_study_info = get_study_info,
                     available_samples = available_samples,
                     available_patients = available_patients,
                     available_sample_lists = available_sample_lists,

                     get_mutations_by_study = get_mutations_by_study,
                     get_cna_by_study = get_cna_by_study,
                     get_fusions_by_study = get_fusions_by_study
 #                    get_genetics_by_study = get_genetics_by_study - handled differently
                     )

  purrr::map(endpoint_funs, function(fn) {
    expect_error(rlang::exec(fn, study_id = study_id), "API request failed*")
  })


})



test_that("Missing study_id - arg defaults to sensible database value, no error", {

  skip_on_cran()
  skip_if(httr::http_error("www.cbioportal.org/api"))

  db_test <- "public"
  set_cbioportal_db(db = db_test)

  study_id = NULL
  endpoint_funs <- c(available_profiles = available_profiles)


  purrr::map(endpoint_funs, function(fn) {
    expect_error(rlang::exec(fn), NA)
  })


})


test_that("More than 1 study_id - throws an error", {

  skip_on_cran()
  skip_if(httr::http_error("www.cbioportal.org/api"))

  db_test <- "public"
  set_cbioportal_db(db = db_test)
  study_id = c("mpnst_mskcc", "prad_msk_2019")

  endpoint_funs <- c(available_profiles = available_profiles,
                     available_clinical_attributes = available_clinical_attributes,
                     get_clinical_by_study = get_clinical_by_study,
                     get_study_info = get_study_info,
                     available_samples = available_samples,
                     available_patients = available_patients,
                     available_sample_lists = available_sample_lists,

                     get_mutations_by_study = get_mutations_by_study,
                     get_cna_by_study = get_cna_by_study,
                     get_fusions_by_study = get_fusions_by_study,
                     get_genetics_by_study = get_genetics_by_study
                     )

  purrr::map(endpoint_funs, function(fn) {
    expect_error(rlang::exec(fn, study_id = study_id), "*")
  })


})

test_that("available_samples() works with sample_list_id", {

  skip_on_cran()
  skip_if(httr::http_error("www.cbioportal.org/api"))

  db_test <- "public"
  set_cbioportal_db(db = db_test)

  expect_error(x <- available_samples(sample_list_id = "prad_msk_2019_cna"), NA)
  expect_error(y <- available_samples(sample_list_id = "prad_msk_2019_cna",
                                 study_id = "something_ignored"), NA)

  expect_equal(x, y)

  })


# * Clinical Data  -----------------

test_that("Clinical data by study- no attribute, defaults to all", {

  skip_on_cran()
  skip_if(httr::http_error("www.cbioportal.org/api"))

  db_test <- "public"
  set_cbioportal_db(db = db_test)
  study_id = "acc_tcga"

  expect_message(get_clinical_by_study(study_id = study_id), "*all clinical attributes")

})

test_that("Clinical data by study- 1 attribute ", {

  skip_on_cran()
  skip_if(httr::http_error("www.cbioportal.org/api"))

  db_test <- "public"
  set_cbioportal_db(db = db_test)
  study_id = "acc_tcga"
  clinical_attribute = c("CANCER_TYPE")

  expect_error(
    get_clinical_by_study(study_id = study_id,
                          clinical_attribute), NA)

  res <- get_clinical_by_study(study_id = study_id,
                        clinical_attribute)

  expect_equal(unique(res$clinicalAttributeId), clinical_attribute)
})

test_that("Clinical data by study- 2 attributes ", {

  skip_on_cran()
  skip_if(httr::http_error("www.cbioportal.org/api"))

  db_test <- "public"
  set_cbioportal_db(db = db_test)
  study_id = "acc_tcga"
  clinical_attribute = c("CANCER_TYPE", "SAMPLE_TYPE")

  expect_error(
    get_clinical_by_study(study_id = study_id,
                          clinical_attribute), NA)

  res <- get_clinical_by_study(study_id = study_id,
                               clinical_attribute)

  expect_equal(sort(unique(res$clinicalAttributeId)), sort(clinical_attribute))
})

test_that("Clinical data by study- returns patient and sample level ", {

  skip_on_cran()
  skip_if(httr::http_error("www.cbioportal.org/api"))

  db_test <- "public"
  set_cbioportal_db(db = db_test)
  study_id = "acc_tcga"
  clinical_attribute = c("CANCER_TYPE", "SAMPLE_TYPE", "AGE")

  expect_no_error(
    res <- get_clinical_by_study(study_id = study_id,
                          clinical_attribute))


  expect_equal(sort(unique(res$clinicalAttributeId)), sort(clinical_attribute))
  expect_equal(sum(is.na(res$sampleId)), sum(res$dataLevel == "PATIENT"))

})

