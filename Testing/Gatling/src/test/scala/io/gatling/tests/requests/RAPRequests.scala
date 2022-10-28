package io.gatling.tests.requests

import io.gatling.core.Predef.*
import io.gatling.http.Predef.*
import io.gatling.jdbc.Predef.*

object RAPRequests {
  val getHome = http("Access Home page")
    .get("/")

  val getLogin = http("Access Login Page")
    .get("/api/v1/resource/SESSION/1/Login")
    .check(jsonPath("$._id_").saveAs("sessId"))
    .check(status.is(200))

  val patchCorrectLogin = http("Enter correct credentials (username and password)")
    .patch(s"/api/v1/resource/SESSION/1/")
    .body(
      ElFileBody("io/gatling/tests/requests/correct_login.json")).asJson

  val patchIncorrectLogin = http("Enter incorrect credentials")
    .patch(s"/api/v1/resource/SESSION/1/")
    .body(
      ElFileBody("io/gatling/tests/requests/incorrect_login.json")).asJson

  val getMyScript = http("Access MyScripts page")
    .get("/api/v1/resource/SESSION/1/MyScripts")
}
