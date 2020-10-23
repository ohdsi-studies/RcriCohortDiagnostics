# Copyright 2020 Observational Health Data Sciences and Informatics
#
# This file is part of examplePackage
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

packageName <- "RcriCohortDiagnostics"

# Format and check code ---------------------------------------------------
# OhdsiRTools::formatRFolder()
# OhdsiRTools::checkUsagePackage(packageName)
# OhdsiRTools::updateCopyrightYearFolder()

# Create manual -----------------------------------------------------------
# shell("rm extras/Ohdsi2020StudyathonCohortDiagnostics.pdf")
# shell("R CMD Rd2pdf ./ --output=extras/Ohdsi2020StudyathonCohortDiagnostics.pdf")

baseUrl <- "http://Ohdsicovid19us.us-east-1.elasticbeanstalk.com/WebAPI/"
library(magrittr)

allCohorts <- ROhdsiWebApi::getCohortDefinitionsMetaData(baseUrl = baseUrl)

RcriCohortDiagnostics <- allCohorts %>% 
  dplyr::filter(id %in% c(1373,1364,1367,1339, 1374,1290,1343, 1293, 1287, 1292, 1291, 1362,
                          1414,1415,1416,1417,1418,1419,1420,1421,1422,1423,1424,1425,1426,
                          1427,1428,1429,1430,1431,1432,1433,1434,1435,1436,1437,1438,1439,
                          1440,1441,1442,1443,1444,1445,1446,1447,1448)) %>%
  dplyr::select(.data$id, .data$name, .data$description) %>% dplyr::mutate(phenotypeId = 0,
                                                                           webApiCohortId = id,
                                                                           atlasId = id,
                                                                           cohortName = name,
                                                                           name = id,
                                                                           logicDescription = description,
                                                                           cohortId = id) %>% dplyr::select(.data$phenotypeId,
                                                                                                            .data$webApiCohortId,
                                                                                                            .data$atlasId,
                                                                                                            .data$cohortName,
                                                                                                            .data$name,
                                                                                                            .data$logicDescription,
                                                                                                            .data$cohortId)

readr::write_excel_csv(x = RcriCohortDiagnostics,
                       file = "inst/settings/CohortsToCreate.csv",
                       na = "")

# Insert cohort definitions from ATLAS into package -----------------------
ROhdsiWebApi::insertCohortDefinitionSetInPackage(fileName = "inst/settings/CohortsToCreate.csv",
                                                 baseUrl = baseUrl,
                                                 insertTableSql = TRUE,
                                                 insertCohortCreationR = TRUE,
                                                 generateStats = TRUE,
                                                 packageName = packageName)
