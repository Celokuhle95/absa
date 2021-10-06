package za.co.absa.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HomeController {

    @GetMapping("/")
    public String home() {
        return "Welcome to Book Shop Orders API, options available: <br><br>" +
                "View all: <b>http://localhost:8080/api/orders/all </b><br>" +
                "Find by ISBN: <b>http://localhost:8080/api/orders/get-by-isbn/{isbn} </b><br>" +
                "Create: <b>http://localhost:8080/api/orders/place </b><br>" +
                "--> json body example: { \"isbn\": \"string\",\n" +
                "    \"quantity\": number,\n" +
                "    \"dateOrdered\": date,\n" +
                "    \"bookTitle\": \"string\",\n" +
                "    \"author\": \"string\" }";

    }
}
