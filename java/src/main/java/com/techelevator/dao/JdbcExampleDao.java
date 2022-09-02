package com.techelevator.dao;

import com.techelevator.model.Example;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class JdbcExampleDao implements ExampleDao {

    private final JdbcTemplate jdbcTemplate;

    public JdbcExampleDao(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<Example> getAll(){
        String sql = "Select example_id, title, description, language, code, attribution, user_id, status, image_link " +
                "from examples " +
                "where status = 'PUBLIC' " +
                "order by language ";


        return mapAndTagRow(jdbcTemplate.queryForRowSet(sql));

    }

    public List<Example> getAllPending(){
        String sql =  "Select example_id, title, description, language, code, attribution, user_id, status, image_link " +
                "from examples " +
                "where status = 'PENDING' " +
                "order by example_id ";


        return mapAndTagRow(jdbcTemplate.queryForRowSet(sql));

    }

    public List<Example> getAllDefault(){
        String sql = "Select examples.example_id, title, description, language, code, attribution, user_id, status, image_link " +
                "from examples " +
                "join exampletags " +
                "on examples.example_id = exampletags.example_id " +
                "where exampletags.tag_id = 8 " +
                "order by examples.example_id";


        return mapAndTagRow(jdbcTemplate.queryForRowSet(sql));

    }

    public List<String> getAllLanguages(){
        String sql = "Select language " +
                "from examples " +
                "group by language";
        SqlRowSet rowSet = jdbcTemplate.queryForRowSet(sql);
        List<String> languages = new ArrayList<>();

        while(rowSet.next()){
            languages.add(rowSet.getString("language"));
        }
        return languages;
    }

    public List<String> getAllTags(){
        String sql = "Select name " +
                "from tags";
        SqlRowSet rowSet = jdbcTemplate.queryForRowSet(sql);
        List<String> tags = new ArrayList<>();

        while(rowSet.next()){
            tags.add(rowSet.getString("name"));
        }
        return tags;
    }

    public long getIntroductionByLanguage(String language){
        String sql = "Select example_id " +
                "from examples " +
                "where title ilike 'Introduction' and language = ?";

        SqlRowSet result = jdbcTemplate.queryForRowSet(sql, language);
        if(result.next()) {
            return result.getLong("example_id");
        }
        else{
            return 0;
        }
    }

    public List<Example> getExamplesByPrincipal(String username){

        String sql = "select examples.example_id, title, description, language, code, attribution, examples.user_id, status, image_link " +
                "FROM examples " +
                "join users on examples.user_id = users.user_id " +
                "where users.username = ? " +
                "and examples.status != 'DECLINED' " +
                "order by examples.status";
        return mapAndTagRow(jdbcTemplate.queryForRowSet(sql, username));

    }

    public List<Example> getExamplesByUserId(long id){
        String sql = "select example_id, title, description, language, code, attribution, user_id, status, image_link from examples " +
                "where user_id = ? and status != 'PRIVATE'";

        return mapAndTagRow(jdbcTemplate.queryForRowSet(sql, id));

    }

    public Example getExampleByExampleId(long example_id) {
        String sql =  "Select example_id, title, description, language, code, attribution, user_id, status, image_link " +
                "from examples " +
                "where example_id = ? " +
                "and examples.status = 'PUBLIC'";

        SqlRowSet rs = jdbcTemplate.queryForRowSet(sql, example_id);
        List<Example> mappedRowSet = mapAndTagRow(rs);
        if(mappedRowSet.size() != 0){
            return mappedRowSet.get(0);
        }
        return null;
    }

    public Example getPendingExampleByExampleId(String username, long example_id) {
        String sql = "select examples.example_id, title, description, language, code, attribution, examples.user_id, status, image_link   " +
                "from examples  " +
                "join users on users.user_id = examples.user_id  " +
                "where (example_id = ?  " +
                "and status = 'PENDING') ";
        SqlRowSet rs;
        if(!username.equals("admin")){
            sql += "and users.username = ? ";
            rs = jdbcTemplate.queryForRowSet(sql, example_id, username);
        } else {
            rs = jdbcTemplate.queryForRowSet(sql, example_id);
        }

        List<Example> mappedRowSet = mapAndTagRow(rs);
        if(mappedRowSet.size() != 0){
            return mappedRowSet.get(0);
        }
        return null;
    }

    public Example getUserExampleByExampleId(String username, long example_id) {
        String sql = "select examples.example_id, title, description, language, code, attribution, examples.user_id, status, image_link   " +
                "from examples  " +
                "join users on users.user_id = examples.user_id  " +
                "where example_id = ?  " +
                "and users.username = ? " +
                "and status = 'PRIVATE' ";

        SqlRowSet rs = jdbcTemplate.queryForRowSet(sql, example_id, username);
        List<Example> mappedRowSet = mapAndTagRow(rs);
        if(mappedRowSet.size() != 0){
            return mappedRowSet.get(0);
        }
        return null;
    }

    public Example addPrivateExample(String username, Example example){
        String sql = "insert into examples " +
                "(title, code, description, language, attribution, user_id, status) " +
                " select ?, ?, ?, ?, ?, users.user_id, 'PRIVATE' " +
                " from users where users.username = ? " +
                "returning example_id, title, code, description, language, user_id, attribution, status, image_link ";


        Example result = mapAndTagRow(jdbcTemplate.queryForRowSet(sql,example.getTitle(), example.getCode(), example.getDescription(), example.getLanguage(), example.getAttribution(), username)).get(0);
        addTagsToExample(result, example.getTags());
        return getUserExampleByExampleId(username, result.getExample_id());
    }

    public void addTagsToExample(Example example, List<String> tags){
        String sql;
        long id = example.getExample_id();
        for(String tag : tags){
            sql = "INSERT INTO exampletags (example_id, tag_id) " +
                    "select " + id+", tags.tag_id  " +
                    "from tags " +
                    "where tags.name = ?";
            jdbcTemplate.update(sql, tag);
        }
    }

    public void submitExampleForApproval(String username, long exampleId){
            String sql = "UPDATE examples " +
                    "SET status = 'PENDING'  " +
                    "where example_id in ( " +
                    "select example_id  " +
                    "from examples e " +
                    "join users on users.user_id = e.user_id " +
                    "where e.status = 'PRIVATE' " +
                    "AND e.example_id = ? " +
                    "AND users.username = ?)";
        jdbcTemplate.update(sql, exampleId, username);
    }

    public void redactExample(String username, long exampleId){
        String sql = "UPDATE examples " +
                "SET status = 'PRIVATE'  " +
                "where example_id in ( " +
                "select example_id  " +
                "from examples e " +
                "join users on users.user_id = e.user_id " +
                "AND e.example_id = ? " +
                "AND users.username = ?)";
        jdbcTemplate.update(sql, exampleId, username);
    }

    public void approvePendingExample(long exampleId){
        String sql = "UPDATE examples " +
                "SET status = 'PUBLIC'  " +
                "where example_id in ( " +
                "select example_id  " +
                "from examples e " +
                "where e.status = 'PENDING' " +
                "AND e.example_id = ? )";
        jdbcTemplate.update(sql, exampleId);
    }

    public void declinePendingExample(long exampleId){
        String sql = "UPDATE examples " +
                "SET status = 'DECLINED'  " +
                "where example_id in ( " +
                "select example_id  " +
                "from examples e " +
                "where e.status = 'PENDING' " +
                "AND e.example_id = ? )";
        jdbcTemplate.update(sql, exampleId);
    }
    
    public void makeDefault(long exampleId){
        String sql = "insert into exampletags " +
                "(example_id, tag_id) " +
                "values (?, 8)";
        jdbcTemplate.update(sql, exampleId);
    }
    
    public void removeDefault(long exampleId){
        String sql = "delete from exampletags " +
                "where example_id = ? " +
                "and tag_id = 8";
        jdbcTemplate.update(sql, exampleId);

    }
    public void deleteExample(String username, long exampleId){
        String sql = "delete from exampletags " +
                "where example_id = ? ";

        jdbcTemplate.update(sql, exampleId);

        sql= "delete from examples " +
             "where example_id = ? " +
             "and user_id in (select user_id from users where username = ?)";
        jdbcTemplate.update(sql, exampleId, username);

    }
    public Example updateAttribution(Example example) {
        String sql = "update examples " +
                "set attribution = ? " +
                "where example_id = ? " +
                "returning example_id, title, code, description, language, user_id, attribution, status, image_link";

        SqlRowSet result = jdbcTemplate.queryForRowSet(sql, example.getAttribution(), example.getExample_id());
        if (result.next()) {
            return mapRowToExample(result);
        }
        return null;
    }

    public List<Example> mapAndTagRow(SqlRowSet rs){

        List<Example> examples = new ArrayList<>();
        while(rs.next()){
            examples.add(mapRowToExample(rs));
        }
        addAllTagsOnExamples(examples);
        return examples;

    }

    public void addImageToExample(long example_id, String username, String url ){
        String sql = "update examples " +
                "set image_link = ? " +
                "where example_id in  " +
                "( select example_id " +
                "from examples e " +
                " join users on e.user_id = users.user_id " +
                "where users.username = ? " +
                "and example_id = ? )";
        jdbcTemplate.update(sql, url, username, example_id);

    }

    public Example mapRowToExample(SqlRowSet rs) {
        Example example = new Example();
        example.setExample_id(rs.getLong("example_id"));
        example.setTitle(rs.getString("title"));
        example.setDescription(rs.getString("description"));
        example.setCode(rs.getString("code"));
        example.setLanguage(rs.getString("language"));
        example.setAttribution(rs.getString("attribution"));
        example.setUserId(rs.getLong("user_id"));
        example.setStatus(rs.getString("status"));
        example.setImageUrl(rs.getString("image_link"));

        return example;
    }

    public List<Example> addAllTagsOnExamples(List<Example> examples){
        String sql = "select examples.example_id, tags.name from exampletags " +
                "join examples on examples.example_id = exampletags.example_id " +
                "join tags on tags.tag_id = exampletags.tag_id";
        SqlRowSet tags =  jdbcTemplate.queryForRowSet(sql);
        int index = 0;

        while(tags.next()){
            long exampleId = tags.getLong("example_id");
            for(Example example: examples){
                if(example.getExample_id() == exampleId){
                    example.addTag(tags.getString("name"));
                    continue;
                }
            }
        }
        return examples;
    }
}
