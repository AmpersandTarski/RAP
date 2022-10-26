package io.gatling.tests.requests

import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.jdbc.Predef._

object RAPRequests {
  val getLogin = http("Access Login Page")
    .get("/api/v1/resource/SESSION/1/Login")
    .check(jsonPath("$._id_").saveAs("sessId"))
    .check(status.is(200))

  val patchCorrectLogin = http("Enter correct credentials (username and password)")
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

  val patchIncorrectLogin = http("Enter incorrect credentials")
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

  val getMyScript = http("Access MyScripts page when logged in")
    .get("/api/v1/resource/SESSION/1/MyScripts")
}
