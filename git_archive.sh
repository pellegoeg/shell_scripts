#!/bin/bash

# List of repositories to clone and archive
repos=()
url="git@git.its.aau.dk:"

for repo in "${repos[@]}"; do
  # Clone the repository using git clone
  git clone "$url""$repo"

  # Go to the newly cloned repository
  cd "${repo##*/}"

  # Create a tar.gz archive of the repository's history
  git archive --format=tar.gz --prefix=${repo##*/}/ HEAD > "../${repo##*/}.tar.gz"

  # Clean up by removing the cloned repository
  cd ..
  rm -rf "${repo##*/}"
done
