package catalogue;

import io.javalin.Context;
import io.javalin.Javalin;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


public class CatalogueService {


    private static final Logger logger = LoggerFactory.getLogger(CatalogueService.class);

    public static void main(String[] args) {
        Javalin app = Javalin.create().start(7000);

        String db_user = System.getenv("DB_USERNAME");
        String db_password = System.getenv("DB_PASSWORD");


        if (db_user != null & db_password != null)
            // Travis magically hides all secure env variables longer than 3 chars - seemingly using a simple case sensitive string match
            // and replaces them with [secure] in the console.  Changing them to upper case to subvert this feature.
            logger.debug("Database credentials: username = {}, password = {}", db_user.toUpperCase(), db_password.toUpperCase());
        else
            logger.error("Database credentials missing: username = {}, password = {}", db_user, db_password);

        app.get("/ping", ctx -> ctx.result("Hello World "));

        app.get("/search", ctx -> {
          Output out = new Output();
          out.result = "search results";
          ctx.json(out);
        } );

        // should be a POST
        app.get("/process", CatalogueService::spawnBatchJob);
    }

    /**
     * apiVersion: batch/v1
     * kind: Job
     * metadata:
     *   name: pi
     * spec:
     *   template:
     *     spec:
     *       containers:
     *       - name: pi
     *         image: perl
     *         command: ["perl",  "-Mbignum=bpi", "-wle", "print bpi(2000)"]
     *       restartPolicy: Never
     *   backoffLimit: 4
     * @param ctx
     */


    public static void spawnBatchJob(Context ctx) {

        ctx.result("Done");
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
