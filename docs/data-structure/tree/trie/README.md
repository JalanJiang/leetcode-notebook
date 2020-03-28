## 820. 单词的压缩编码

[原题链接](https://leetcode-cn.com/problems/short-encoding-of-words/)

### 解一：字典树

将 word 反序后放入字典树，字典树中所有可走到叶子结点的路径就是没有后缀的词。因此最终答案是求解：

```
sum(树中每条路径长度 + 1)
```

```python
class Solution:
    
    res = 0
    
    def minimumLengthEncoding(self, words: List[str]) -> int:
        words = [x[::-1] for x in words]
        root = TrieNode()
        
        for word in words:
            tmp = root
            for c in word:
                if c not in tmp.dict:
                    tmp.dict[c] = TrieNode()
                tmp = tmp.dict[c]
                
        self.get_trie_node_count(root, 0)
        return self.res
        
    def get_trie_node_count(self, root, cnt):
        cur_length = len(root.dict)
        if cur_length == 0:
            self.res += cnt + 1 #到叶子结点的路径长度
            return
        for k, node in root.dict.items():
            self.get_trie_node_count(node, cnt + 1) 

"""
字典数 Node
"""
class TrieNode:
    def __init__(self):
        self.dict = dict()
```

- 时间复杂度：$O(\sum w_{i})$（$w_{i}$ 为 `words[i]` 的长度）
- 空间复杂度：$O(\sum w_{i})$，所有后缀存储的空间开销

### 解二：暴力破解

即直接找出可共享后缀的词到底有多少。

<!-- tabs:start -->

#### **Python**

使用集合去重，然后枚举每个单词的后缀，把该后缀从集合中删除。

```python
class Solution:
    def minimumLengthEncoding(self, words: List[str]) -> int:
        # 去重
        word_unique = set(words)
        for word in words:
            # 枚举后缀
            tmp = ''
            for i in range(1, len(word)):
                word_unique.discard(word[i:])
        return sum(len(word) + 1 for word in word_unique)
```

- 时间复杂度：$O(\sum w_{i}^2)$（$w_{i}$ 为 `words[i]` 的长度），遍历每个单词 + 截取后缀
- 空间复杂度：$O(\sum w_{i})$，所有后缀存储的空间开销

2020.03.28 复盘：

```python
class Solution:
    def minimumLengthEncoding(self, words: List[str]) -> int:
        if len(words) == 1:
            return len(words[0]) + 1
        # 单词整合
        # 结果：剩余单词长度 + 剩余单词数量（# 数量）
        # 倒过来比较
        reverse_words = [word[::-1] for word in words]
        # 排序
        reverse_words.sort()
        res = 0
        for i in range(1, len(reverse_words)):
            pre_word = reverse_words[i - 1]
            cur_word = reverse_words[i]
            # 双指针
            for j in range(len(pre_word)):
                if pre_word[j] != cur_word[j]:
                    # pre_word 需要单独处理
                    res += len(pre_word) + 1
                    break
        # 需要加上最后一个 cur_word
        res += len(cur_word) + 1
        return res
```

#### **Java**

```java
class Solution {
    public int minimumLengthEncoding(String[] words) {
        String[] resWords = new String[words.length];
        int len = 0;

        for (String word : words) {
            boolean isContains = false;
            for (int i = 0; i < len; i++) {
                String w = resWords[i];
                if (w.endsWith(word)) {
                    isContains = true;
                    break;
                } else if (word.endsWith(w)) {
                    isContains = true;
                    resWords[i] = word;
                }
            }
            if (!isContains) {
                resWords[len] = word;
                len++;
            }
        }

        int result = len;
        for (int i = 0; i < len; i++) {
            result += resWords[i].length();
        }
        return result;
    }
}
```

<!-- tabs:end -->