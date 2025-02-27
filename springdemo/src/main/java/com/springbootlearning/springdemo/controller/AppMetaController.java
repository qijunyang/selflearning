package com.springbootlearning.springdemo.controller;

import com.springbootlearning.springdemo.service.AppMetaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
public class AppMetaController {
    @Autowired
    private AppMetaService appMetaService;

    //init value from application.properties
    @Value("${spring.application.name}")
    private String appName;

    @Value("${spring.application.version}")
    private String appVersion;

    @GetMapping("/application/name")
    public String[] getAppName() {
        return new String[] {appName};
    }

    @GetMapping("/application/version")
    public  String[] getVersion() {
        return new String[] {appVersion};
    }

    @GetMapping("/application/meta")
    public Map<String, String> getMeta() {
        return appMetaService.getMeta();
    }
}
