package io.gatling.tests.classes

import scala.concurrent.duration._

import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.jdbc.Predef._

class Login {

  def RunSuccessfulLogin() =
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

  def RunUnsuccessfulLogin() =
    scenario("Unsuccessful Login")
      .exec(
        http("Access Login Page")
          .get("/api/v1/resource/SESSION/1/Login")
          .check(jsonPath("$._id_").saveAs("sessId"))
          .check(status.is(200))
        )
      .exec(
        http("Enter incorrect credentials")
          .patch(s"/api/v1/resource/SESSION/1/")
          .body(
            StringBody(
              """
                |[
                |  {
                |    "op":"replace",
                |    "path":"/Login/${sessId}/Login/${sessId}/Userid",
                |    "value":"wrong"
                |  },
                |  {
                |    "op":"replace",
                |    "path":"/Login/${sessId}/Login/${sessId}/Password",
                |    "value":"password"
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
        http("MyScripts page cannot be accessed when not logged in")
          .get("/api/v1/resource/SESSION/1/MyScripts")
          .check(status.is(401))
        )
}
