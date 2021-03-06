# --------------------------------------------- #
                # Package Checking
# --------------------------------------------- #

# Routine Checks --------------------------------

# Load the package
devtools::load_all()

# Run a R CMD check
devtools::check()

# Update documentation
devtools::document()

# Creating a Vignette ---------------------------

# Can create the necessary components using `usethis`
# usethis::use_vignette(name = "my_vignette")
## 1) Creates 'vignettes/' directory
## 2) Adds needed dependencies to DESCRIPTION (e.g., `knitr`)
## 3) Drafts a vignette: "vignettes/{name}.Rmd"

# Releasing to CRAN -----------------------------

# CRAN Repository Policy here:
## https://cran.r-project.org/web/packages/policies.html

# General info about releasing process here:
## https://r-pkgs.org/release.html

# Simplest way is to invoke devtools again
# devtools::release()

# Can also manually submit via CRAN's portal:
## https://cran.r-project.org/submit.html

# Getting Started -------------------------------
## Now unnecessary but good for next time!

# Create a README for easy GitHub rendering
# usethis::use_readme_rmd()

# Adding R-CMD check badge
# usethis::use_github_action_check_standard()

# ***

# Need a NEWS.md file!

# ***

# Reverse Dependency Checking -------------------
## Currently unnecessary but good to save for when updates are released

# Create a template for checking downstream dependencies
# usethis::use_revdep()

# For more information on this see:
## https://r-lib.github.io/revdepcheck/

# End ----
