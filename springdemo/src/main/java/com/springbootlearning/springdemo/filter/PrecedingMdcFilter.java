package com.springbootlearning.springdemo.filter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.MDC;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Component
@Order(-10000)
@Slf4j
public class PrecedingMdcFilter extends BypassedOncePerRequestFilter {
    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws IOException, ServletException {
        try {
            MDC.put("mdc_key", "mdc value");
            filterChain.doFilter(request, response);
        } finally {
            MDC.remove("mdc_key");
        }
    }
}
