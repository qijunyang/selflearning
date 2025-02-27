package com.springbootlearning.springdemo.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class HomeController {

    @RequestMapping("/")
    public String index() {
        return "index.html";
    }


    @RequestMapping("/app-name")
    public String[] getAppName() {
        return new String[] {"app names"};
    }
}
