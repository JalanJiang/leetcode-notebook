message=$1

# 拉取更新
git pull

# 复制 README.md
cp README.md docs/README.md

# 更新 master
git add .
git commit -m "$message"
git push git@github.com:JalanJiang/leetcode-notebook.git master

# 更新 gh-pages
cd docs/
# 拉取更新
git pull
git init
git add -A
git commit -m "$message"
git push -f git@github.com:JalanJiang/leetcode-notebook.git master:gh-pages