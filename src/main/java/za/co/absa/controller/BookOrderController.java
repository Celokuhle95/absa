package za.co.absa.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import za.co.absa.model.BookOrder;
import za.co.absa.repository.BookOrderRepository;

import java.util.List;

@RestController
@RequestMapping("/api/orders")
public class BookOrderController {

    @Autowired
    private BookOrderRepository repository;

    @GetMapping("/all")
    public List<BookOrder> getAll() {
        return repository.findAll();
    }

    @PostMapping("/place")
    @ResponseStatus(HttpStatus.ACCEPTED)
    public void save(@RequestBody BookOrder order) {
        repository.save(order);
    }

    @GetMapping("/get-by-isbn/{isbn}")
    public BookOrder getByIsbn(@PathVariable String isbn) {
        return repository.findByIsbn(isbn);
    }
}
