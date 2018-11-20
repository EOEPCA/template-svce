package catalogue;

import com.fasterxml.jackson.databind.ObjectMapper;
import io.kubernetes.client.models.V1Job;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

import java.io.IOException;

public class SearchCatalogue {


    private static String endpointUrl = "";

    public static final String SEARCH_SERVICE_HOST = "SEARCH_SERVICE_HOST";
    public static final String SEARCH_SERVICE_PORT = "SEARCH_SERVICE_PORT";

    public static final String DEFAULT_HOST = "localhost";  // defaults when running as a JAR file outside of Docker
    public static final int DEFAULT_PORT = 7000;

    @BeforeAll
    public static void endpointURL() {
        String host = System.getenv(SEARCH_SERVICE_HOST);
        String port = System.getenv(SEARCH_SERVICE_PORT);

        if (host == null) {

            host = DEFAULT_HOST;
        }

        if (port == null) {
            port = String.valueOf(DEFAULT_PORT);
        }

        endpointUrl = "http://"+host+":"+port;
    }

    @Test
    @DisplayName("Search the catalogue for dataset")
    public void searchForDataset() throws IOException {
        OkHttpClient client = new OkHttpClient();


        Request request = new Request.Builder()
            .url(endpointUrl+"/search")
            .build();

        Response response = client.newCall(request).execute();
        assertEquals(200, response.code());

        ObjectMapper mapper = new ObjectMapper();

        Output out = mapper.readValue(response.body().string(), Output.class);

        assertEquals("search results", out.result);
    }

    @Test
    @DisplayName("Spawns a batch job")
    public void spawnJob() throws IOException {
        OkHttpClient client = new OkHttpClient();


        Request request = new Request.Builder()
                .url(endpointUrl+"/process")
                .build();

        Response response = client.newCall(request).execute();
        //assertEquals(200, response.code());

//        ObjectMapper mapper = new ObjectMapper();
//
//        V1Job out = mapper.readValue(response.body().string(), V1Job.class);
//
//        System.out.println(out);
        //assertEquals("search results", out.result);
    }


    @Test
    @DisplayName("No Op Test to test Gradle logging")
    @Disabled
    public void noopTest() {
        System.out.println("No-Op test to stdout");
    }

    @Test
    @DisplayName("Always Fail Test to test Gradle logging")
    @Disabled
    public void failingTest() {
        System.out.println("Failing test to stdout");
        fail("I've failed!");
    }
}
