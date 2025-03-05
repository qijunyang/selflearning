package com.springbootlearning.springdemo.filter;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.web.filter.OncePerRequestFilter;

public abstract class BypassedOncePerRequestFilter extends OncePerRequestFilter {

    protected static final String[] BYPASS_URLS = {
            "/v1/healthcheck",
            "/v1/api-info",
            "/favicon.ico",
            "/swagger-ui.html",
            "/swagger-resources/",
            "/swagger-api-docs",
            "/webjars/",
            "/error"};

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        for (String bypass : BYPASS_URLS) {
            if (request.getServletPath().startsWith(bypass)) {
                return true;
            }
        }
        return false;
    }
}
