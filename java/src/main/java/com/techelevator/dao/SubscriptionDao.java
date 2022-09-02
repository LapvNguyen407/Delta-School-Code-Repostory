package com.techelevator.dao;

import java.security.Principal;
import java.util.List;

public interface SubscriptionDao {

    public List<String> getSubscriptions(Principal principal);

    public List<String> getSubscribers(Principal principal);

    public String getUsernameById(long id);

    public List<String> getSubscriberEmailsByCreatorId(long id);

    public void addSubscription(Principal principal, long creator_id);

    public void removeSubscription(Principal principal, long creator_id);
}
