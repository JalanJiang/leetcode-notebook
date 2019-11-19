# python3

class Solution:
    def removeElement(self, nums, val):
        """
        :type nums: List[int]
        :type val: int
        :rtype: int
        """
        length = len(nums)
        i = 0
        j = 0
        while j < length:
            if nums[j] != val:
                nums[i] = nums[j]
                i = i + 1
                j = j + 1
            else:
                j = j + 1
        res = length - (j - i)
        return res