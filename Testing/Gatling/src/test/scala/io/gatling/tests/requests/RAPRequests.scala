package io.gatling.tests.requests

import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.jdbc.Predef._

object RAPRequests {
  val getHome = http("Access Home page")
    .get("/")
    .check(status.is(200))

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

  val getMyScriptReturns200 = http("User can access MyScripts page")
    .get("/api/v1/resource/SESSION/1/MyScripts")
    .check(status.is(200))

  val getMyScriptReturns401 = http("User cannot access MyScripts page")
    .get("/api/v1/resource/SESSION/1/MyScripts")
    .check(status.is(401))

  val postNewScript = http("Post NewScript")
    .post("/api/v1/resource/Script")
    .check(jsonPath("$._id_").saveAs("scriptId"))
    .check(status.is(200))

  val patchNewScript = http("Changing NewScript values and compile")
    .patch("/api/v1/resource/Script/Script_${scriptId}/Nieuw_32_script")
    .body(RawFileBody("io/gatling/tests/requests/new_script.json")).asJson

  val getMyScriptsScriptId = http("Access the created NewScript from MyScripts page")
    .get("/api/v1/resource/Script/Script_${scriptId}/Nieuw_32_script")
    .check(status.is(200))
}
