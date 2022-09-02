package com.techelevator.controller;

import com.techelevator.dao.ExampleDao;
import com.techelevator.model.Example;
import com.techelevator.model.ImageUrl;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.List;

@RestController
@CrossOrigin
public class ExampleController {

    ExampleDao exampleDao;

    public ExampleController(ExampleDao exampleDao) {
        this.exampleDao = exampleDao;
    }


    @RequestMapping(path= "/examples", method = RequestMethod.GET)
    public List<Example> getAllExamples(){
        return exampleDao.getAll();
    }

    @RequestMapping(path= "/examples/languages", method = RequestMethod.GET)
    public List<String> getAllLanguages(){
        return exampleDao.getAllLanguages();
    }

    @RequestMapping(path= "/examples/tags", method = RequestMethod.GET)
    public List<String> getAllTags(){
        return exampleDao.getAllTags();
    }

    @RequestMapping(path = "/examples/{example_id}", method = RequestMethod.GET)
    public Example getExampleById(@PathVariable long example_id){
        return exampleDao.getExampleByExampleId(example_id);
    }

    @PreAuthorize("isAuthenticated()")
    @RequestMapping(path = "/examples/user/private/{example_id}", method = RequestMethod.GET)
    public Example getUserExampleById(Principal principal, @PathVariable long example_id){
        return exampleDao.getUserExampleByExampleId(principal.getName(), example_id);
    }

    @PreAuthorize("isAuthenticated()")
    @RequestMapping(path = "/examples/user/pending/{example_id}", method = RequestMethod.GET)
    public Example getPendingExampleById(Principal principal, @PathVariable long example_id){
        return exampleDao.getPendingExampleByExampleId(principal.getName(), example_id);
    }

    @RequestMapping(path = "/{language}", method = RequestMethod.GET)
    public long getIntroduction(@PathVariable String language){
        return exampleDao.getIntroductionByLanguage(language);
    }

    @PreAuthorize("isAuthenticated()")
    @RequestMapping(path= "/examples", method = RequestMethod.PUT)
    public Example updateAttribution(@RequestBody Example example){
        return exampleDao.updateAttribution(example);
    }

    @ResponseStatus(HttpStatus.OK)
    @PreAuthorize("isAuthenticated()")
    @RequestMapping(path="/examples/submit/{id}", method = RequestMethod.PUT)
    public void submitExampleForApproval(Principal principal, @PathVariable long id){
        exampleDao.submitExampleForApproval(principal.getName(), id);
    }

    @ResponseStatus(HttpStatus.OK)
    @PreAuthorize("isAuthenticated()")
    @RequestMapping(path="/examples/redact/{id}", method = RequestMethod.PUT)
    public void redactExample(Principal principal, @PathVariable long id){
        exampleDao.redactExample(principal.getName(), id);
    }

    @ResponseStatus(HttpStatus.OK)
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @RequestMapping(path="/examples/approve/{id}", method = RequestMethod.PUT)
    public void approvePendingExample(@PathVariable long id){
        exampleDao.approvePendingExample(id);
    }

    @ResponseStatus(HttpStatus.OK)
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @RequestMapping(path="/examples/decline/{id}", method = RequestMethod.PUT)
    public void declinePendingExample(@PathVariable long id){
        exampleDao.declinePendingExample(id);
    }

    @ResponseStatus(HttpStatus.OK)
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @RequestMapping(path="/examples/addDefault/{id}", method = RequestMethod.PUT)
    public void makeDefault(@PathVariable long id){
        exampleDao.makeDefault(id);
    }

    @ResponseStatus(HttpStatus.OK)
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @RequestMapping(path="/examples/removeDefault/{id}", method = RequestMethod.PUT)
    public void removeDefault(@PathVariable long id){
        exampleDao.removeDefault(id);
    }



    @PreAuthorize("isAuthenticated()")
    @RequestMapping(path="/examples/user", method = RequestMethod.GET)
    public List<Example> getPrincipalExamples(Principal principal){
        return exampleDao.getExamplesByPrincipal(principal.getName());
    }

    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @RequestMapping(path="/examples/pending", method = RequestMethod.GET)
    public List<Example> getPendingExamples(){
        return exampleDao.getAllPending();
    }

    @RequestMapping(path="/examples/default", method = RequestMethod.GET)
    public List<Example> getDefaultExamples(){
        return exampleDao.getAllDefault();
    }

    @PreAuthorize("isAuthenticated()")
    @RequestMapping(path="/delete/{exampleId}", method = RequestMethod.POST)
    public void deleteExample(Principal principal,@PathVariable long exampleId){
        exampleDao.deleteExample(principal.getName(), exampleId);
    }
    @PreAuthorize("isAuthenticated()")
    @ResponseStatus(HttpStatus.CREATED)
    @RequestMapping(path="/examples/user", method = RequestMethod.POST)
    public Example addPrivateExample(Principal principal,@RequestBody Example example){
        return exampleDao.addPrivateExample(principal.getName(), example);
    }
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @RequestMapping(path="/examples/user/{id}", method = RequestMethod.GET)
    public List<Example> getExamplesById(@PathVariable long id){
        return exampleDao.getExamplesByUserId(id);
    }


    @PreAuthorize("isAuthenticated()")
    @RequestMapping(path="/examples/image/{id}", method = RequestMethod.PUT)
    public void addImageToExample(@PathVariable long id, Principal principal, @RequestBody ImageUrl imageUrl){
        exampleDao.addImageToExample(id, principal.getName(), imageUrl.getUrl());
    }

}
