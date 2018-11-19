package catalogue;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

public class CatalogueTest {

    @Test
    @DisplayName("Catalogue Service unit test")
    public void testCatalogue() {


        System.out.println("running unit test");


    }

    @Test
    @DisplayName("Catalogue Service unit test")
    @Disabled
    public void alwaysFail() {


        fail("Failed a test");

    }

}
