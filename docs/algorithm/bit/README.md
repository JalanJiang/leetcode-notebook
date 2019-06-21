## 136. 只出现一次的数字

[原题链接](https://leetcode-cn.com/problems/single-number/comments/)

### 关键词

- 异或

### 解法一

使用额外空间。

```Python
class Solution(object):
    def singleNumber(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        d = set()
        for n in nums:
            if n in d:
                d.remove(n)
            else:
                d.add(n)
        return d.pop()
```

#### Python 字典

- 创建：`d = dict()`
- 添加：`add()`
- 随机弹出：`pop()`

### 解法二

巧妙使用异或运算：

- 相同为 0，不同为 1
- 0 与任何数异或都等于该数本身

```python
class Solution:
    def singleNumber(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        a = 0
        for num in nums:
            a = a ^ num
        return a
```


## 190. 颠倒二进制位

[原题链接](https://leetcode-cn.com/problems/reverse-bits/)

### 解一

Python 一行代码：

1. `n` 转为二进制并去掉前缀 `0b`
2. 左侧填充 0 到 32 位
3. 翻转字符串
4. 转为十进制表示

知识点：

- [Python bin() 函数](https://www.runoob.com/python/python-func-bin.html)
- [Python zfill()方法](https://www.runoob.com/python/att-string-zfill.html)
- [python进制转换（二进制、十进制和十六进制）及注意事项](https://m.pythontab.com/article/86)

```
class Solution:
    # @param n, an integer
    # @return an integer
    def reverseBits(self, n):
        return int(bin(n)[2:].zfill(32)[::-1], base=2)
```

### 解二

二进制移位。

取出 n 的最低位，加入结果 res 中。然后 n 右移，res 左移。循环此过程。

```python
class Solution:
    # @param n, an integer
    # @return an integer
    def reverseBits(self, n):
        res = 0
        count = 32
        
        while count:
            res <<= 1
            # 取出 n 的最低位数加到 res 中
            res += n&1
            n >>= 1
            count -= 1
            
        return int(bin(res), 2)
```


## 191. 位1的个数
   
[原题链接](https://leetcode-cn.com/problems/number-of-1-bits/)

### 解一

调用函数懒蛋法。

```python
class Solution(object):
    def hammingWeight(self, n):
        """
        :type n: int
        :rtype: int
        """
        return str(bin(n)).count('1')
```

### 解二

手动循环计算 1 的个数。

```python
class Solution(object):
    def hammingWeight(self, n):
        """
        :type n: int
        :rtype: int
        """
        n = bin(n)
        count = 0
        for c in n:
            if c == "1":
                count += 1
        return count  
```

### 解三

十进制转二进制的方式。每次对 2 取余判断是否是 1，是的话就 `count = count + 1`。

```python
class Solution(object):
    def hammingWeight(self, n):
        """
        :type n: int
        :rtype: int
        """
        count = 0
        while n:
            res = n % 2
            if res == 1:
                count += 1
            n //= 2
        return count
```

### 解四

位运算法。

把 `n` 与 `1` 进行与运算，将得到 `n` 的最低位数字。因此可以取出最低位数，再将 `n` 右移一位。循环此步骤，直到 `n` 等于零。

```python
class Solution(object):
    def hammingWeight(self, n):
        """
        :type n: int
        :rtype: int
        """
        count = 0
        while n:
            count += n&1
            n >>= 1
        return count
```


## 371. 两整数之和

[原题链接](https://leetcode-cn.com/problems/sum-of-two-integers/)

### 思路

题目说不能使用运算符 `+` 和 `-`，那么我们就要使用其他方式来替代这两个运算符的功能。

### 位运算中的加法

我们先来观察下位运算中的两数加法，其实来来回回就只有下面这四种：

```
0 + 0 = 0
0 + 1 = 1
1 + 0 = 1
1 + 1 = 0（进位 1）
```

仔细一看，这可不就是相同位为 0，不同位为 1 的**异或运算**结果嘛~

### 异或和与运算操作

我们知道，在位运算操作中，**异或**的一个重要特性是**无进位加法**。我们来看一个例子：

```
a = 5 = 0101
b = 4 = 0100

a ^ b 如下：

0 1 0 1
0 1 0 0
-------
0 0 0 1
```

`a ^ b` 得到了一个**无进位加法**结果，如果要得到 `a + b` 的最终值，我们还要找到**进位**的数，把这二者相加。在位运算中，我们可以使用**与**操作获得进位：

```
a = 5 = 0101
b = 4 = 0100

a & b 如下：

0 1 0 1
0 1 0 0
-------
0 1 0 0
```

由计算结果可见，`0100` 并不是我们想要的进位，`1 + 1` 所获得的进位应该要放置在它的更高位，即左侧位上，因此我们还要把 `0100` 左移一位，才是我们所要的进位结果。

那么问题就容易了，总结一下：

1. `a + b` 的问题拆分位 `(a 和 b 的无进位结果) + (a 和 b 的进位结果)`
2. 无进位加法使用**异或运算**计算得出
3. 进位结果使用**与运算**和**移位运算**计算得出
4. 循环此过程，直到进位为 0

### 在 Python 中的特殊处理

在 Python 中，整数不是 32 位的，也就是说你一直循环左移并不会存在溢出的现象，这就需要我们手动对 Python 中的整数进行处理，手动模拟 32 位 INT 整型。 

具体做法是将整数对 `0x100000000` 取模，保证该数从 32 位开始到最高位都是 0。

### 具体实现

```python
class Solution(object):
    def getSum(self, a, b):
        """
        :type a: int
        :type b: int
        :rtype: int
        """
        # 2^32
        MASK = 0x100000000
        # 整型最大值
        MAX_INT = 0x7FFFFFFF
        MIN_INT = MAX_INT + 1
        while b != 0:
            # 计算进位
            carry = (a & b) << 1 
            # 取余范围限制在 [0, 2^32-1] 范围内
            a = (a ^ b) % MASK
            b = carry % MASK
        return a if a <= MAX_INT else ~((a % MIN_INT) ^ MAX_INT)   
```

当然，如果你在 Python 中想要偷懒也行，毕竟 life is short……

```python
class Solution(object):
    def getSum(self, a, b):
        """
        :type a: int
        :type b: int
        :rtype: int
        """
        return sum([a, b])
```


## 461. 汉明距离

[原题链接](https://leetcode-cn.com/problems/hamming-distance/comments/)

### 思路

异或运算：对应位置相同为 0，不同为 1。计算 1 的个数即可。

```python
class Solution(object):
    def hammingDistance(self, x, y):
        """
        :type x: int
        :type y: int
        :rtype: int
        """
        
        string = bin(x ^ y)
        count = 0
        
        for s in string:
            if s == "1":
                count += 1
        
        return count
```

看到评论里大佬的一行写法：`return bin(x ^ y).count('1')`。


