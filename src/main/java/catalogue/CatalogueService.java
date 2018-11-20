package catalogue;

import io.javalin.Javalin;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


public class CatalogueService {


    private static final Logger logger = LoggerFactory.getLogger(CatalogueService.class);

    public static void main(String[] args) {
        Javalin app = Javalin.create().start(7000);

        logger.debug("Database credentials: username = {}, password = {}", System.getenv("DB_USERNAME").toUpperCase(), System.getenv("DB_PASSWORD"));
        

        app.get("/ping", ctx -> ctx.result("Hello World "));

        app.get("/search", ctx -> {
          Output out = new Output();
          out.result = "search results";
          ctx.json(out);
        } );
    }
}


class Output {

    String result;

    public String getResult() {
        return result;
    }

    public void setResult(String res) {
        result = res;
    }   
}
