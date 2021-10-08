package za.co.absa.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import za.co.absa.model.BookOrder;

public interface BookOrderRepository extends JpaRepository<BookOrder, Long> {

    BookOrder findByIsbn(String isbn);

}
