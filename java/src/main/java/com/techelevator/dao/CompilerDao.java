package com.techelevator.dao;

import com.techelevator.model.CompilerDTO;

public interface CompilerDao {
    public String sendCodeToAPI(String language, String code);
}
