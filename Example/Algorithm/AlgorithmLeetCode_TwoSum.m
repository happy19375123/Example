//
//  AlgorithmLeetCode_TwoSum.m
//  Example
//
//  Created by 张鹏 on 16/8/19.
//  Copyright © 2016年 张鹏. All rights reserved.
//

#import "AlgorithmLeetCode_TwoSum.h"

@implementation AlgorithmLeetCode_TwoSum

-(void)run{
//    int numbers[] = {0,4,3,0};
//    int target = numbers[0] + numbers[3];
//    int result[] = twoSum(numbers, 4, target);
//    for(int i=0;i<sizeof(result)/sizeof(result[0]);i++){
//        printf("%d\n",result[i]);
//    }
}

int* twoSum(int* nums, int numsSize, int target) {
    for (int i = 0; i < numsSize; i++) {
        for (int j = i + 1; j < numsSize; j++) {
            if (nums[i] == target - nums[j]) {
                int ans[2] = { i, j };
                for(int i=0;i<sizeof(ans)/sizeof(ans[0]);i++){
                    printf("%d\n",ans[i]);
                }
                return ans;
            }
        }
    }
    return 0;
}

@end
