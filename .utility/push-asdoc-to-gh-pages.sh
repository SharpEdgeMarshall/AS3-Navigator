#!/bin/bash

if [ "$TRAVIS_REPO_SLUG" == "SharpEdgeMarshall/AS3-Navigator" ] && [ "$TRAVIS_PULL_REQUEST" == "false" ] && [ "$TRAVIS_BRANCH" == "master" ]; then

  echo -e "Publishing asdoc...\n"

  cp -R target/asdoc $HOME/asdoc-latest

  cd $HOME
  git config --global user.email "travis@travis-ci.org"
  git config --global user.name "travis-ci"
  git clone --quiet --branch=gh-pages https://${GH_TOKEN}@github.com/SharpEdgeMarshall/AS3-Navigator gh-pages > /dev/null

  cd gh-pages
  git rm -rf ./asdoc
  cp -Rf $HOME/asdoc-latest ./asdoc
  git add -f .
  git commit -m "Lastest asdoc on successful travis build $TRAVIS_BUILD_NUMBER auto-pushed to gh-pages"
  git push -fq origin gh-pages > /dev/null

  echo -e "Published asdoc to gh-pages.\n"
  
fi
