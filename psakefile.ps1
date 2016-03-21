#Requires -Module psake

task Build {
    jekyll build
}

task Serve {
    jekyll serve --no-watch
}