# --------------------------------------------- #
                # Package Checking
# --------------------------------------------- #

# Load the package
devtools::load_all()

# Run a R CMD check
devtools::check()

# Update documentation
devtools::document()

# Create a template for checking downstream dependencies
# usethis::use_revdep()
## Currently unnecessary but good to save for when updates are released

# End ----
