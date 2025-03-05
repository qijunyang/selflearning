package com.springbootlearning.springdemo.store.controller;

import com.springbootlearning.springdemo.store.dao.JPACustomerRepository;
import com.springbootlearning.springdemo.store.model.Customer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api")
public class JPACustomerController {
    static Logger logger = LoggerFactory.getLogger(JPACustomerController.class);

    @Autowired
    private JPACustomerRepository jPACustomerRepository;

    @GetMapping("/jpa/customers")
    public ResponseEntity<List<Customer>> getAllTutorials(@RequestParam(required = false) String name) {
        logger.trace("===Trace message");
        logger.debug("===Debug message");
        logger.info("===Info message");
        logger.warn("===Warning message");
        logger.error("===Error message");
        try {
            List<Customer> customers = new ArrayList<Customer>();

            if (name == null)
                jPACustomerRepository.findAll().forEach(customers::add);
            else
                jPACustomerRepository.findByCustomerNameLike("%" + name + "%").forEach(customers::add);

            return new ResponseEntity<>(customers, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
