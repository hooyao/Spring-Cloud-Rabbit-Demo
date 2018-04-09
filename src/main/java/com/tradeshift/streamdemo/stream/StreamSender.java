package com.tradeshift.streamdemo.stream;

import java.util.Collections;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.stream.annotation.EnableBinding;
import org.springframework.cloud.stream.binding.BinderAwareChannelResolver;
import org.springframework.http.MediaType;
import org.springframework.messaging.MessageHeaders;
import org.springframework.messaging.support.MessageBuilder;

import com.tradeshift.streamdemo.dto.HelloDTO;

@EnableBinding
public class StreamSender {

    @Autowired
    private BinderAwareChannelResolver resolver;


    public void sendMessage(HelloDTO message) {
        this.resolver.resolveDestination("outputChannel1").send(MessageBuilder.createMessage(message,
                new MessageHeaders(Collections.singletonMap(MessageHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_UTF8_VALUE))));
    }
}
