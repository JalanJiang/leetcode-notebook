## 循环单词

[原题链接](https://www.nowcoder.com/questionTerminal/9d5fbe7750a34d0b91c73943f93b2d7d)

### 题目

如果一个单词通过循环右移获得的单词，我们称这些单词都为一种循环单词。 例如：picture 和 turepic 就是属于同一种循环单词。 现在给出n个单词，需要统计这个n个单词中有多少种循环单词。 
输入描述:
输入包括n+1行：

第一行为单词个数n(1 ≤ n ≤ 50)

接下来的n行，每行一个单词 `word[i]`，长度 `length`(1 ≤ `length` ≤ 50)。由小写字母构成

输出描述:

输出循环单词的种数

示例1

    输入
        5
        picture
        turepic
        icturep
        word
        ordw

    输出
        2

### 解题思路

- 构造一个新的 `letter_list` 为 `letter + letter`
- 循环判断每一个单词是否符合循环单词的标准
    - 单词长度是否相同
    - `letter2` 是否存在于 `letter1 + letter1`  

### Python

```python
# -*- coding: utf-8 -*-

import sys

class String:
    def get_res(self, letter_list):
        count = 0
        f_letter_list = []
        check_letter_list = []
        for letter in letter_list:
            f_letter_list.append(letter + letter)
            check_letter_list.append(0)

        for f_index, f_letter in enumerate(f_letter_list):
            if check_letter_list[f_index] == 0:
                for index in range(f_index + 1, len(letter_list)):
                    if (len(letter_list[index]) == len(letter_list[f_index])) and (f_letter.count(letter_list[index])):
                        check_letter_list[index] = 1
                count = count + 1
        print count


if __name__ == '__main__':
    n = int(sys.stdin.readline())
    letter_list = []
    for i in range(0, n):
        letter_list.append(str(sys.stdin.readline()).replace('\n', ''))
    s = String()
    s.get_res(letter_list)

```