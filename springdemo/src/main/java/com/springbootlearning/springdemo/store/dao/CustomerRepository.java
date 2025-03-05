package com.springbootlearning.springdemo.store.dao;

import com.springbootlearning.springdemo.store.model.Customer;

import java.util.List;

public interface CustomerRepository {
    int save(Customer customer);

    int update(Customer customer);

    Customer findById(Integer id);

    int deleteById(Integer id);

    List<Customer> findAll();

    List<Customer> findByNameContaining(String name);

    int deleteAll();
}
