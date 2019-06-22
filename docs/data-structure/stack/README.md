## 20. 有效的括号

[原题链接](https://leetcode-cn.com/problems/valid-parentheses/submissions/)

### 思路

- 字符串每个字符按顺序入栈
- 入栈时检测当前字符和栈顶字符是否为括号匹配，若匹配则弹出栈顶元素，不匹配则直接入栈
- 最后判断栈是否为空

写的比较蠢了，Python 可以直接用字典来匹配括号，这里用了 if。

```python
class Solution(object):
    def isValid(self, s):
        """
        :type s: str
        :rtype: bool
        """
        stack = list()
        for c in s:
            if stack:
                top = stack[len(stack) - 1]
                
                if c == ')':
                    if top == '(':
                        stack.pop()
                    else:
                        stack.append(c)
                elif c == '}':
                    if top == '{':
                        stack.pop()
                    else:
                        stack.append(c)
                elif c == ']':
                    if top == '[':
                        stack.pop()
                    else:
                        stack.append(c)
                else:
                    stack.append(c)
            else:
                stack.append(c)
        if stack:
            return False
        else:
            return True
```

## 150. 逆波兰表达式求值

[原题链接](https://leetcode-cn.com/problems/evaluate-reverse-polish-notation/)

### 思路

用栈实现。遍历数组 `tokens`，如果遇到非运算符，则入栈，如果遇到运算符则弹出栈顶两个元素进行计算，然后将计算结果入栈。

例如 `["4", "13", "5", "/", "+"]` 计算过程如下：

<img src="_img/questions/150.png">

```python
class Solution(object):
    def evalRPN(self, tokens):
        """
        :type tokens: List[str]
        :rtype: int
        """
        stack = list()
        operations = {'+', '-', '*', '/'}
        
        for token in tokens:
            if token in operations:
                # 是操作符
                right = stack.pop()
                left = stack.pop()
                if token == '+':
                    tmp = left + right
                elif token == '-':
                    tmp = left - right
                elif token == '*':
                    tmp = left * right
                else:
                    if left * right >= 0:
                        tmp = left // right
                    else:
                        tmp = -(-left // right)
                    
                stack.append(tmp)
            else:
                # 不是操作符
                stack.append(int(token))
        
        return stack[0]
```


## 155. 最小栈

[原题链接](https://leetcode-cn.com/problems/min-stack/submissions/)

### 思路

- 每次入栈两个值：当前入栈元素、栈内最小值，保证栈内最小值永远在栈顶

```python
class MinStack(object):

    def __init__(self):
        """
        initialize your data structure here.
        """
        self.stack = list()
        

    def push(self, x):
        """
        :type x: int
        :rtype: void
        """
        if self.stack:
            top = self.stack[len(self.stack) - 1]
            if x > top:
                self.stack.append(x)
                self.stack.append(top)
            else:
                self.stack.append(x)
                self.stack.append(x)
        else:
            self.stack.append(x)
            self.stack.append(x)
        

    def pop(self):
        """
        :rtype: void
        """
        self.stack.pop()
        self.stack.pop()
        

    def top(self):
        """
        :rtype: int
        """
        return self.stack[len(self.stack) - 2]
        

    def getMin(self):
        """
        :rtype: int
        """
        return self.stack[len(self.stack) - 1]
```

## 232. 用栈实现队列

[原题链接](https://leetcode-cn.com/problems/implement-queue-using-stacks/comments/)

### 思路

- 用两个堆栈 stack1 和 stack2 来模拟队列
- 入队列时：向 stack1 中压入元素
- 出队列时：将 stack1 中的元素依次弹出堆栈，并压入 stack2 中，最后弹出 stack2 的栈顶元素

```python
class MyQueue(object):

    def __init__(self):
        """
        Initialize your data structure here.
        """
        self.stack1 = list()
        self.stack2 = list()
        

    def push(self, x):
        """
        Push element x to the back of queue.
        :type x: int
        :rtype: void
        """
        self.stack1.append(x)
        

    def pop(self):
        """
        Removes the element from in front of queue and returns that element.
        :rtype: int
        """
        if self.stack2:
            return self.stack2.pop()
        else:
            while self.stack1:
                e = self.stack1.pop()
                self.stack2.append(e)
            return self.stack2.pop()

    def peek(self):
        """
        Get the front element.
        :rtype: int
        """
        if self.stack2:
            return self.stack2[len(self.stack2) - 1]
        else:
            while self.stack1:
                e = self.stack1.pop()
                self.stack2.append(e)
            return self.stack2[len(self.stack2) - 1]
        

    def empty(self):
        """
        Returns whether the queue is empty.
        :rtype: bool
        """
        if len(self.stack1) == 0 and len(self.stack2) == 0:
            return True
        else:
            return False
```

## 255. 用队列实现栈

[原题链接](https://leetcode-cn.com/problems/implement-stack-using-queues/description/)

### 思路

《剑指 offer》 p71，反正就是元素扔来扔去。

### Python

#### 懒蛋实现法

直接用 list 撸一波……

```python
class MyStack:
    def __init__(self):
        """
        Initialize your data structure here.
        """
        self.stack = []

    def push(self, x):
        """
        Push element x onto stack.
        :type x: int
        :rtype: void
        """
        self.stack.append(x)

    def pop(self):
        """
        Removes the element on top of the stack and returns that element.
        :rtype: int
        """
        return self.stack.pop()

    def top(self):
        """
        Get the top element.
        :rtype: int
        """
        return self.stack[len(self.stack) - 1]

    def empty(self):
        """
        Returns whether the stack is empty.
        :rtype: bool
        """
        if len(self.stack):
            return False
        else:
            return True
```

#### 还是来两个 queue 吧

- 以列表作为队列的底层实现
- 列表满足队列的约束：先进先出

```python
class MyStack:
    def __init__(self):
        """
        Initialize your data structure here.
        """
        self.queue_a = []
        self.queue_b = []

    def push(self, x):
        """
        Push element x onto stack.
        :type x: int
        :rtype: void
        """
        self.queue_a.append(x)

    def pop(self):
        """
        Removes the element on top of the stack and returns that element.
        :rtype: int
        """
        while len(self.queue_a) != 1:
            self.queue_b.append(self.queue_a.pop(0))
        self.queue_a, self.queue_b = self.queue_b, self.queue_a
        return self.queue_b.pop()


    def top(self):
        """
        Get the top element.
        :rtype: int
        """
        while len(self.queue_a) != 1:
            self.queue_b.append(self.queue_a.pop(0))
        top = self.queue_a[0]
        self.queue_b.append(self.queue_a.pop(0))
        self.queue_a, self.queue_b = self.queue_b, self.queue_a
        return top


    def empty(self):
        """
        Returns whether the stack is empty.
        :rtype: bool
        """
        if len(self.queue_a):
            return False
        else:
            return True
```

## 503. 下一个更大元素 II

[原题链接](https://leetcode-cn.com/problems/next-greater-element-ii/submissions/)

### 思路

用单调栈求解，此处栈内记录的是 nums 元素的下标

- 直接将 nums 复制两倍
- 判断栈顶元素和当前元素的大小
    - 若栈顶元素 > 当前元素：当前元素入栈
    - 若栈顶元素 < 当前元素：弹出栈顶元素，并记录栈顶元素的下一个更大元素为当前元素

```python
class Solution(object):
    def nextGreaterElements(self, nums):
        """
        :type nums: List[int]
        :rtype: List[int]
        """
        nums_length = len(nums)
        res_list = [-1 for _ in range(nums_length)]
        stack = list()
        
        double_nums = nums + nums
        for index, num in enumerate(double_nums):
            while stack and nums[stack[-1]] < num:
                res_list[stack[-1]] = num
                stack.pop()
            if index < nums_length:
                stack.append(index)
        return res_list
```


## 581. 最短无序连续子数组

[原题链接](https://leetcode-cn.com/problems/shortest-unsorted-continuous-subarray/)

### 思路

单调栈的应用，寻找所求的连续子数组的范围，即可知道其长度。

- 从队首向队尾循环遍历一次，寻找该连续的子数组的最左下标 `begin`
    - 元素依次入栈，需要保证栈顶元素始终小于当前要入栈的元素，若栈顶元素大于当前要入栈的元素，则把栈顶元素弹出，更新 `begin = min(begin, index)`
- 从队尾向队首循环遍历一次，寻找该连续的子数组的最右下标 `end`
    - 元素依次入栈，需要保证栈顶元素始终大于当前要入栈的元素，若栈顶元素小于当前要入栈的元素，则把栈顶元素弹出，更新 `end = max(end, index)`

```python
class Solution(object):
    def findUnsortedSubarray(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        
        length = len(nums)
        if length <= 1:
            return 0
        
        begin = length - 1
        end = 0
        
        stack = list()
        for i in range(length):
            n = nums[i]
            while len(stack) != 0 and stack[-1][1] > n:
                index, value = stack.pop()
                begin = min(begin, index)
            stack.append((i, n))
            
        stack = list()
        for i in reversed(range(length)):
            n = nums[i]
            while len(stack) != 0 and stack[-1][1] < n:
                index, value = stack.pop()
                end = max(end, index)
            stack.append((i, n))
            
        if begin >= end:
            return 0
        else:
            return end - begin + 1 
```


## 739. 每日温度

[原题链接](https://leetcode-cn.com/problems/daily-temperatures/submissions/)

### 思路

维护递减栈，后入栈的元素总比栈顶元素小。

- 比对当前元素与栈顶元素的大小
    - 若当前元素 < 栈顶元素：入栈
    - 若当前元素 > 栈顶元素：弹出栈顶元素，记录两者下标差值即为所求天数

这里用栈记录的是 T 的下标。

```python
class Solution(object):
    def dailyTemperatures(self, T):
        """
        :type T: List[int]
        :rtype: List[int]
        """
        stack = list()
        t_length = len(T)
        res_list = [0 for _ in range(t_length)]
        
        for key, value in enumerate(T):     
            if stack:
                while stack and T[stack[-1]] < value:
                    res_list[stack[-1]] = key - stack[-1]
                    stack.pop()
            stack.append(key)
        return res_list
```


