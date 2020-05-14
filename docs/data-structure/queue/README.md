## 622. 设计循环队列

[原题链接](https://leetcode-cn.com/problems/design-circular-queue/)

### 解一

没有过多考虑，直接用 list 实现，没有践行「循环」的概念。

```python
class MyCircularQueue:

    def __init__(self, k: int):
        """
        Initialize your data structure here. Set the size of the queue to be k.
        """
        self.list_data = []
        self.list_length = k

    def enQueue(self, value: int) -> bool:
        """
        Insert an element into the circular queue. Return true if the operation is successful.
        """
        if len(self.list_data) >= self.list_length:
            return False
        self.list_data.append(value)
        return True
        
    def deQueue(self) -> bool:
        """
        Delete an element from the circular queue. Return true if the operation is successful.
        """
        if len(self.list_data) > 0:
            del(self.list_data[0])
            return True
        return False

    def Front(self) -> int:
        """
        Get the front item from the queue.
        """
        if len(self.list_data) == 0:
            return -1
        return self.list_data[0]

    def Rear(self) -> int:
        """
        Get the last item from the queue.
        """
        if len(self.list_data) == 0:
            return -1
        return self.list_data[-1]

    def isEmpty(self) -> bool:
        """
        Checks whether the circular queue is empty or not.
        """
        return len(self.list_data) == 0

    def isFull(self) -> bool:
        """
        Checks whether the circular queue is full or not.
        """
        return len(self.list_data) == self.list_length


# Your MyCircularQueue object will be instantiated and called as such:
# obj = MyCircularQueue(k)
# param_1 = obj.enQueue(value)
# param_2 = obj.deQueue()
# param_3 = obj.Front()
# param_4 = obj.Rear()
# param_5 = obj.isEmpty()
# param_6 = obj.isFull()
```

### 解二：循环队列

用数组来实现，「循环」的意思就是没有头和尾的区别。且设计数组时选择「浪费一个位置」，让数组满和空两种状态不冲突。

设两个指针，`front` 指向头部，`rear` 指向尾部。

- 当 `front == rear` 时队列为空
- 当 `(rear + 1) % length == front` 时队列为满

```python
class MyCircularQueue:

    def __init__(self, k: int):
        """
        Initialize your data structure here. Set the size of the queue to be k.
        """
        # 浪费一个位置
        self.k = k + 1
        # 设置双指针
        self.front = 0
        self.rear = 0
        self.list_data = [0 for _ in range(self.k)]
        
    def enQueue(self, value: int) -> bool:
        """
        Insert an element into the circular queue. Return true if the operation is successful.
        """
        if self.isFull():
            return False
        self.list_data[self.rear] = value
        self.rear = (self.rear + 1) % self.k
        return True
        
    def deQueue(self) -> bool:
        """
        Delete an element from the circular queue. Return true if the operation is successful.
        """
        if self.isEmpty():
            return False
        self.front = (self.front + 1) % self.k
        return True

    def Front(self) -> int:
        """
        Get the front item from the queue.
        """
        if self.isEmpty():
            return -1
        return self.list_data[self.front]

    def Rear(self) -> int:
        """
        Get the last item from the queue.
        """
        if self.isEmpty():
            return -1
        return self.list_data[(self.rear - 1 + self.k) % self.k]

    def isEmpty(self) -> bool:
        """
        Checks whether the circular queue is empty or not.
        """
        return self.front == self.rear

    def isFull(self) -> bool:
        """
        Checks whether the circular queue is full or not.
        """
        return (self.rear + 1) % self.k == self.front


# Your MyCircularQueue object will be instantiated and called as such:
# obj = MyCircularQueue(k)
# param_1 = obj.enQueue(value)
# param_2 = obj.deQueue()
# param_3 = obj.Front()
# param_4 = obj.Rear()
# param_5 = obj.isEmpty()
# param_6 = obj.isFull()
```

## 641. 设计循环双端队列

[原题链接](https://leetcode-cn.com/problems/design-circular-deque/)

### 思路

同上题（622. 设计循环队列）。

```python
class MyCircularDeque:

    def __init__(self, k: int):
        """
        Initialize your data structure here. Set the size of the deque to be k.
        """
        self.k = k + 1
        self.front = 0
        self.rear = 0
        self.list_data = [0 for _ in range(self.k)]
        
    def insertFront(self, value: int) -> bool:
        """
        Adds an item at the front of Deque. Return true if the operation is successful.
        """
        if self.isFull():
            return False
        self.front = (self.front - 1) % self.k
        self.list_data[self.front] = value
        return True

    def insertLast(self, value: int) -> bool:
        """
        Adds an item at the rear of Deque. Return true if the operation is successful.
        """
        if self.isFull():
            return False
        self.list_data[self.rear] = value
        self.rear = (self.rear + 1) % self.k
        return True

    def deleteFront(self) -> bool:
        """
        Deletes an item from the front of Deque. Return true if the operation is successful.
        """
        if self.isEmpty():
            return False
        self.front = (self.front + 1) % self.k
        return True

    def deleteLast(self) -> bool:
        """
        Deletes an item from the rear of Deque. Return true if the operation is successful.
        """
        if self.isEmpty():
            return False
        self.rear = (self.rear - 1) % self.k
        return True

    def getFront(self) -> int:
        """
        Get the front item from the deque.
        """
        if self.isEmpty():
            return -1
        return self.list_data[self.front]

    def getRear(self) -> int:
        """
        Get the last item from the deque.
        """
        if self.isEmpty():
            return -1
        return self.list_data[(self.rear - 1 + self.k) % self.k]

    def isEmpty(self) -> bool:
        """
        Checks whether the circular deque is empty or not.
        """
        return self.front == self.rear

    def isFull(self) -> bool:
        """
        Checks whether the circular deque is full or not.
        """
        return (self.rear + 1) % self.k == self.front


# Your MyCircularDeque object will be instantiated and called as such:
# obj = MyCircularDeque(k)
# param_1 = obj.insertFront(value)
# param_2 = obj.insertLast(value)
# param_3 = obj.deleteFront()
# param_4 = obj.deleteLast()
# param_5 = obj.getFront()
# param_6 = obj.getRear()
# param_7 = obj.isEmpty()
# param_8 = obj.isFull()
```

## 752. 打开转盘锁

[原题链接](https://leetcode-cn.com/problems/open-the-lock/)

### 思路

BFS

```python
class Solution:
    def openLock(self, deadends: List[str], target: str) -> int:
        queue = list()
        queue.append(('0000', 0)) # 0000 也有可能是死亡数字
        already = {'0000'} # 节点是否已经遍历过
        while len(queue): # 当队列不为空时，循环队列
            # 取第一个元素
            node = queue[0]
            del queue[0]
            # 节点判断
            if node[0] == target:
                return node[1]
            if node[0] in deadends:
                continue
            # 获取周边节点
            negihbors = self.get_neighbors(node)
            for n in negihbors:
                if n[0] not in already:
                    already.add(n[0])
                    queue.append(n)
        return -1

    def get_neighbors(self, node):
        number = node[0]
        # print(number)
        depth = node[1]
        negihbors = []
        directions = {1, -1}
        for i in range(len(number)):
            # 循环位
            for d in directions:
                new_position = str((int(number[i]) + d) % 10)
                item = (number[:i] + new_position + number[i+1:], depth + 1)
                negihbors.append(item)
        return negihbors
```

## 933. 最近的请求次数

[原题链接](https://leetcode-cn.com/problems/number-of-recent-calls/)

### 思路

```python
class RecentCounter:

    def __init__(self):
        self.ping_list = []
        
    def ping(self, t: int) -> int:        
        first = t - 3000
        self.ping_list.append(t)
        while first > self.ping_list[0]:
            del(self.ping_list[0])
        
        return len(self.ping_list)


# Your RecentCounter object will be instantiated and called as such:
# obj = RecentCounter()
# param_1 = obj.ping(t)
```