package com.springbootlearning.springdemo.store.dao;

import com.springbootlearning.springdemo.store.model.Customer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface JPACustomerRepository extends JpaRepository<Customer, Integer> {
//    @Query("SELECT t FROM customer t WHERE t.customer_name = ?1")
    List<Customer> findByCustomerName(String name);

    List<Customer> findByCustomerNameLike(String name);
}
