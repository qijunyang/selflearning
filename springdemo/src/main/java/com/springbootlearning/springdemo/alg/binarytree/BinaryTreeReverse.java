package com.springbootlearning.springdemo.alg.binarytree;

import java.util.ArrayList;
import java.util.List;

public class BinaryTreeReverse {
    public static void reverse (BinaryTreeNode root) {
        if (root == null) return;
        BinaryTreeNode tmp = root.left;
        root.left = root.right;
        root.right = tmp;
        reverse(root.left);
        reverse(root.right);
    }
    public static void main(String[] args) {
        BinaryTreeNode root = new BinaryTreeNode(1);
        root.left = new BinaryTreeNode(2);
        root.right = new BinaryTreeNode(3);

        root.left.left = new BinaryTreeNode(4);
        root.left.right = new BinaryTreeNode(5);

        root.right.left = new BinaryTreeNode(6);
        root.right.right = new BinaryTreeNode(7);

        reverse(root);
        List<Integer> result = new ArrayList<>();
        BinaryTreeTraversal.wideTraversal(root, result);
        BinaryTreeTraversal.print("reverse binary tree", result);
    }
}
