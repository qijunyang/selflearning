package com.springbootlearning.springdemo.alg.binarytree;

import java.util.*;

public class BinaryTreeTraversal {
    public static void print(String label, List<Integer> result) {
        System.out.println(label);
        for (int num : result) {
            System.out.print(num);
            System.out.print(", ");
        }
        System.out.println();
    }
    public static void preorderTraversal(BinaryTreeNode root, List<Integer> result) {
        if (root == null) {
            return;
        }
        result.add(root.value);
        preorderTraversal(root.left, result);
        preorderTraversal(root.right, result);
    }

    public static void preorderIterate(BinaryTreeNode root, List<Integer> result) {
        if (root == null) {
            return;
        }
        Stack<BinaryTreeNode> stack = new Stack<>();
        stack.add(root);
        while (!stack.isEmpty()) {
            BinaryTreeNode node = stack.pop();
            result.add(node.value);
            if (node.right != null) stack.add(node.right);
            if (node.left != null) stack.add(node.left);
        }
    }
    public static void inorderTraversal(BinaryTreeNode root, List<Integer> result) {
        if (root == null) {
            return;
        }
        inorderTraversal(root.left, result);
        result.add(root.value);
        inorderTraversal(root.right, result);
    }

    public static void inorderIterate(BinaryTreeNode root, List<Integer> result) {
        if (root == null) {
            return;
        }
        Stack<BinaryTreeNode> stack = new Stack<>();
        BinaryTreeNode curr = root;
        while (curr != null || !stack.isEmpty()) {
            if (curr != null) {
                stack.add(curr);
                curr = curr.left;
            } else {
                curr = stack.pop();
                result.add(curr.value);
                curr = curr.right;
            }
        }
    }

    public static void postorderTraversal(BinaryTreeNode root, List<Integer> result) {
        if (root == null) {
            return;
        }
        postorderTraversal(root.left, result);
        postorderTraversal(root.right, result);
        result.add(root.value);
    }

    public static void postorderIterate(BinaryTreeNode root, List<Integer> result) {
        if (root == null) {
            return;
        }
        Stack<BinaryTreeNode> stack = new Stack<>();
        stack.add(root);
        while (!stack.isEmpty()) {
            BinaryTreeNode node = stack.pop();
            result.add(node.value);
            if (node.right != null) stack.add(node.left);
            if (node.left != null) stack.add(node.right);
        }
        Collections.reverse(result);
    }

    public static void wideTraversal(BinaryTreeNode root, List<Integer> result) {
        if (root == null) return;
        Queue<BinaryTreeNode> q = new LinkedList<>();
        q.add(root);
        while (!q.isEmpty()) {
            BinaryTreeNode node = q.poll();
            result.add(node.value);
            if (node.left != null) q.add(node.left);
            if (node.right != null) q.add(node.right);
        }
    }

    public static void main(String[] args) {
        BinaryTreeNode root = new BinaryTreeNode(1);
        root.left = new BinaryTreeNode(2);
        root.right = new BinaryTreeNode(3);

        root.left.left = new BinaryTreeNode(4);
        root.left.right = new BinaryTreeNode(5);

        root.right.left = new BinaryTreeNode(6);
        root.right.right = new BinaryTreeNode(7);


        List<Integer> result = new ArrayList<Integer>();

        preorderTraversal(root, result);
        print("preorder recursive", result);
        result.clear();

        preorderIterate(root, result);
        print("preorder iterate", result);
        result.clear();
        System.out.println("--------------------------");

        inorderTraversal(root, result);
        print("inorder recursive", result);
        result.clear();

        inorderIterate(root, result);
        print("inorder iterate", result);
        result.clear();
        System.out.println("--------------------------");

        postorderTraversal(root, result);
        print("postorder recursive", result);
        result.clear();

        postorderIterate(root, result);
        print("postorder iterate", result);
        result.clear();
        System.out.println("--------------------------");

        wideTraversal(root, result);
        print("wide", result);
        result.clear();
    }
}
