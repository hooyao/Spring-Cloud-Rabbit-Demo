package com.tradeshift.streamdemo.dto;

import java.util.UUID;

import com.fasterxml.jackson.annotation.JsonProperty;

public class HelloDTO {

    @JsonProperty("Id")
    private UUID id;

    @JsonProperty("Message")
    private String message;

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public static final class HelloDTOBuilder {
        private UUID id;
        private String message;

        private HelloDTOBuilder() {
        }

        public static HelloDTOBuilder newHelloDTO() {
            return new HelloDTOBuilder();
        }

        public HelloDTOBuilder withId(UUID id) {
            this.id = id;
            return this;
        }

        public HelloDTOBuilder withMessage(String message) {
            this.message = message;
            return this;
        }

        public HelloDTO build() {
            HelloDTO helloDTO = new HelloDTO();
            helloDTO.setId(id);
            helloDTO.setMessage(message);
            return helloDTO;
        }
    }
}
