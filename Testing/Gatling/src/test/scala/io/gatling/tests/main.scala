package io.gatling.tests

import scala.concurrent.duration._

import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.jdbc.Predef._

import io.gatling.tests.classes._

class Main extends Simulation {

  val BASE_URL: String = "https://rap.cs.ou.nl"

  val httpProtocol = http
    .baseUrl(BASE_URL)
    .inferHtmlResources(BlackList(""".*\.js""", """.*\.css""", """.*\.gif""", """.*\.jpeg""", """.*\.jpg""", """.*\.ico""", """.*\.woff""", """.*\.woff2""", """.*\.(t|o)tf""", """.*\.png""", """.*detectportal\.firefox\.com.*"""), WhiteList())
    .acceptHeader("application/json, text/plain, */*")
    .acceptEncodingHeader("gzip, deflate")
    .acceptLanguageHeader("en-GB,en;q=0.9,en-US;q=0.8,nl;q=0.7")
    .userAgentHeader("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36 Edg/106.0.1370.47")

  var scn =
    scenario("Successful Login")
      .exec(
        http("Access Login Page")
          .get("/api/v1/resource/SESSION/1/Login")
          .check(jsonPath("$._id_").saveAs("sessId"))
          .check(status.is(200))
        )
      .exec(
        http("Enter correct credentials (username and password)")
          .patch(s"/api/v1/resource/SESSION/1/")
          .body(
            StringBody(
              """
                |[
                |  {
                |    "op":"replace",
                |    "path":"/Login/${sessId}/Login/${sessId}/Userid",
                |    "value":"pinda"
                |  },
                |  {
                |    "op":"replace",
                |    "path":"/Login/${sessId}/Login/${sessId}/Password",
                |    "value":"kaas"
                |  },
                |  {
                |    "op":"replace",
                |    "path":"/Login/${sessId}/Login/${sessId}/Login/property",
                |    "value":true
                |  }
                |]
                |""".stripMargin)).asJson
        )
      .exec(
        http("Access MyScripts page when logged in")
          .get("/api/v1/resource/SESSION/1/MyScripts")
          .check(status.is(200))
        )

  // Runs in parallel
  setUp(scn.inject(atOnceUsers(1)).protocols(httpProtocol))
}
