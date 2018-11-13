package catalogue;

import io.javalin.Javalin;


public class CatalogueService {

    public static void main(String[] args) {
        Javalin app = Javalin.create().start(7000);

        app.get("/ping", ctx -> ctx.result("Hello World "));

        app.get("/search", ctx -> {
          Output out = new Output();
          out.result = "search results...";
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
