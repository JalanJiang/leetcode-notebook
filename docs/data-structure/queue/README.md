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