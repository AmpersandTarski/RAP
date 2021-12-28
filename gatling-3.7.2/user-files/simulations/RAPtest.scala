
import scala.concurrent.duration._

// required for Gatling core structure DSL
import io.gatling.core.Predef._

// required for Gatling HTTP DSL
import io.gatling.http.Predef._

// can be omitted if you don't use jdbcFeeder
import io.gatling.jdbc.Predef._

// can be omitted if you don't use cookies
// import io.gatling.http.cookie._

// used for specifying durations with a unit, eg "5 minutes"
import scala.concurrent.duration._

class RAPtest extends Simulation {

  private val httpProtocol = http
    .baseUrl("http://localhost")
    .inferHtmlResources(AllowList(), DenyList())
    .acceptHeader("*/*")
    .acceptEncodingHeader("gzip, deflate")
    .acceptLanguageHeader("nl-NL,nl;q=0.9,en-US;q=0.8,en;q=0.7,de;q=0.6")
    .doNotTrackHeader("1")
    .userAgentHeader("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36")
  
  private val sessId = "4b0d07"

  private val headers_sessID = Map(
      "cookie" -> ("PHPSESSID="+sessId)
  )

  private val scn = scenario("RAPtest")
    .exec(
      http("Home")
        .get("/")
        .headers(headers_sessID)
    )
    .pause(2)
    .exec(
    http("Display the login screen")
      .get("/api/v1/resource/SESSION/1/Login")
      .headers(headers_sessID)
    )
    .pause(2)
    .exec(
      http("Fill Userid/Password")
        .patch("/api/v1/resource/SESSION/1")
        .headers(headers_sessID)
        .body(StringBody(""" [{ "op":"replace",
                                "path":"/Login/"""+sessId+"""/Login/"""+sessId+"""/Userid",
                                "value":"stefj"
                              },
                              { "op":"replace",
                                "path":"/Login/"""+sessId+"""/Login/"""+sessId+"""/Password",
                                "value":"welkom"
                              },
                              { "op":"replace",
                                "path":"/Login/"""+sessId+"""/Login/"""+sessId+"""/Login/property",
                                "value":true
                              }] """)).asJson
    )
    .pause(2)
    .exec(
      http("Display MyScripts")
        .get("/api/v1/resource/SESSION/1/MyScripts")
        .headers(headers_sessID)
    )

	setUp(scn.inject(atOnceUsers(1))).protocols(httpProtocol)
}
