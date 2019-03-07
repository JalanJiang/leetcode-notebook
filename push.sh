cur_date=$(date +%Y-%m-%d)
echo $cur_date
sudo gitbook build
git add *
git commit -m "$cur_date"
git push origin master
git subtree push --prefix=_book origin gh-pages
