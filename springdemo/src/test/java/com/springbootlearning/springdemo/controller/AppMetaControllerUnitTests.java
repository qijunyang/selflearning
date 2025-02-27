package com.springbootlearning.springdemo.controller;

import com.springbootlearning.springdemo.service.AppMetaService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Map;
import java.util.HashMap;

import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
import static org.hamcrest.Matchers.is;

@WebMvcTest(AppMetaController.class)
public class AppMetaControllerUnitTests {
    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private AppMetaService appMetaService;

    @Test
    public void testGetApplicationName() throws Exception {
        mockMvc.perform(get("/application/name"))
                .andExpect(status().isOk())
                .andExpect(content().string("[\"springdemo\"]"))
                .andExpect(jsonPath("$[0]", is("springdemo")));;
    }

    @Test
    public void testGetApplicationMeta() throws  Exception {
        // Mock data returned by service
        Map<String, String> mockData = new HashMap<String, String>() {{
            put("name", "springdemo");
            put("version", "1.1");
        }};
        when(appMetaService.getMeta()).thenReturn(mockData);

        mockMvc.perform(get("/application/meta"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.name", is("springdemo")))
                .andExpect(jsonPath("$.version", is("1.1")));
    }
}

/*
 *
 * Different expect strategy
 * status().isOk(): Checks for HTTP 200 OK.
 * status().isNotFound(): Checks for HTTP 404 Not Found.
 * content().contentType(MediaType.APPLICATION_JSON): Checks content type.
 * content().string("expected content"): Checks exact content.
 * jsonPath("$.attribute", is("expected value")): Checks JSON content using JSONPath.
 * header().string("headerName", "headerValue"): Checks response headers.
 *
 */
