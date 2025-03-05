package com.springbootlearning.springdemo.store.dao;

import com.springbootlearning.springdemo.store.model.Customer;
import org.springframework.stereotype.Repository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.IncorrectResultSizeDataAccessException;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;

import java.util.List;

@Repository
public class JDBCCustomerRepository implements CustomerRepository{
    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    public int save(Customer customer) {
        return jdbcTemplate.update("INSERT INTO Customer (customer_id, customer_name) VALUES(?,?)",
                new Object[] { customer.getCustomerId(), customer.getCustomerName() });
    }

    @Override
    public int update(Customer customer) {
        return jdbcTemplate.update("UPDATE tutorials SET customer_name=? WHERE customer_id=?",
                new Object[] { customer.getCustomerName(), customer.getCustomerId() });
    }

    @Override
    public Customer findById(Integer customerId) {
        try {
            Customer customer = jdbcTemplate.queryForObject("SELECT * FROM customer WHERE customer_id=?",
                    BeanPropertyRowMapper.newInstance(Customer.class), customerId);

            return customer;
        } catch (IncorrectResultSizeDataAccessException e) {
            return null;
        }
    }

    @Override
    public int deleteById(Integer customerId) {
        return jdbcTemplate.update("DELETE FROM customer WHERE customer_id=?", customerId);
    }

    @Override
    public List<Customer> findAll() {
        return jdbcTemplate.query("SELECT * from customer", BeanPropertyRowMapper.newInstance(Customer.class));
    }

    @Override
    public List<Customer> findByNameContaining(String name) {
        String q = "SELECT * from customer WHERE customer_name ILIKE '%" + name + "%'";
        return jdbcTemplate.query(q, BeanPropertyRowMapper.newInstance(Customer.class));
    }

    @Override
    public int deleteAll() {
        return jdbcTemplate.update("DELETE from customer");
    }
}
