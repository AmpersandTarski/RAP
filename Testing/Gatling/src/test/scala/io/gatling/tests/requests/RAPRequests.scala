package io.gatling.tests.requests

import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.jdbc.Predef._

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

  val postNewScript = http("Post NewScript")
    .post("/api/v1/resource/Script")
    .check(jsonPath("$._id_").saveAs("scriptId"))
    .check(status.is(200))

  val patchNewScript = http("Changing NewScript Values")
    .patch("/api/v1/resource/Script/Script_${scriptId}/Nieuw_32_script")
    .body(RawFileBody("io/gatling/tests/requests/new_script.json")).asJson

  val getMyScriptsScriptId = http("Access Created NewScript from MyScripts")
    .get("/api/v1/resource/Script/Script_${scriptId}/Nieuw_32_script")
    .check(status.is(200))
}
