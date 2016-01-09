# ORES API client
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/ores)](http://cran.r-project.org/package=ores) ![downloads](http://cranlogs.r-pkg.org/badges/grand-total/ores)

`ores` provides an API client for the Objective Revision Evaluation Service; an AI system designed to identify whether edits to Wikimedia projects like Wikipedia are damaging, likely to be reverted, or made in good faith, and what class of quality the underlying article falls into.

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

## Installation

`ores` can be obtained from CRAN with:

> install.packages("ores")

The package also lives on GitHub; you can install it with:

> devtools::install_github("ironholds/ores")

## Dependencies

* R
* httr
* Love