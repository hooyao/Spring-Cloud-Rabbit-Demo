package com.tradeshift.streamdemo.rest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.tradeshift.streamdemo.dto.HelloDTO;
import com.tradeshift.streamdemo.stream.StreamSender;

@RestController
@RequestMapping("stream")
public class MessageController {

    @Autowired
    private StreamSender sender;

    @RequestMapping(path = "msg", method = RequestMethod.POST,
            consumes = MediaType.APPLICATION_JSON_UTF8_VALUE,
            produces = MediaType.TEXT_HTML_VALUE)
    public void getPremium(@RequestBody HelloDTO helloDTO) {
        System.out.print(helloDTO.getMessage());
        this.sender.sendMessage(helloDTO);
    }
}
