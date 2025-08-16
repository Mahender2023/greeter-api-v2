package com.example.greeter_api_v2;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.CrossOrigin;

// @RestController tells Spring this class will handle incoming web requests.
@RestController
public class GreetingController {

    // A simple Java "record" to hold our response data.
    // Spring will automatically convert this to JSON.
    public record Greeting(String message) {}

    // @CrossOrigin is essential for local development. It tells the browser
    // that it's okay for our Angular app (on port 4200) to make a request
    // to this backend (on port 8080).
    @CrossOrigin(origins = "*")

    // @GetMapping maps HTTP GET requests for the "/api/greet" path to this method.
    @GetMapping("/api/greet")
    public Greeting getGreeting(@RequestParam(defaultValue = "World") String name) {
        // Create the greeting message.
        String message = String.format("Hello, %s! Greetings from the V2 server!", name);
        
        // Return the Greeting object. Spring handles the rest.
        return new Greeting(message);
    }
}