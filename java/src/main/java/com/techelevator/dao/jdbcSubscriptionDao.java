package com.techelevator.dao;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.stereotype.Component;

import java.security.Principal;
import java.util.ArrayList;
import java.util.List;

@Component
public class jdbcSubscriptionDao implements SubscriptionDao{

    private final JdbcTemplate jdbcTemplate;

    public jdbcSubscriptionDao(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<String> getSubscriptions(Principal principal){
        String sql = "select us.username from subscriptions " +
                "join users u on subscriptions.subscriber_id = u.user_id " +
                "join users us on subscriptions.creator_id = us.user_id " +
                "where u.user_id in (select user_id from users where username = ?)";
        SqlRowSet rs = jdbcTemplate.queryForRowSet(sql, principal.getName());
        List<String> usernames = new ArrayList<>();

        while(rs.next()){
            usernames.add(rs.getString("username"));
        }
        return usernames;
    }

    public List<String> getSubscribers(Principal principal){
        String sql = "select email from subscriptions " +
                "join users on subscriptions.subscriber_id = users.user_id " +
                "where user_id in (select user_id from users where username = ?)";

        SqlRowSet rs = jdbcTemplate.queryForRowSet(sql, principal.getName());
        List<String> emails = new ArrayList<>();

        while(rs.next()){
            emails.add(rs.getString("email"));
        }
        return emails;
    }

    public List<String> getSubscriberEmailsByCreatorId(long creator_id){
        String sql =
                "select email " +
                "from users " +
                "join subscriptions on users.user_id = subscriptions.subscriber_id " +
                "where subscriptions.creator_id = ?";
        SqlRowSet rs = jdbcTemplate.queryForRowSet(sql, creator_id);

        List<String> emails = new ArrayList<>();
        while(rs.next()){
            emails.add(rs.getString("email"));
        }
        return emails;
    }

    public String getUsernameById(long user_id){
        String sql = "select username " +
                "from users " +
                "where user_id = ? ";
        SqlRowSet rs = jdbcTemplate.queryForRowSet(sql, user_id);

        if(rs.next()){
            return rs.getString("username");
        }
        else{
            return "NOT FOUND";
        }
    }

    public void addSubscription(Principal principal, long creator_id){
        String sql = "insert into subscriptions " +
                "(creator_id, subscriber_id) " +
                "values(?, (select user_id from users where username = ?))";

        jdbcTemplate.update(sql, creator_id ,principal.getName());
    }

    public void removeSubscription(Principal principal, long creator_id){
        String sql = "delete from subscriptions " +
                "where creator_id = ? " +
                "and subscriber_id in (select user_id from users where username = ?)";

        jdbcTemplate.update(sql, creator_id, principal.getName());
        
    }

    public List<Long> mapRowToList(SqlRowSet rs){
        List<Long> subscription_ids = new ArrayList<>();

        while(rs.next()){
            subscription_ids.add(rs.getLong("creator_id"));
        }

        return subscription_ids;
    }
}
