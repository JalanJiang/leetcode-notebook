message=$1

# 更新 master
git add .
git commit -m "$message"
git push -f git@github.com:JalanJiang/leetcode-notebook.git master

# 更新 gh-pages
cd docs/
git init
git add -A
git commit -m "$message"
git push -f git@github.com:JalanJiang/leetcode-notebook.git master:gh-pages