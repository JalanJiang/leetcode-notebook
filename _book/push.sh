#cur_date=$(date +%Y-%m-%d)
message=$1
echo $message
sudo gitbook build
git add *
git commit -m "$message"
git push origin master
# git subtree push --prefix=_book origin gh-pages
git push origin `git subtree split --prefix=_book master`:gh-pages --force
