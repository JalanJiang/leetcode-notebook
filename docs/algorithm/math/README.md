## 29. 两数相除

[原题链接](https://leetcode-cn.com/problems/divide-two-integers/)

### 解法一

手写除法。但后面想想好像还是用了除法。。。明天改进一版

```python
class Solution(object):
    def divide(self, dividend, divisor):
        """
        :type dividend: int
        :type divisor: int
        :rtype: int
        """
        res = 0
        flag = 1
        if (dividend > 0 and divisor < 0) or (dividend < 0 and divisor > 0):
            flag = -1
        
        dividend = abs(dividend)
        divisor = abs(divisor)
        
        dividend_str = str(dividend)
        dividend_len = len(dividend_str)
        
        i = 0
        mod = 0
        while i < dividend_len:
            cur_int = mod * 10 + int(dividend_str[i])
            res = res * 10 + cur_int / divisor
            mod = cur_int % divisor
            i = i + 1
            
        res = res * flag
            
        if res < -2**31:
            return -2**31
        if res > 2**31 - 1:
            return 2**31 - 1
        
        return res
```

### 解法二

参考了大佬的代码。

思路总结起来就是：判断除数里可以减去多少个被除数。但如果每次都只减去除数，循环的次数太多了，所以把除数每次乘以 2，如果发现除数大于被除数了，再从头开始。

因为不能使用乘法，所以用移位运算代替。

```python
class Solution(object):
    def divide(self, dividend, divisor):
        """
        :type dividend: int
        :type divisor: int
        :rtype: int
        """
        res = 0
        flag = 1
        if (dividend > 0 and divisor < 0) or (dividend < 0 and divisor > 0):
            flag = -1
        
        dividend = abs(dividend)
        divisor = abs(divisor)
        
        while dividend >= divisor:
            tmp = divisor
            i = 1
            while dividend >= tmp:
                dividend -= tmp
                res += i
                
                i <<= 1
                tmp <<= 1
                
        if flag == -1:
            res = -res
        
        return min(max(-2**31, res), 2**31-1)
```


## 171. Excel表列序号

[原题链接](https://leetcode-cn.com/problems/excel-sheet-column-number/)

### 思路

首先观察一下列名称：

```
    A -> 1
    B -> 2
    C -> 3
    ...
    Z -> 26
    AA -> 27
    AB -> 28 
    ...
```

如果列名称只有 1 位，那么直接将该位转为对应的数字即可，A~Z 分别代表着 1~26。

当我们将 26 个字母都使用完后，想表示更大的数字，1 位字母显然是不够的。所以有了 `AA` 这种写法，最左边的 `A` 代表着**进位**，这和十进制其实是一样的，只不过变成了 26 进一。

```python
class Solution(object):
    def titleToNumber(self, s):
        """
        :type s: str
        :rtype: int
        """
        s_length = len(s)
        word_map = {'A': 1, 'B': 2, 'C': 3, 'D': 4, 'E': 5, 'F': 6, 'G': 7, 'H': 8, 'I': 9, 'J': 10, 'K': 11, 'L': 12, 'M': 13, 'N': 14, 'O': 15, 'P': 16, 'Q': 17, 'R': 18, 'S': 19, 'T': 20, 'U': 21, 'V': 22, 'W': 23, 'X': 24, 'Y': 25, 'Z': 26}
        res = 0
        for i in range(s_length - 1, -1, -1):
            word = s[i]
            j = s_length - 1 - i
            base = 26**j
            res += word_map[word] * base
        return res
```


## 172. 阶乘后的零

[原题链接](https://leetcode-cn.com/problems/factorial-trailing-zeroes/)

### 思路

题目问阶乘的结果有几个零，如果用笨方法求出阶乘然后再算 0 的个数会超出时间限制。

然后我们观察一下，5 的阶乘结果是 120，零的个数为 1：

```
5! = 5 * 4 * 3 * 2 * 1 = 120
```

末尾唯一的零来自于 `2 * 5`。很显然，如果需要产生零，阶乘中的数需要包含 2 和 5 这两个因子。

例如：`4 * 10 = 40` 也会产生零，因为 `4 * 10 = ( 2 * 2 ) * ( 2 * 5)` 。

因此，我们只要数一数组成阶乘的数中共有多少对 2 和 5 的组合即可。又因为 5 的个数一定比 2 少，问题简化为计算 5 的个数就可以了。

```python
class Solution(object):
    def trailingZeroes(self, n):
        """
        :type n: int
        :rtype: int
        """
        
        res = 0
        
        while n >= 5:
            res += n / 5
            n //= 5
        
        return res
```


## 202. 快乐数

[原题链接](https://leetcode-cn.com/problems/happy-number/)

### 思路

快乐就完事的普通做法。

大家可能比较纠结具体要在什么时机返回 `False`，这里用 Python 的集合对中间数做了存储，如果发现计算出来的数之前曾经出现过，就说明已经进入了不快乐循环，此时返回 `False`。

```python
class Solution(object):
    def isHappy(self, n):
        """
        :type n: int
        :rtype: bool
        """
        already = set()
        
        while n != 1:
            num = 0
            while n > 0:
                tmp = n % 10
                num += tmp**2
                n //= 10
            
            if num in already:
                return False
            else:
                already.add(num)
            
            n = num
            
        return True
```

----

看到评论里有大佬发现规律：

> 不是快乐数的数称为不快乐数（unhappy number），所有不快乐数的数位平方和计算，最後都会进入 4 → 16 → 37 → 58 → 89 → 145 → 42 → 20 → 4 的循环中。
  
也是牛皮。


## 204. 计数质数

[原题链接](https://leetcode-cn.com/problems/count-primes/)

### 超时法

```python
class Solution(object):
    def countPrimes(self, n):
        """
        :type n: int
        :rtype: int
        """
        count = 0
        for i in range(2, n):
            if self.isPrime(i) == True:
                print i
                count += 1
        return count
        
    def isPrime(self, n):
        
        if n == 2:
            return True
        if n == 3:
            return True
        
        for i in range(2, n - 1):
            if n % i == 0:
                return False
        return True
```

### 厄拉多塞筛法

[厄拉多塞筛法](https://blog.csdn.net/u013291076/article/details/45575967)

```python
class Solution(object):
    def countPrimes(self, n):
        """
        :type n: int
        :rtype: int
        """
        if n <= 2:
            return 0
        res = [1] * n
        res[0] = 0
        res[1] = 0
        
        i = 2
        while i * i < n:
            for j in range(2, (n - 1) // i + 1):
                res[i * j] = 0
            i += 1
        
        return sum(res)
```


## 326. 3的幂

[原题链接](https://leetcode-cn.com/problems/power-of-three/)

### 解法一

非递归

```python
class Solution(object):
    def isPowerOfThree(self, n):
        """
        :type n: int
        :rtype: bool
        """
        if n == 1:
            return True
        
        while n != 0:
            if n == 3:
                return True
            if n % 3 == 0:
                n = n / 3
            else:
                return False
            if n == 3:
                return True
        return False
```


## 412. Fizz Buzz

[原题链接](https://leetcode-cn.com/problems/fizz-buzz/comments/)

### 思路

比较简单，不多说了。

```python
class Solution(object):
    def fizzBuzz(self, n):
        """
        :type n: int
        :rtype: List[str]
        """
        res = []
        for i in range(1, n + 1):
            res.append(self.getRes(i))
        return res
        
    def getRes(self, n):
        mark = 0
        if n % 3 == 0:
            if n % 5 == 0:
                return "FizzBuzz"
            else:
                return "Fizz"
        else:
            if n % 5 == 0:
                return "Buzz"
            else:
                return str(n)
```


## 507. 完美数

[原题链接](https://leetcode-cn.com/problems/perfect-number/)

### 思路

1. 从 `1 ~ sqrt(num)` 的范围循环找出 `num` 的因子 `factor`
2. 如果 `factor != 1`，那么可以求出另一个与之对应的因子 `num / factor`。这里注意要判断 `num / factor` 是否与 `factor` 相等，避免相同因子重复添加
3. 计算所有因子和，判断是否与 `num` 相等

```python
import math

class Solution(object):
    def checkPerfectNumber(self, num):
        """
        :type num: int
        :rtype: bool
        """
        
        if num <= 1:
            return False
        
        s = 0
        for factor in range(1, int(math.sqrt(num)) + 1):
            # 判断是否是因子
            if num % factor == 0:
                s += factor
                # 避免相同因子重复添加
                if factor != 1 and num / factor != factor:
                    s += num / factor
            
        if s == num:
            return True
        else:
            return False
```


## 633. 平方数之和

[原题链接](https://leetcode-cn.com/problems/sum-of-square-numbers/)

### 思路

双指针

- i 从 0 开始
- j 从可取的最大数 int(math.sqrt(c)) 开始
- total = i * i + j * j
    - total > c: j = j - 1，将 total 值减小
    - total < c: i = i + 1，将 total 值增大
    - total == c：返回 True

```python
import math

class Solution(object):
    def judgeSquareSum(self, c):
        """
        :type c: int
        :rtype: bool
        """
        j = int(math.sqrt(c))
        i = 0
        while i <= j:
            total = i * i + j * j
            if total > c:
                j = j - 1
            elif total < c:
                i = i + 1
            else:
                return True
        return False
```

## 640. 求解方程

[原题链接](https://leetcode-cn.com/problems/solve-the-equation/)

### 思路

求解方程就是要把方程简化，求出 `x` 的个数 `x_count` 和剩余数值 `num`：

```
x_count * x = num
```

最终需要求的结果就是 `num / x_count`。

我们可以把方程式根据等号分为左右两个式子，对左右两个式子进行遍历，分别求出 `x` 的数量和剩余数值。

在遍历过程中：

1. 遇到字符为 `+` 或 `-`（即遇到运算符）：对该运算符之前的公式进行结算
2. 遇到字符不是运算符：
   1. 遇到字符为 `x`：根据 `x` 前面跟着的数字和运算符，对 `x` 的个数进行结算
   2. 遇到字符为数字：把该数字记录下来（我在这里用了 Python 的列表进行记录），当遇到下一个运算符或符号 `x` 时进行结算

⚠️注: 会遇到 `0x` 这样的写法。

```python
class Solution:
    def solveEquation(self, equation: str) -> str:
        formula = equation.split("=")
        
        def get_count(formula):
            num_list = []
            pre_symbol = "+"
            x_count = 0
            num = 0
            for c in formula:
                # 不是运算符
                if c != "+" and c != "-":
                    if c == "x":
                        add_x = 1 if len(num_list) == 0 else int("".join(num_list))
                        if pre_symbol == "+":
                            x_count += add_x
                        else:
                            x_count -= add_x
                        num_list = [] # 清空列表
                    else:
                        # 是数字
                        num_list.append(c)
                # 是运算符
                else:
                    if len(num_list) != 0:
                        num = eval(str(num) + pre_symbol + "".join(num_list))
                    pre_symbol = c
                    num_list = []
            # 最后遗漏的数字
            if len(num_list) != 0:
                num = eval(str(num) + pre_symbol + "".join(num_list))
            return [x_count, num]
        
        left = get_count(formula[0])
        right = get_count(formula[1])

        x_count = left[0] - right[0]
        num = left[1] - right[1]
                
        # 计算结果
        if x_count == 0 and num == 0:
            return "Infinite solutions"
        if x_count == 0 and num != 0:
            return "No solution"
        return "x=" + str(-num // x_count)
```