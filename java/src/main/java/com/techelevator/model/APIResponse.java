package com.techelevator.model;

public class APIResponse {

    private String output;
    private int status;
    private String memory;
    private String cpuTime;


    public APIResponse(){
        this.output = "NORESPONSE";
        this.status = -1;
        this.memory = "NORESPONSE";
        this.cpuTime = "NORESPONSE";

    }
    public String getOutput() {
        return output;
    }

    public int getStatus() {
        return status;
    }

    public String getMemory() {
        return memory;
    }

    public String getCpuTime() {
        return cpuTime;
    }
}
