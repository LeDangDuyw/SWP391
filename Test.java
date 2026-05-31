import java.io.InputStream;
import java.net.URL;

public class Test {
    public static void main(String[] args) {
        URL url = Test.class.getResource("../ConnectDB.properties");
        System.out.println("Class ../ConnectDB.properties: " + url);
    }
}
