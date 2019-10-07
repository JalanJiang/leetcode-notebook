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


## 3. 无重复字符的最长子串

[原题链接](https://leetcode-cn.com/problems/longest-substring-without-repeating-characters/solution/)

### 思路

- 用 hash 记录每个字符出现的位置
- 当前字符：
    - 已经出现过了，且在当前字符串内：
        - 移动字符串起始位置为 `s_dict[cur_c] + 1`（跳过这个重复字串）
    - 还未出现：记录当前字符串的位置下标
- 计算当前字符串长度为 `i - start + 1`（当前位置 - 起始位置 + 1）
- 判断该长度为 max_length 的关系

```python
class Solution(object):
    def lengthOfLongestSubstring(self, s):
        """
        :type s: str
        :rtype: int
        """
        s_dict = dict()
        start = 0
        max_length = 0
        for i in range(len(s)):
            cur_c = s[i]
            if cur_c not in s_dict:
                s_dict[cur_c] = i
            else:
                if s_dict[cur_c] >= start:
                    start = s_dict[cur_c] + 1
                s_dict[cur_c] = i
            max_length = max(max_length, i - start + 1)
        return max_length
```


## 6. Z 字形变换

[原题链接](https://leetcode-cn.com/problems/zigzag-conversion/)

### 思路

模拟过程：

1. 从第一行开始垂直向下走，即走从 `1` 走到 `numRows`
2. 到了最后一行后垂直向上走，从 `numRows` 再走回 `1`

循环这个过程。设置一个行走方向值 `forward`，当到达边界值时回头即可。

```python
class Solution(object):
    def convert(self, s, numRows):
        """
        :type s: str
        :type numRows: int
        :rtype: str
        """
        d = dict()
        index = 0
        forward = 1
        for c in s:
            if index not in d:
                d[index] = ""
            d[index] += c

            if index == numRows - 1:
                forward = -1
            if index == 0:
                forward = 1
            
            index += forward
        
        res = ""
        for index in d:
            res += d[index]
        return res
```


## 7. 整数反转

[原题链接](https://leetcode-cn.com/problems/reverse-integer/comments/)

### 思路

- 将数字转为字符串
- 通过 头尾双指针+两两交换 实现翻转
- 检查结果数的数值范围，判断是返回结果还是返回 0

```python
class Solution(object):
    def reverse(self, x):
        """
        :type x: int
        :rtype: int
        """
        negative = False
        if x < 0:
            negative = True
            x = -x

        x = list(str(x))
        i = 0
        j = len(x) - 1
        
        while i <= j:
            x[i], x[j] = x[j], x[i]
            i = i + 1
            j = j - 1
            
        x = int("".join(x))
        if negative == True:
            x = -x
        
        if x >= -2**31 and x <= 2**31 - 1:
            return x
        else:
            return 0
```


## 8. 字符串转换整数 (atoi)

[原题链接](https://leetcode-cn.com/problems/string-to-integer-atoi/)

### 思路

1. 寻找第一个有效字符
    - `"+"`：该数为正数
    - `"-"`：该数为负数
    - 数字：该数为正数
    - `" "`：继续往下寻找
    - 非以上字符：直接返回 `0`
2. 找到第一个有效字符后，将字符后所有数字进行拼接
    

代码可以说是写的很丑了。。。

```python
class Solution(object):
    def myAtoi(self, str):
        """
        :type str: str
        :rtype: int
        """
        begin = 0
        is_negative = 0
        res = ''
        for s in str:
            if begin == 0:
                
                if s == " ":
                    continue
                    
                if s == "-":
                    begin = 1
                    is_negative = 1
                    continue
                
                if s == "+":
                    begin = 1
                    continue
                
                if s.isdigit():
                    res += s
                    begin = 1
                else:
                    return 0
                    
            else:
                
                if s.isdigit():
                    res += s
                else:
                    break
        
        if res == "":
            return 0
        
        res = int(res)
        if is_negative == 1:
            res = -res
            if res < -(2**31):
                return -(2**31)
            else:
                return res
        else:
            if res > 2**31 - 1:
                return 2**31 - 1
            else:
                return res
```

优化一下：

```python
class Solution(object):
    def myAtoi(self, str):
        """
        :type str: str
        :rtype: int
        """
        
        length = len(str)
        if length == 0:
            return 0
        
        # 寻找第一个有效字符
        for i in range(length):
            if str[i] == " ":
                continue
            else:
                break
        
        res = ''
        begin = str[i]
        sign = 1
        if begin.isdigit():
            res += begin
        else:
            if begin == "-":
                sign = -1
            elif begin == "+":
                sign = 1
            else:
                return 0
        
        # 后续拼接
        for j in range(i + 1, length):
            if str[j].isdigit():
                res += str[j]
            else:
                break
                
        if res == '':
            return 0
        
        res = int(res) * sign
        if res > 2**31 - 1:
            return 2**31 - 1
        elif res < -(2**31):
            return -(2**31)
        else:
            return res
```


## 9. 回文数

[原题链接](https://leetcode-cn.com/problems/palindrome-number/submissions/)

### 思路

- 将整数分为左右两部分
- 右边部分进行转置
- 判断两部分是否相等

```python
class Solution(object):
    def isPalindrome(self, x):
        """
        :type x: int
        :rtype: bool
        """
        if x == 0:
            return True
        if x < 0 or x % 10 == 0:
            return False
        
        rev = 0
        while x > rev:
            rev = rev * 10 + x % 10
            x = x // 10
        return x == rev or x == rev // 10
```


## 12. 整数转罗马数字

[原题链接](https://leetcode-cn.com/problems/integer-to-roman/)

### 思路

就是根据罗马字符串的产生规律进行字符串的拼接。从个位开始往高位不断加入新的罗马字符，我这里用 `position` 来标记数字所在位：
 
- 1: 表示个位
- 10: 表示十位
- 100: 表示百位
- 1000: 表示千位

将罗马数字的组合放入一个字典中存储。

```python
class Solution(object):
    def intToRoman(self, num):
        """
        :type num: int
        :rtype: str
        """
        num_dict = {
            1: {1: 'I', 5: 'V', 4: 'IV', 9: 'IX'},
            10: {1: 'X', 5: 'L', 4: 'XL', 9: 'XC'},
            100: {1: 'C', 5: 'D', 4: 'CD', 9: 'CM'},
            1000: {1: 'M'}
        }
        
        # 从个位开始
        position = 1
        res = ''
        while num:
            position_num = num % 10
            cur = ''
            if position_num == 0:
                pass
            elif position_num < 5:
                if position_num == 4:
                    cur = num_dict[position][4]
                else:
                    one_count = position_num
                    while one_count:
                        cur += num_dict[position][1]
                        one_count -= 1
            elif position_num == 5:
                cur = num_dict[position][5]
            else:
                if position_num == 9:
                    cur = num_dict[position][9]
                else:
                    one_count = position_num - 5
                    cur = num_dict[position][5]
                    while one_count:
                        cur += num_dict[position][1]
                        one_count -= 1
            res = cur + res
            num //= 10
            position *= 10
        
        return res
```

在题解区看到了大佬的写法：

```python
class Solution:
    def intToRoman(self, num: int) -> str:
        lookup = {
            1:'I',
            4:'IV',
            5:'V',
            9:'IX',
            10:'X',
            40:'XL',
            50:'L',
            90:'XC',
            100:'C',
            400:'CD',
            500:'D',
            900:'CM',
            1000:'M'     
        }
        res = ""
        for key in sorted(lookup.keys())[::-1]:
            a = num // key
            if a == 0:
                continue
            res += (lookup[key] * a)
            num -= a * key
            if num == 0:
                break
        return res
```


## 13. 罗马数字转整数

[原题链接](https://leetcode-cn.com/problems/roman-to-integer/)

### 思路

判断相邻元素，如果左边小于右边，则减去，否则一路相加。

```python
class Solution(object):
    def romanToInt(self, s):
        """
        :type s: str
        :rtype: int
        """
        num_dict = {"I": 1, "V": 5, "X": 10, "L": 50, "C": 100, "D":500, "M": 1000}
        
        res = 0
        s_list = list(s)
        
        for i in range(1, len(s_list)):
            c1 = s_list[i - 1]
            c2 = s_list[i]
            if num_dict[c1] < num_dict[c2]:
                res = res - num_dict[c1]
            else:
                res = res + num_dict[c1]

        res = res + num_dict[s_list[-1]]
        return res
        
```


## 14. 最长公共前缀
   
[原题链接](https://leetcode-cn.com/problems/longest-common-prefix/submissions/)

### 思路

- 先找出最短的字符串
- 取字符串的第一个字符为字符串 1，开始循环判断这个字符串 1 是否为其他字符串的子串
    - 如果是，开始取前两个字符为字符串 2 ，继续判断。。。

```python
class Solution:
    def longestCommonPrefix(self, strs):
        """
        :type strs: List[str]
        :rtype: str
        """
        if not strs:
            return ""
        if len(strs) == 1:
            return strs[0]
        #minl = min([len(x) for x in strs])
        minl = 1000
        for x in strs:
            if len(x) < minl:
                minl = len(x)
        end = 0
        while end < minl:
            for i in range(1,len(strs)):
                if strs[i][end]!= strs[i-1][end]:
                    return strs[0][:end]
            end += 1
        return strs[0][:end]
```


## 28. 实现strStr()

[原题链接](https://leetcode-cn.com/problems/implement-strstr/)

> 当 needle 是空字符串时，我们应当返回什么值呢？这是一个在面试中很好的问题。
> 对于本题而言，当 needle 是空字符串时我们应当返回 0 。这与C语言的 strstr() 以及 Java的 indexOf() 定义相符。

### 思路

暴力破解，第一次写的时候没有注意细节导致了超时，超时代码如下：

```python
class Solution(object):
    def strStr(self, haystack, needle):
        """
        :type haystack: str
        :type needle: str
        :rtype: int
        """
        n_length = len(needle)
        h_length = len(haystack)
        if n_length > h_length:
            return -1
        if n_length == 0:
            return 0
        
        for i in range(len(haystack)):
            if haystack[i] == needle[0]:
                t = True
                for j in range(1, n_length):
                    if i + j >= h_length:
                        t = False
                        break # 其实这里可以直接返回-1了
                    if haystack[i+j] != needle[j]:
                        t = False
                        break
                if t == True:
                    return i
        
        return -1                 
```

改一下：

```python
class Solution(object):
    def strStr(self, haystack, needle):
        """
        :type haystack: str
        :type needle: str
        :rtype: int
        """
        n_length = len(needle)
        h_length = len(haystack)
        if n_length > h_length:
            return -1
        if n_length == 0:
            return 0
        
        for i in range(len(haystack)):
            if haystack[i] == needle[0]:
                t = True
                for j in range(1, n_length):
                    if i + j >= h_length:
                        return -1
                    if haystack[i+j] != needle[j]:
                        t = False
                        break
                if t == True:
                    return i
        
        return -1
```


## 38. 报数

[原题链接](https://leetcode-cn.com/problems/count-and-say/)

### 思路

暴力。根据前一个字符串的情况计算出下一个字符串的情况，核心思想就是比较相邻的两个字符是否是连续的数字。

```python
class Solution(object):
    def countAndSay(self, n):
        """
        :type n: int
        :rtype: str
        """
        if n == 1:
            return "1"
        if n == 2:
            return "11"
        
        pre = "11"
        begin = 3
        while begin <= n:
            res = list()
            i = 0
            count = 1
            while i < len(pre):
                if i + 1 < len(pre):
                    if pre[i] == pre[i + 1]:
                        count = count + 1
                    else:
                        res.append(str(count))
                        res.append(pre[i])
                        count = 1
                else:
                    res.append(str(count))
                    res.append(pre[i])
                i += 1
            pre = res
            begin += 1
        return "".join(res)
```


## 43. 字符串相乘

[原题链接](https://leetcode-cn.com/problems/multiply-strings/)

### 思路

模拟乘法。模拟了小学数学的列竖式，从末尾数字开始计算乘积。

```python
class Solution(object):
    def multiply(self, num1, num2):
        """
        :type num1: str
        :type num2: str
        :rtype: str
        """
        if num1 == '0' or num2 == '0':
            return '0'
        ans = 0
        for i, n1 in enumerate(num2[::-1]):
            pre = 0
            curr = 0
            for j, n2 in enumerate(num1[::-1]):
                multi = (ord(n1) - ord('0')) * (ord(n2) - ord('0'))
                first, second = multi // 10, multi % 10
                curr += (second + pre) * (10 ** j) 
                pre = first
            curr += pre * (10 ** len(num1))
            ans += curr * (10 ** i)
        return str(ans)
```

### 忍不住吐槽

这 tm 也可以过。。。

```python
class Solution(object):
    def multiply(self, num1, num2):
        """
        :type num1: str
        :type num2: str
        :rtype: str
        """
        return str(int(num1)*int(num2))
```


## 58. 最后一个单词的长度

[原题链接](https://leetcode-cn.com/problems/length-of-last-word/)

### 思路

- 遇到空格的下一位字母：重新开始计算单词长度
- 注意点：存在 `"a b    "` 末尾存在多个空格的情况（这种情况也可以先去除空格再计算）

```python
class Solution(object):
    def lengthOfLastWord(self, s):
        """
        :type s: str
        :rtype: int
        """
        s_list = list(s)
        s_length = len(s_list)
        last_length = 0
        res = 0
        for i in range(s_length):
            c = s_list[i]
            if c == " ":
                last_length = 0
            else:
                last_length += 1
            if last_length > 0:
                res = last_length
        return res
```

## 67. 二进制求和

[原题链接](https://leetcode-cn.com/problems/add-binary/)

### 解法一

Python 内置函数懒蛋解法。

```python
class Solution(object):
    def addBinary(self, a, b):
        """
        :type a: str
        :type b: str
        :rtype: str
        """
        return bin(int(a, 2) + int(b, 2))[2:]
```

### 解法二

把较短的字符串前端用零补齐。然后两个字符串按位相加。

```python
class Solution(object):
    def addBinary(self, a, b):
        """
        :type a: str
        :type b: str
        :rtype: str
        """
        dis_length = len(a) - len(b)
        if dis_length < 0:
            a = -(dis_length) * '0' + a
        else:
            b = dis_length * '0' + b
            
        res = ''
        pre = 0
        for i in range(len(a) - 1, -1, -1):
            a_c = a[i]
            b_c = b[i]
            cur = int(a_c) + int(b_c) + pre
            if cur >= 2:
                pre = 1
                cur %= 2
            else:
                pre = 0
            res = str(cur) + res
            
        if pre > 0:
            res = '1' + res
        
        return res
```

## 71. 简化路径

[原题链接](https://leetcode-cn.com/problems/simplify-path/)

### 思路

- 重复连续出现的'/'，只按1个处理，即跳过重复连续出现的'/'；
- 如果路径名是"."，则不处理；
- 如果路径名是".."，则需要弹栈，如果栈为空，则不做处理；
- 如果路径名为其他字符串，入栈。
- 最后，再逐个取出栈中元素（即已保存的路径名），用'/'分隔并连接起来，不过要注意顺序呦

```python
class Solution(object):
    def simplifyPath(self, path):
        """
        :type path: str
        :rtype: str
        """
        path_array = path.split("/")
        stack = []
        res_path = ""
        for item in path_array:
            if item not in ["",".",".."]:
                stack.append(item) 
            if ".." == item and stack: 
                stack.pop(-1)
        if []==stack: 
            return "/"
        for item in stack:
            res_path += "/"+item + ""
        return res_path
```

## 93. 复原IP地址

[原题链接](https://leetcode-cn.com/problems/restore-ip-addresses/)

### 思路

回溯法

```python
class Solution(object):
    def restoreIpAddresses(self, s):
        """
        :type s: str
        :rtype: List[str]
        """
        res = []
        self.dfs(s, [], res)
        return res
        
    def dfs(self, s, path, res):
        if len(s) > (4 - len(path)) * 3:
            return
        if not s and len(path) == 4:
            res.append('.'.join(path))
            return
        for i in range(min(3, len(s))):
            curr = s[:i+1]
            if (curr[0] == '0' and len(curr) >= 2) or int(curr) > 255:
                continue
            self.dfs(s[i+1:], path + [s[:i+1]], res)
```


## 125. 验证回文串

[原题链接](https://leetcode-cn.com/problems/valid-palindrome/)

### 思路

验证回文的思路：头尾双指针，验证字符是否相等。

```python
class Solution(object):
    def isPalindrome(self, s):
        """
        :type s: str
        :rtype: bool
        """
        s_length = len(s)
        if s_length <= 1:
            return True
        
        i = 0
        j = s_length - 1
        
        while i <= j:
            while (s[i].isalpha() != True and s[i].isdigit() != True) and i < j:
                i = i + 1
            
            while (s[j].isalpha() != True and s[j].isdigit() != True) and j > i:
                j = j - 1
            
            if s[i].lower() != s[j].lower():
                return False
            else:
                i = i + 1
                j = j - 1
        
        return True
```


## 139. 单词拆分

[原题链接](https://leetcode-cn.com/problems/word-break/)

### 思路

动态规划。`mark[i]` 用于表示以 `0 ~ i-1` 为下标范围的字符串能否被字典拆分。

- 双重循环
- 如果 `0 ~ j-1` 范围的字符串在字典中，即 `mark[j] = True`，那么此时：
    - 如果 `j ~ i` 范围的字符串也在字典中，则 `0 ~ i` 范围的字符串可以被字典拆分（拆分为 `0 ~ j-1` 与 `j ~ i`），标记 `mark[i] = True`
    - 如果 `j ~ i` 范围的字符串不在字典中，继续循环，判断 `mark[j + 1]` 与 `j+1 ~ i` 范围字符的情况

```python
class Solution(object):
    def wordBreak(self, s, wordDict):
        """
        :type s: str
        :type wordDict: List[str]
        :rtype: bool
        """
        mark = dict()
        mark[0] = True
        
        length = len(s)
        
        for i in range(1, length + 1):
            for j in range(i):
                if j in mark:
                    if mark[j] == True and (s[j:i] in wordDict):
                        mark[i] = True
                        break
                        
        if length in mark:
            return mark[length]
        else:
            return False
```


## 151. 翻转字符串里的单词

[原题链接](https://leetcode-cn.com/problems/reverse-words-in-a-string/comments/)

### 思路

```python
class Solution(object):
    def reverseWords(self, s):
        """
        :type s: str
        :rtype: str
        """
        s = s.strip() ## 去掉字符串首尾的所有空格
        s = s.split() ## 按任意连续的空格划分字符串，得到列表s
        s.reverse() ## 翻转列表s
        s = ' '.join(s) ##用一个空格把列表s连接成字符串 
        return s
```


## 165. 比较版本号

[原题链接](https://leetcode-cn.com/problems/compare-version-numbers/)

### 思路

- 按 `.` 分割两个字符串为列表
- 分别比较两个列表中对应位置数字的大小

```python
class Solution(object):
    def compareVersion(self, version1, version2):
        """
        :type version1: str
        :type version2: str
        :rtype: int
        """
        v1 = version1.split(".")
        v2 = version2.split(".")
        
        l1 = len(v1)
        l2 = len(v2)
        max_length = max(l1, l2)
        
        for i in range(max_length):
            if i >= l1:
                n1 = 0
            else:
                n1 = int(v1[i])
            
            if i >= l2:
                n2 = 0
            else:
                n2 = int(v2[i])
                
            if n1 > n2:
                return 1
            if n1 < n2:
                return -1
        return 0
```


## 205. 同构字符串

[原题连接](https://leetcode-cn.com/problems/isomorphic-strings/submissions/)

### 思路

- 判断 s 与 t 对应位置上的字母上一次出现的位置
- 若上一次出现的位置都相同，则为同构

```python
class Solution(object):
    def isIsomorphic(self, s, t):
        """
        :type s: str
        :type t: str
        :rtype: bool
        """
        s_dict = dict()
        t_dict = dict()
        
        index = 0
        for s_c in s:
            s_value = s[index]
            t_value = t[index]
            
            if s_value not in s_dict:
                s_dict[s_value] = 0
            s_pre_index = s_dict[s_value]
            
            if t_value not in t_dict:
                t_dict[t_value] = 0
            t_pre_index = t_dict[t_value]
            
            if s_pre_index != t_pre_index:
                return False
            
            s_dict[s_value] = index + 1
            t_dict[t_value] = index + 1
            index = index + 1
        
        return True
```


## 242. 有效的字母异位词
   
[原题链接](https://leetcode-cn.com/problems/valid-anagram/)

### 思路

- 统计 s 和 t 中所有字母出现的次数
- 判断是否相同

```python
class Solution(object):
    def isAnagram(self, s, t):
        """
        :type s: str
        :type t: str
        :rtype: bool
        """
        c_dict = dict()
        for c in s:
            if c in c_dict:
                c_dict[c] = c_dict[c] + 1
            else:
                c_dict[c] = 1
            
        for c in t:
            if c in c_dict:
                c_dict[c] = c_dict[c] - 1
            else:
                c_dict[c] = 1
        
        for c in c_dict:
            if c_dict[c] != 0:
                return False
            
        return True
```

### 顺便复习 Python 字典

创建字典

```python
c_dict = dict()
```

判断字典中是否存在某个 key 值

```
if key in c_dict:
    return True
```

遍历字典

```python
for key in c_dict:
    print c_dict[key]
    
for key, value in c_dict.items():
    print key, value
```


## 344. 反转字符串

[原题链接](https://leetcode-cn.com/problems/reverse-string/)

### 思路

头尾双指针，不停交换并往中间靠拢。

```python
class Solution(object):
    def reverseString(self, s):
        """
        :type s: List[str]
        :rtype: None Do not return anything, modify s in-place instead.
        """
        i = 0
        j = len(s) - 1
        
        while i <= j:
            tmp = s[i]
            s[i] = s[j]
            s[j] = tmp
            i = i + 1
            j = j - 1
```


## 345. 反转字符串中的元音字母

[原题链接](https://leetcode-cn.com/problems/reverse-vowels-of-a-string/)

### 思路

双指针

- i 指针从左到右
- j 指针从右到左
- 两个指针都指向元音字符时交换两个字符

```python
class Solution(object):
    def reverseVowels(self, s):
        """
        :type s: str
        :rtype: str
        """
        s = list(s)
        character_set = {'a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U'}
        
        i = 0
        j = len(s) - 1
        
        while i <= j:
            
            c_i = s[i]
            c_j = s[j]
            
            if c_i not in character_set:
                i = i + 1
            else:
                if c_j not in character_set:
                    j = j - 1
                else:
                    s[i] = c_j
                    s[j] = c_i
                    i = i + 1
                    j = j - 1
        return ''.join(s)
```

注：Python 字符串为不可变对象，需要转换为列表操作

字符串->列表

```python
s = list[s]
```

列表->字符串

```python
''.join(s)
```


## 387. 字符串中的第一个唯一字符

[原题链接](https://leetcode-cn.com/problems/first-unique-character-in-a-string/)

### 思路

用字典存储每个字符出现的次数，最后再遍历一次判断出现次数是否为 1 ，是 1 则返回。


```python
class Solution(object):
    def firstUniqChar(self, s):
        """
        :type s: str
        :rtype: int
        """
        hash_map = dict()
        for c in s:
            if c not in hash_map:
                hash_map[c] = 1
            else:
                hash_map[c] += 1
        
        for i in range(len(s)):
            c = s[i]
            if c in hash_map and hash_map[c] == 1:
                return i
        
        return -1
```


## 409. 最长回文串

[原题链接](https://leetcode-cn.com/problems/longest-palindrome/submissions/)

### 思路

构成回文串的条件：字母出现偶数次，允许有一个奇数次（1次）字母在中间。

- 统计所有字母出现次数
- 遍历统计结果
    - 出现偶数次的字母：length + 字母出现次数
    - 出现奇数次的字母：length + 字母出现次数 - 1
    - 将出现奇数次的字母加一个在中间：length + 1


```python
class Solution(object):
    def longestPalindrome(self, s):
        """
        :type s: str
        :rtype: int
        """
        c_dict = dict()
        
        for c in s:
            if c in c_dict:
                c_dict[c] = c_dict[c] + 1
            else:
                c_dict[c] = 1
        
        length = 0
        num = 0
        for key in c_dict:
            count = c_dict[key]
            if count % 2 == 0:
                length = length + count
            else:
                length = length + count - 1
                num = 1
        return length + num
```


## 459. 重复的子字符串

[原题链接](https://leetcode-cn.com/problems/repeated-substring-pattern/comments/)

### 思路

1. 找出所有与字符串第一个字母相同的字母所在位置并存储
2. 截断该字母前的字串，设为 `x`
3. 判断 `x` 重复 n 次后是否等于原字符串

```python
class Solution(object):
    def repeatedSubstringPattern(self, s):
        """
        :type s: str
        :rtype: bool
        """
        begin_c = s[0]
        s_length = len(s)
        
        tmp = []
        # 从第 2 个字符串开始判断
        # 因为是重复字串，所以至少是 double 倍，直接二分来找，+1 是因为下一个重复的字母会出现在下一个字符串的开头，举例：abab
        for i in range(1, s_length / 2 + 1):
            if begin_c == s[i]:
                tmp.append(i)
        
        for index in tmp:
            n = s_length / index
            if s[:index] * n == s:
                return True
        
        return False
```

## 557. 反转字符串中的单词 III

[原题链接](https://leetcode-cn.com/problems/reverse-words-in-a-string-iii/)

### 思路

1. 按空格分割出单词
2. 将每个单词翻转
3. 拼接所有翻转的结果

```python
class Solution:
    def reverseWords(self, s: str) -> str:
        return " ".join([string[::-1] for string in s.split(" ")])
```

相关知识点：

- 翻转的切片方法为 `[::-1]`
- 分割方法为 `string.split(" ")`


## 567. 字符串的排列

[原题链接](https://leetcode-cn.com/problems/permutation-in-string/)

### 思路

计算 s2 中是否存在子串与 s1 拥有相同字母数

- 先计算 s1 每个字母出现次数
- 在 s2 上放置 "滑动窗口"，计算与 s1 等长的字串是否拥有与 s1 相同的字符数

```python

```


## 647. 回文子串

[原题连接](https://leetcode-cn.com/problems/palindromic-substrings/submissions/)

### 思路

- 遍历字符串 s 时，对每一位字符进行左右扩展，并判断是否为回文串
- 若为回文串则继续向两端扩展
- 否则循环进入下一个字符
- 分为奇数回文串和偶数回文串两种情况

```python
class Solution(object):
    
    cnt = 0
    
    def countSubstrings(self, s):
        """
        :type s: str
        :rtype: int
        """
        s_index = 0
        for s_c in s:
            self.extendSubstrings(s_index, s_index, s)
            self.extendSubstrings(s_index, s_index + 1, s)
            s_index = s_index + 1
        return self.cnt
            
    
    def extendSubstrings(self, start, end, s):
        while (start >=0 and end<len(s)) and (s[start] == s[end]):
            start = start - 1
            end = end + 1
            self.cnt = self.cnt + 1
```


## 680. 验证回文字符串 Ⅱ

[原题链接](https://leetcode-cn.com/problems/valid-palindrome-ii/comments/)

### 思路

双指针法

```python
class Solution(object):
    def validPalindrome(self, s):
        """
        :type s: str
        :rtype: bool
        """
        i = 0
        j = len(s) - 1
        while i < j:
            if s[i] != s[j]:
                return self.isPalindrome(i + 1, j, s) or self.isPalindrome(i, j - 1, s)
            i = i + 1
            j = j - 1
        return True
    
    def isPalindrome(self, i, j, s):
        while i < j:
            if s[i] != s[j]:
                return False
            i = i + 1
            j = j - 1
        return True
```


## 696. 计数二进制子串

[原题链接](https://leetcode-cn.com/problems/count-binary-substrings/submissions/)

### 思路

- pre_length 记录前一个数字出现的次数
- cur_length 记录当前数字出现的次数
- pre_length >= cur_length 时，result++

```python
class Solution(object):
    def countBinarySubstrings(self, s):
        """
        :type s: str
        :rtype: int
        """
        cur_length = 1
        pre_length = 0
        result = 0
        for i in range((len(s) - 1)):
            if s[i] == s[i + 1]:
                cur_length = cur_length + 1
            else:
                pre_length = cur_length
                cur_length = 1
                
            if pre_length >= cur_length:
                result = result + 1
        return result
```

## 771. 宝石与石头

[原题链接](https://leetcode-cn.com/problems/jewels-and-stones/)

### 解法一：遍历字符串

遍历字符串，寻找 S 中存在于 J 中的字母个数。

```python
class Solution:
    def numJewelsInStones(self, J: str, S: str) -> int:
        res = 0
        for j in J:
            for s in S:
                if j == s:
                    res += 1
        return res
```

pythonic 一点：

```python
class Solution:
    def numJewelsInStones(self, J: str, S: str) -> int:
        return len([x for x in S if x in J])
```

### 解法二：哈希表

记录 `S` 中每个字母出现的次数，再把 `J` 中存在的字母次数都相加。

```python
class Solution:
    def numJewelsInStones(self, J: str, S: str) -> int:
        s_count = dict()
        for s in S:
            s_count[s] = s_count.get(s, 0) + 1
        res = 0
        for j in J:
            res += s_count.get(j, 0)
        return res
```

## 848. 字母移位

[原题链接](https://leetcode-cn.com/problems/shifting-letters/)

### 思路

越靠前的字母需要移动次数越多，可以算出每个字母需要移动的总次数，然后再对字母进行统一移动处理。时间复杂度为 $O(n)$。

```python
class Solution:
    def shiftingLetters(self, S: str, shifts: List[int]) -> str:
        length = len(shifts)
        
        # 每个字母要移动的总次数
        num = [0 for _ in range(length)]
        num[length - 1] = shifts[length - 1]
        for i in range(length - 2, -1, -1):
            num[i] = shifts[i] + num[i + 1]
        
        s_list = list(S)
        ord_a = ord('a')
        ord_z = ord('z')
        for i in range(length):
            shift = num[i] % 26
            c = s_list[i]
            ord_res = ord(c) + shift
            if ord_res > ord_z:
                ord_res = ord_res - ord_z - 1 + ord_a
            s_list[i] = chr(ord_res)
        
        return "".join(s_list)
```

## 1108. IP 地址无效化

[原题链接](https://leetcode-cn.com/problems/defanging-an-ip-address/)

对字符串的考察。

<!-- tabs:start -->

#### ** Python **

```python
class Solution:
    def defangIPaddr(self, address: str) -> str:
        res = ''
        for c in address:
            if c == ".":
                res += '[.]'
            else:
                res += c
        return res
```

#### ** PHP **

```php
class Solution {

    /**
     * @param String $address
     * @return String
     */
    function defangIPaddr($address) {
        $res = '';
        for ($i = 0; $i < strlen($address); $i++) {
            if ($address[$i] == '.') {
                $res .= "[.]";
            } else {
                $res .= $address[$i];
            }
        }
        return $res;
    }
}
```

#### ** Swift **

```swift
class Solution {
    func defangIPaddr(_ address: String) -> String {
        var res = ""
        for c in address {
            if c == "." {
                res += "[.]"
            } else {
                res += String(c)
            }
        }
        return res
    }
}
```

<!-- tabs:end -->