package com.springbootlearning.springdemo.controller;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.boot.test.web.server.LocalServerPort;
import org.springframework.test.context.ActiveProfiles;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.hasKey;
import static org.hamcrest.Matchers.hasEntry;
import static org.hamcrest.Matchers.equalTo;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@ActiveProfiles(profiles = "qa")
public class AppMetaControllerIntegrationTests {
    @Autowired
    private AppMetaController controller;
    @LocalServerPort
    private int port;

    @Autowired
    private TestRestTemplate restTemplate;
    @Test
    void contextLoads() throws Exception {
        org.assertj.core.api.Assertions.assertThat(controller).isNotNull();
    }
    @Test
    void testGetMeta() throws Exception {
        Map<String, String> meta = this.restTemplate.getForObject("http://localhost:" + port + "/application/meta",
                HashMap.class);
        assertThat(meta, hasKey("name"));
        assertThat(meta, hasEntry("name", "springdemo-qa"));
        assertThat(meta, equalTo(new HashMap<String, String>() {{
            put("name", "springdemo-qa");
            put("version", "1.2");
        }}));

        // TODO need find how to do those 2 test
        // assertThat(map, hasAllEntries(expectedEntries));
        // assertThat(meta, hasSize(2));
    }

    @Test
    void testGetArrayData() throws Exception {
        List<String> names = this.restTemplate.getForObject("http://localhost:" + port + "/application/name",
                List.class);
        org.assertj.core.api.Assertions.assertThat(names.get(0)).isEqualTo("springdemo-qa");
        org.assertj.core.api.Assertions.assertThat(names.size()).isEqualTo(1);
    }
}
