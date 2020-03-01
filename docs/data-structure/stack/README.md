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

## 173. 二叉搜索树迭代器

[原题链接](https://leetcode-cn.com/problems/binary-search-tree-iterator/)

### 解法一

在构造函数中使用中序遍历将二叉搜索树转为升序序列，然后在 `next` 时依次出列。

但时间复杂度不符合题目要求。

### 解法二

不需要一次性生成整个序列，可以用栈模拟递归过程。

1. 在构造函数中：将树的所有左节点压入栈（这样最左的节点就在栈顶了）
2. 调用 `next` 时，弹出栈顶元素，此时判断该节点是否存在右节点，若存在则将右节点入栈，且将该节点的所有左节点依次入栈（中序遍历的顺序为 左->中->右，弹出的栈顶元素相当于中间节点，遍历到中间节点后就要遍历右节点了）

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class BSTIterator:

    def __init__(self, root: TreeNode):
        self.stack = []
        # 左节点依次入栈
        while root is not None:
            self.stack.append(root)
            root = root.left

    def next(self) -> int:
        """
        @return the next smallest number
        """
        # 弹出栈顶
        cur = self.stack.pop()
        # 判断是否存在右子树
        right = cur.right
        while right is not None:
            self.stack.append(right)
            right = right.left
        return cur.val


    def hasNext(self) -> bool:
        """
        @return whether we have a next smallest number
        """
        return len(self.stack) > 0



# Your BSTIterator object will be instantiated and called as such:
# obj = BSTIterator(root)
# param_1 = obj.next()
# param_2 = obj.hasNext()
```

关于复杂度的分析截取一下[这篇题解](https://leetcode-cn.com/problems/binary-search-tree-iterator/solution/nextshi-jian-fu-za-du-wei-o1-by-user5707f/)：

> 但是很多小伙伴会对next()中的循环操作的复杂度感到疑惑，认为既然加入了循环在里面，那时间复杂度肯定是大于O(1)不满足题目要求的。
> 仔细分析一下，该循环只有在节点有右子树的时候才需要进行，也就是不是每一次操作都需要循环的，循环的次数加上初始化的循环总共会有O(n)次操作，均摊到每一次 `next()` 的话平均时间复杂度则是 `O(n)/n=O(1)`，因此可以确定该实现方式满足 `O(1)` 的要求。
>这种分析方式称为摊还分析，详细的学习可以看看《算法导论》- 第17章 摊还分析

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

### 双队列解法一

定义两个辅助队列 `queue1` 与 `queue2`，使用一个变量 `top_element` 记录栈顶元素。

- `push()`：将元素入队 `queue1`
- `pop()`：
  - 将 `queue1` 内所有元素全部出队，除最后一个元素外，其余入队 `queue2`，而后删除最后一个元素并返回
  - 更新 `top_element`
  - 调换 `queue1` 与 `queue2`
- `top()`：返回 `top_elenemt`
- `empty()`：判断 `queue1` 的长度

<!-- tabs:start -->

#### **Python**

```python
class MyStack:

    def __init__(self):
        """
        Initialize your data structure here.
        """
        self.queue1 = []
        self.queue2 = []
        self.top_element = 0
        
    def push(self, x: int) -> None:
        """
        Push element x onto stack.
        """
        self.queue1.append(x)
        self.top_element = x

    def pop(self) -> int:
        """
        Removes the element on top of the stack and returns that element.
        """
        # 把 queue1 里的元素取出，留下一个，其余塞入 queue2 中
        length1 = len(self.queue1)
        for i in range(length1 - 1):
            item = self.queue1[0]
            del self.queue1[0]
            self.queue2.append(item)
        self.top = item
        target = self.queue1[0]
        del self.queue1[0]
        # 交换 queue1 与 queue2
        self.queue1 = self.queue2
        self.queue2 = []
        return target

    def top(self) -> int:
        """
        Get the top element.
        """
        # length1 = len(self.queue1)
        # for i in range(length1):
        #     item = self.queue1[0]
        #     del self.queue1[0]
        #     self.queue2.append(item)
        # self.queue1 = self.queue2
        # self.queue2 = []
        # return item
        return self.top_element

    def empty(self) -> bool:
        """
        Returns whether the stack is empty.
        """
        return len(self.queue1) == 0


# Your MyStack object will be instantiated and called as such:
# obj = MyStack()
# obj.push(x)
# param_2 = obj.pop()
# param_3 = obj.top()
# param_4 = obj.empty()
```

#### **Go**

```go
type MyStack struct {
    Queue1 []int
    Queue2 []int
    TopElement int
}


/** Initialize your data structure here. */
func Constructor() MyStack {
    var myStack MyStack
    return myStack
}


/** Push element x onto stack. */
func (this *MyStack) Push(x int)  {
    this.Queue1 = append(this.Queue1, x)
    this.TopElement = x
}


/** Removes the element on top of the stack and returns that element. */
func (this *MyStack) Pop() int {
    length1 := len(this.Queue1)
    for i := 0; i < length1 - 1; i++ {
        // 取出每个元素
        item := this.Queue1[0]
        this.TopElement = item
        // 删除元素
        this.Queue1 = this.Queue1[1:]
        // 入队列 2
        this.Queue2 = append(this.Queue2, item)
    }
    target := this.Queue1[0]
    // 交换
    this.Queue1 = this.Queue2
    this.Queue2 = make([]int, 0)
    return target
}


/** Get the top element. */
func (this *MyStack) Top() int {
    return this.TopElement
}


/** Returns whether the stack is empty. */
func (this *MyStack) Empty() bool {
    return len(this.Queue1) == 0
}


/**
 * Your MyStack object will be instantiated and called as such:
 * obj := Constructor();
 * obj.Push(x);
 * param_2 := obj.Pop();
 * param_3 := obj.Top();
 * param_4 := obj.Empty();
 */
```

<!-- tabs:end -->

- 时间复杂度：压入 $O(1)$，弹出 $O(n)$

### 双队列解法二

定义两个辅助队列 `queue1` 与 `queue2`，使用一个变量 `top_element` 记录栈顶元素。

- `push()`: 
  - 将元素入队 `queue2`，此时 `queue2` 中的首个元素为栈顶元素
  - 更新 `top_element`
  - 此时若 `queue1` 不为空，则让 `queue1` 中的元素逐个出队并加入 `queue2` 中
- `pop()`: `queue1` 首个元素出队，更新 `top_element`
- `top()`: 返回 `top_element`
- `empty()`: 判断 `queue1` 长度

<!-- tabs:start -->

#### **Python**

```python
class MyStack:

    def __init__(self):
        """
        Initialize your data structure here.
        """
        self.queue1 = []
        self.queue2 = []
        self.top_element = 0


    def push(self, x: int) -> None:
        """
        Push element x onto stack.
        """
        # 更新栈顶元素
        self.top_element = x
        # 加入 queue2 中
        self.queue2.append(x)
        if not self.empty():
            # 如果 queue1 不为空，取出元素并加入 queue2
            length1 = len(self.queue1)
            for i in range(length1):
                self.queue2.append(self.queue1[0])
                del self.queue1[0]
        # 交换
        self.queue1 = self.queue2
        self.queue2 = []


    def pop(self) -> int:
        """
        Removes the element on top of the stack and returns that element.
        """
        target = self.queue1[0]
        del self.queue1[0]
        # 更新 top_element
        if not self.empty():
            self.top_element = self.queue1[0]
        return target


    def top(self) -> int:
        """
        Get the top element.
        """
        return self.top_element


    def empty(self) -> bool:
        """
        Returns whether the stack is empty.
        """
        return len(self.queue1) == 0


# Your MyStack object will be instantiated and called as such:
# obj = MyStack()
# obj.push(x)
# param_2 = obj.pop()
# param_3 = obj.top()
# param_4 = obj.empty()
```

#### **Go**

```go
type MyStack struct {
    Queue1 []int
    Queue2 []int
    TopElement int
}


/** Initialize your data structure here. */
func Constructor() MyStack {
    var myStack MyStack
    return myStack
}


/** Push element x onto stack. */
func (this *MyStack) Push(x int)  {
    this.Queue2 = append(this.Queue2, x)
    // 更新栈顶元素
    this.TopElement = x
    if !this.Empty() {
        length1 := len(this.Queue1)
        for i := 0; i < length1; i++ {
            this.Queue2 = append(this.Queue2, this.Queue1[0])
            // 删除元素
            this.Queue1 = this.Queue1[1:]
        }
    }
    // 交换
    this.Queue1 = this.Queue2
    this.Queue2 = make([]int, 0)
}


/** Removes the element on top of the stack and returns that element. */
func (this *MyStack) Pop() int {
    target := this.Queue1[0]
    this.Queue1 = this.Queue1[1:]
    if !this.Empty() {
        // 更新栈顶元素
        this.TopElement = this.Queue1[0]
    }
    return target
}


/** Get the top element. */
func (this *MyStack) Top() int {
    return this.TopElement
}


/** Returns whether the stack is empty. */
func (this *MyStack) Empty() bool {
    return len(this.Queue1) == 0
}


/**
 * Your MyStack object will be instantiated and called as such:
 * obj := Constructor();
 * obj.Push(x);
 * param_2 := obj.Pop();
 * param_3 := obj.Top();
 * param_4 := obj.Empty();
 */
```

<!-- tabs:end -->

- 时间复杂度：压入 $O(n)$，弹出 $O(1)$

### 单队列解法三

定义辅助队列 `queue`。

- `push()`：
  - 将元素入队
  - 除新入队元素，将其他元素从队首取出，再从队尾入队（完成反序）。此时队首元素即为新入队元素
- `pop()`：`queue` 首个元素出队 
- `top()`：获取 `queue` 首个元素
- `empty()`：判断 `queue` 长度

<!-- tabs:start -->

#### **Python**

```python
class MyStack:

    def __init__(self):
        """
        Initialize your data structure here.
        """
        self.queue = []


    def push(self, x: int) -> None:
        """
        Push element x onto stack.
        """
        self.queue.append(x)
        # 队列反序
        length = len(self.queue)
        for i in range(length - 1):
            first = self.queue[0]
            del self.queue[0]
            self.queue.append(first)


    def pop(self) -> int:
        """
        Removes the element on top of the stack and returns that element.
        """
        target = self.queue[0]
        del self.queue[0]
        return target


    def top(self) -> int:
        """
        Get the top element.
        """
        return self.queue[0]


    def empty(self) -> bool:
        """
        Returns whether the stack is empty.
        """
        return len(self.queue) == 0


# Your MyStack object will be instantiated and called as such:
# obj = MyStack()
# obj.push(x)
# param_2 = obj.pop()
# param_3 = obj.top()
# param_4 = obj.empty()
```

#### **Go**

```go
type MyStack struct {
    Queue []int
}


/** Initialize your data structure here. */
func Constructor() MyStack {
    var myStack MyStack
    return myStack
}


/** Push element x onto stack. */
func (this *MyStack) Push(x int)  {
    this.Queue = append(this.Queue, x)
    length := len(this.Queue)
    for i := 0; i < length - 1; i++ {
        // 反序操作
        first := this.Queue[0]
        this.Queue = this.Queue[1:]
        this.Queue = append(this.Queue, first)
    }
}


/** Removes the element on top of the stack and returns that element. */
func (this *MyStack) Pop() int {
    target := this.Queue[0]
    this.Queue = this.Queue[1:]
    return target
}


/** Get the top element. */
func (this *MyStack) Top() int {
    return this.Queue[0]
}


/** Returns whether the stack is empty. */
func (this *MyStack) Empty() bool {
    return len(this.Queue) == 0
}


/**
 * Your MyStack object will be instantiated and called as such:
 * obj := Constructor();
 * obj.Push(x);
 * param_2 := obj.Pop();
 * param_3 := obj.Top();
 * param_4 := obj.Empty();
 */
```

<!-- tabs:end -->

- 时间复杂度：压入 $O(n)$，弹出 $O(1)$

## 331. 验证二叉树的前序序列化

[原题链接](https://leetcode-cn.com/problems/verify-preorder-serialization-of-a-binary-tree/)

### 解一：用栈辅助

按字符顺序依次入栈。如果入栈元素为 `#`，就判断栈顶能否凑成 `n##` 格式（`n` 为数字），如果可以就弹出 `n##`，让 `#` 入栈。因为 `n##` 表示一个叶节点，用 `#` 替代它以便让它的父节点达成叶节点条件（以此证明它是合法节点）。

```python
class Solution:
    def isValidSerialization(self, preorder: str) -> bool:

        stack = list()
        nodes = preorder.split(",")

        for node in nodes:
            self.add_item(stack, node)
            # print(stack)
            
        return True if len(stack) == 1 and stack[-1] == "#" else False

    def add_item(self, stack, node):
        if node == "#":
            if len(stack) > 1:
                # 判断能否凑成 x##
                if stack[-1] == "#" and stack[-2] != "#":
                    stack.pop()
                    stack.pop()
                    # 加入新的 #
                    self.add_item(stack, "#")
                else:
                    stack.append(node)
            else:
                stack.append(node)
        else:
            stack.append(node)
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

## 946. 验证栈序列

[原题链接](https://leetcode-cn.com/problems/validate-stack-sequences/)

模拟栈序列。

```python
class Solution:
    def validateStackSequences(self, pushed: List[int], popped: List[int]) -> bool:
        stack = []
        push_i = 0
        pop_i = 0
        length = len(pushed)

        while 1:
            # 判断栈顶元素是否为 pop 元素
            if len(stack) > 0 and stack[-1] == popped[pop_i]:
                stack.pop()
                pop_i += 1
            else:
                # 压入新的元素
                if push_i >= length:
                    break
                stack.append(pushed[push_i])
                push_i += 1

        return len(stack) == 0
```