package com.techelevator.controller;


import com.techelevator.dao.CompilerDao;
import com.techelevator.dao.ExampleDao;
import com.techelevator.model.CompilerDTO;
import org.springframework.web.bind.annotation.*;

@RestController
@CrossOrigin
public class CompilerController {

    CompilerDao compilerDao;


    public CompilerController(CompilerDao compilerDao) {
        this.compilerDao = compilerDao;
    }


    @RequestMapping(path="/compiler/run", method = RequestMethod.POST)
    public String runCode(@RequestBody CompilerDTO dto){
        return compilerDao.sendCodeToAPI(dto.getLanguage(), dto.getScript());
    };

}
