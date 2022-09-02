package com.techelevator.controller;


import com.techelevator.dao.SubscriptionDao;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.List;

@RestController
@CrossOrigin
public class SubscriptionController {

    SubscriptionDao subscriptionDao;

    public SubscriptionController(SubscriptionDao subscriptionDao) {
        this.subscriptionDao = subscriptionDao;
    }

    @PreAuthorize("isAuthenticated()")
    @RequestMapping(path="/subscriptions", method = RequestMethod.GET)
    public List<String> getSubscriptions(Principal principal){
        return subscriptionDao.getSubscriptions(principal);
    }

    @PreAuthorize("isAuthenticated()")
    @RequestMapping(path="/subscribers", method = RequestMethod.GET)
    public List<String> getSubscribers(Principal principal){
        return subscriptionDao.getSubscribers(principal);
    }

    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @RequestMapping(path="/subscribers/{id}", method = RequestMethod.GET)
    public List<String> getSubscriberEmailsByCreatorId(@PathVariable long id){
        return subscriptionDao.getSubscriberEmailsByCreatorId(id);
    }


    @RequestMapping(path="username/{id}", method = RequestMethod.GET)
    public String getUsernameById(@PathVariable long id){
        return subscriptionDao.getUsernameById(id);
    }


    @PreAuthorize("isAuthenticated()")
    @RequestMapping(path="/subscribe/{id}", method = RequestMethod.POST)
    public List<String> addSubscription(Principal principal,@PathVariable long id){
        subscriptionDao.addSubscription(principal, id);
        return getSubscriptions(principal);
    }

    @PreAuthorize("isAuthenticated()")
    @RequestMapping(path="/unsubscribe/{id}", method = RequestMethod.POST)
    public List<String> removeSubscription(Principal principal,@PathVariable long id){
        subscriptionDao.removeSubscription(principal, id);
        return getSubscriptions(principal);
    }
}
