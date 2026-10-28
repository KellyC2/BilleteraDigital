import com.intuit.karate.junit5.Karate;

public class FlujoPrincipalTest {
    @Karate.Test
    Karate testFlujoPrincipal() {
        return Karate.run("classpath:FlujoPrincipal.feature");
    }
}
