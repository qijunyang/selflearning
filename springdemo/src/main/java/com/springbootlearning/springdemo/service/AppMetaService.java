package com.springbootlearning.springdemo.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class AppMetaService {
    //init value from application.properties
    @Value("${spring.application.name}")
    private String appName;

    @Value("${spring.application.version}")
    private String appVersion;

    public Map<String, String> getMeta() {

        return new HashMap<String, String>() {{
            put("name", appName);
            put("version", appVersion);
        }};
    };
}
