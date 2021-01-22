#!/bin/bash
set -x

###################
# INSTALL DEPENDS #
###################

apt-get update
apt-get -y install git rsync python3-sphinx python3-sphinx-rtd-theme python3-stemmer python3-git python3-pip python3-virtualenv python3-setuptools

python3 -m pip install --upgrade rinohtype pygments

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
# versions="`git for-each-ref '--format=%(refname:lstrip=-1)' refs/remotes/origin/ | grep -viE '^(HEAD|gh-pages)$'`"
versions="`git for-each-ref '--format=%(refname:lstrip=-1)' refs/remotes/origin/ | grep -viE '^(HEAD|gh-pages|master)$'`"   # [todo] remove after merge to master

for current_version in ${versions}; do

	# make the current language available to conf.py
	export current_version
	git checkout -B ${current_version} refs/remotes/origin/${current_version}

	# rename "deploy-gh-pages-ci" to "stable"
	if [[ "${current_version}" == "deploy-gh-pages-ci" ]]; then
		current_version="stable"
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
  sphinx-build -b rinoh . _build/rinoh -D language="${languages}"
  mkdir -p "${docroot}/${languages}/${current_version}"
  cp "_build/rinoh/target.pdf" "${docroot}/${languages}/${current_version}/netris-docs_${languages}_${current_version}.pdf"

  # EPUB #
  sphinx-build -b epub _build/epub -D language="${languages}"
  mkdir -p "${docroot}/${languages}/${current_version}"
  cp "_build/epub/target.epub" "${docroot}/${languages}/${current_version}/netris-docs_${languages}_${current_version}.epub"

  # copy the static assets produced by the above build into our docroot
  rsync -av "_build/html/" "${docroot}/"

done

# return to deploy-gh-pages-ci branch
git checkout deploy-gh-pages-ci

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

# Add CNAME - this is required for GitHub to know what our custom domain is
echo "docs.netris.dev" > CNAME

# add .nojekyll to the root so that github won't 404 on content added to dirs
# that start with an underscore (_), such as our "_content" dir..
touch .nojekyll

# add redirect (for now) since I want repo-specific docs dirs, but we only have one so far
cat >> index.html <<EOF
<!DOCTYPE html>
<html>
   <head>
      <title>Netris Docs</title>
      <meta http-equiv = "refresh" content="0; url='/en/stable/'" />
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

You can view the actual documentation as it's intended to be viewed at [https://docs.netris.dev/](https://docs.netris.dev/)

If you're looking to update our documentation, check the relevant development branch's ['docs' dir](https://github.com/netrisai/docs).
EOF

# copy the resulting html pages built from sphinx above to our new git repo
git add .

# commit all the new files
msg="Updating Docs for commit ${GITHUB_SHA} made on `date -d"@${SOURCE_DATE_EPOCH}" --iso-8601=seconds` from ${GITHUB_REF}"
git commit -am "${msg}"

# overwrite the contents of the gh-pages branch on our github.com repo
# git push deploy gh-pages --force

popd # return to main repo sandbox root

##################
# CLEANUP & EXIT #
##################

# exit cleanly
exit 0
