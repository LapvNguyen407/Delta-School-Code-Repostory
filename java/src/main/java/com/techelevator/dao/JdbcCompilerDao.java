package com.techelevator.dao;

import com.techelevator.model.APIResponse;
import com.techelevator.model.CompilerDTO;
import org.springframework.http.*;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import org.springframework.web.client.ResourceAccessException;
import org.springframework.web.client.RestClientResponseException;
import org.springframework.web.client.RestTemplate;


@Component
public class JdbcCompilerDao implements CompilerDao {

    private final JdbcTemplate jdbcTemplate;
    private final static String API_REQUEST_URL = "https://api.jdoodle.com/v1/execute";
    private final RestTemplate restTemplate = new RestTemplate();

    public JdbcCompilerDao(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public String sendCodeToAPI(String language, String code) {

        CompilerDTO request = new CompilerDTO(language, code);
        APIResponse response = new APIResponse();
        try {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            HttpEntity<CompilerDTO> entity = new HttpEntity<>(request, headers);
            response = restTemplate.postForObject(API_REQUEST_URL, entity, APIResponse.class);

        } catch (RestClientResponseException | ResourceAccessException e) {
            System.out.println(e.getMessage());
        }
        return response.getOutput();
    }
}
