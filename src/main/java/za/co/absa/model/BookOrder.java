package za.co.absa.model;

import lombok.Data;

import javax.persistence.*;
import java.util.Date;

@Entity
@Data
public class BookOrder {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    @Column
    private String isbn;

    @Column(nullable = false)
    private Integer quantity;

    @Column(nullable = false)
    private Date dateOrdered;

    @Column
    private String bookTitle;

    @Column
    private String author;

}
