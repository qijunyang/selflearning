package com.springbootlearning.springdemo.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class AppMeta {
    //init value from application.properties
    @Value("${spring.application.name}")
    private String appName;

    @Value("${spring.application.version}")
    private String appVersion;

    @GetMapping("/app-name")
    public String[] getAppName() {
        return new String[] {appName};
    }

    @GetMapping("/version")
    public  String[] getVersion() {
        return new String[] {appVersion};
    }
}
