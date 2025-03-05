package com.springbootlearning.springdemo.store.controller;

import com.springbootlearning.springdemo.store.dao.CustomerRepository;
import com.springbootlearning.springdemo.store.model.Customer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api")
public class JDBCCustomerController {
    @Autowired
    CustomerRepository customersRepository;

    @GetMapping("/jdbc/customers")
    public ResponseEntity<List<Customer>> getAllTutorials(@RequestParam(required = false) String name) {
        try {
            List<Customer> customers = new ArrayList<Customer>();

            if (name == null)
                customersRepository.findAll().forEach(customers::add);
            else
                customersRepository.findByNameContaining(name).forEach(customers::add);

            if (customers.isEmpty()) {
                return new ResponseEntity<>(HttpStatus.NO_CONTENT);
            }

            return new ResponseEntity<>(customers, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping("/jdbc/customer")
    public ResponseEntity<Customer> createCustomer(@RequestBody Customer newCustomer) {
        customersRepository.save(newCustomer);
        return new ResponseEntity<>(newCustomer, HttpStatus.OK);
    }
}
