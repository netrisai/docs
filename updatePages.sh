#!/bin/bash
set -x

###################
# INSTALL DEPENDS #
###################

apt-get update
apt-get -y install git git-lfs rsync python3-pip python3-virtualenv python3-setuptools

python3 -m pip install --upgrade sphinx-rtd-theme==3.0.2 importlib-metadata==8.7.0 gitpython docutils==0.21.2 rinohtype pygments sphinx-copybutton sphinx-tabs

#######################################
# SILENCE ALL SAFE.DIRECTORY WARNINGS #
#######################################

git config --global --add safe.directory '*'

#####################
# DECLARE VARIABLES #
#####################

pwd
env
ls -lah
export SOURCE_DATE_EPOCH=$(git log -1 --pretty=%ct)

# make a new temp dir which will be our GitHub Pages docroot
docroot=`mktemp -d`

##############
# BUILD DOCS #
##############

# first, cleanup any old builds' static assets
make clean

# get a list of branches, excluding 'HEAD' and 'gh-pages'
versions="`git for-each-ref '--format=%(refname:lstrip=-1)' refs/remotes/origin/ | grep -viE '^(HEAD|gh-pages)$'`"

for current_version in ${versions}; do

	# make the current language available to conf.py
	export current_version
	git checkout -B ${current_version} refs/remotes/origin/${current_version}

	# rename "master" to "latest"
	if [[ "${current_version}" == "master" ]]; then
		current_version="latest"
	fi

	echo "INFO: Building sites for ${current_version}"

	# skip this branch if it doesn't have our dir & sphinx config
	if [ ! -e 'conf.py' ]; then
		echo -e "\tINFO: Couldn't find 'conf.py' (skipped)"
		continue
	fi

	languages="en"

  ##########
  # BUILDS #
  ##########
  echo "INFO: Building for ${languages}"
  
  # HTML #
  sphinx-build -b html . _build/html/${languages}/${current_version} -D language="${languages}"

  # PDF #
#   sphinx-build -b rinoh . _build/rinoh -D language="${languages}"
  touch _build/rinoh/ReadtheDocsTemplate.pdf
  mkdir -p "${docroot}/manifests/${languages}/${current_version}"
  cp "_build/rinoh/ReadtheDocsTemplate.pdf" "${docroot}/manifests/${languages}/${current_version}/netris-docs_${languages}_${current_version}.pdf"

  # EPUB #
#   sphinx-build -b epub . _build/epub -D language="${languages}"
  touch _build/epub/Netrisdocs.epub
  mkdir -p "${docroot}/manifests/${languages}/${current_version}"
  cp "_build/epub/Netrisdocs.epub" "${docroot}/manifests/${languages}/${current_version}/netris-docs_${languages}_${current_version}.epub"

  # copy the static assets produced by the above build into our docroot
  rsync -av "_build/html/" "${docroot}/"

done

# return to master branch
git checkout master

#######################
# Update GitHub Pages #
#######################

git config --global user.name "${GITHUB_ACTOR}"
git config --global user.email "${GITHUB_ACTOR}@users.noreply.github.com"

pushd "${docroot}"

# don't bother maintaining history; just generate fresh
git init
git remote add deploy "https://token:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
git checkout -b gh-pages


# add .nojekyll to the root so that github won't 404 on content added to dirs
# that start with an underscore (_), such as our "_content" dir..
touch .nojekyll

# add redirect (for now) since I want repo-specific docs dirs, but we only have one so far
cat >> index.html <<EOF
<!DOCTYPE html>
<html>
   <head>
      <title>Netris Docs</title>
      <meta http-equiv = "refresh" content="0; url=https://www.netris.io/docs/" />   
   </head>
   <body>
      <p>Please wait while you're redirected to our <a href="/">netris documentation page</a>.</p>
   </body>
</html>
EOF

# Add README
cat >> README.md <<EOF
# GitHub Pages Cache

Nothing to see here. The contents of this branch are essentially a cache that's not intended to be viewed on github.com.

You can view the actual documentation as it's intended to be viewed at [https://netris.io/docs/](https://netris.io/docs/)

If you're looking to update our documentation, check the relevant development branch's ['docs'](https://github.com/netrisai/docs).
EOF

# Clean UP current lfs
git-lfs uninstall

# Install the Git Large File Storage (git-lfs)
git-lfs install

# Select the file types to be tracked by lfs
git lfs track "*.pdf"
git lfs track "*.epub"

# copy the resulting html pages built from sphinx above to our new git repo
git add .

# commit all the new files
msg="Updating Docs for commit ${GITHUB_SHA} made on `date -d"@${SOURCE_DATE_EPOCH}" --iso-8601=seconds` from ${GITHUB_REF}"
git commit -am "${msg}"

# overwrite the contents of the gh-pages branch on our github.com repo
git push deploy gh-pages --force

popd # return to main repo sandbox root

##################
# CLEANUP & EXIT #
##################

# exit cleanly
exit 0
