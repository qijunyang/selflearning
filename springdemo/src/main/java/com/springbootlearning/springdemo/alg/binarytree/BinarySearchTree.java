package com.springbootlearning.springdemo.alg.binarytree;

import java.util.ArrayList;
import java.util.List;

public class BinarySearchTree {
    BinaryTreeNode root = null;
    public void add(int value) {
        root = insert(root, value);
    }

    private BinaryTreeNode insert(BinaryTreeNode root, int value) {
        if (root == null) return new BinaryTreeNode(value);
        if (root.value == value) return root;
        if (value > root.value) {
            root.right = insert(root.right, value);
        } else {
            root.left = insert(root.left, value);
        }
        return root;
    }

    public void del(int value) {
        del(root, value);
    }

    public BinaryTreeNode del(BinaryTreeNode root, int value) {
        if (root == null) return null;
        if (root.value > value) {
            root.left = del(root.left, value);
        } else if (root.value < value) {
            root.right = del(root.right, value);
        } else {
            if (root.left == null) {
                return root.right;
            }
            if (root.right == null) {
                return root.left;
            }
            // find the smalles node from its right child.
            // it should be either it's right child or the far left child of its right child
            BinaryTreeNode smallestOnTheRight = getSmallestNode(root);
            root.value = smallestOnTheRight.value;
            root.right = del(root.right, smallestOnTheRight.value);
        }
        return root;
    }

    private BinaryTreeNode getSmallestNode(BinaryTreeNode curr) {
        curr = curr.right;
        while (curr != null && curr.left != null) {
            curr = curr.left;
        }
        return curr;
    }

    public BinaryTreeNode search(BinaryTreeNode root, int value) {
        if (root == null) return null;
        if (root.value == value) return root;
        if (value > root.value) {
            return search(root.right, value);
        } else {
            return search(root.left, value);
        }
    }

    public void inorderPrint() {
        List<Integer> result = new ArrayList<>();
        BinaryTreeTraversal.inorderTraversal(root, result);
        BinaryTreeTraversal.print("binary search tree result", result);
    }

    public static void main(String[] args) {
        BinarySearchTree bst = new BinarySearchTree();
        for (int i = 10; i > 0; i--) {
            bst.add(i);
        }
        bst.inorderPrint();
        bst.del(5);
        bst.del(8);
        bst.inorderPrint();

        System.out.println("test search ----------------------");
        BinaryTreeNode searchNode = bst.search(bst.root, 2);
        System.out.println(searchNode.value);
    }
}
