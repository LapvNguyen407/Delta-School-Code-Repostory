package com.techelevator.dao;

import com.techelevator.model.Example;

import java.security.Principal;
import java.util.List;

public interface ExampleDao {

    public Example getExampleByExampleId(long example_id);

    public Example getUserExampleByExampleId(String username, long example_id);

    public Example getPendingExampleByExampleId(String username, long example_id);

    public Example updateAttribution(Example example);

    public List<Example> getAll();

    public List<Example> getAllPending();

    public List<Example> getAllDefault();

    public List<String> getAllLanguages();

    public List<String> getAllTags();

    public List<Example> getExamplesByPrincipal(String username);

    public List<Example> getExamplesByUserId(long id);

    public Example addPrivateExample(String username, Example example);

    public long getIntroductionByLanguage(String language);

    public void submitExampleForApproval(String username, long ExampleId);

    public void redactExample(String username, long ExampleId);

    public void approvePendingExample(long exampleId);

    public void declinePendingExample(long exampleId);

    public void makeDefault(long exampleId);

    public void removeDefault(long exampleId);

    public void deleteExample(String username, long exampleId);

    public void addImageToExample(long example_id, String username, String url);

}
