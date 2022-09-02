package com.techelevator.model;

public class CompilerDTO {

    private String clientId;
    private String clientSecret;
    private String script;
    private String language;
    private String versionIndex;


    public CompilerDTO(String language, String script) {
        this.clientId = "2710436fcda1b8b12c0b8aa569ef8ac5";
        this.clientSecret = "6152bfce6c5091e7efcc82b3c071173b5a94ffe8601345cc5edf4606d0f5d00";
        this.script = script;
        this.language = language;
        this.versionIndex = "0";

    }

    public String getClientId() {
        return clientId;
    }

    public void setClientId(String clientId) {
        this.clientId = clientId;
    }

    public String getClientSecret() {
        return clientSecret;
    }

    public void setClientSecret(String clientSecret) {
        this.clientSecret = clientSecret;
    }

    public String getScript() {
        return script;
    }

    public void setScript(String script) {
        this.script = script;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public String getVersionIndex() {
        return versionIndex;
    }

    public void setVersionIndex(String versionIndex) {
        this.versionIndex = versionIndex;
    }
}
