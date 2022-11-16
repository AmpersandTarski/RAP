package io.gatling.tests.requests

import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.jdbc.Predef._
import io.gatling.tests.common

object RAPRequests {
  val getHome = http("User gets Home page")
    .get("/")
    .check(status.is(200))

  val getLogin = http("User gets Login Page")
    .get("/api/v1/resource/SESSION/1/Login")
    .check(jsonPath("$._id_").saveAs("sessId"))
    .check(status.is(200))

  val getRegister = http("User gets register page (by sessId)")
    .patch("/api/v1/resource/SESSION/1")
    .body(ElFileBody("io/gatling/tests/requests/get_register.json")).asJson
    .resources(
      http("Save register ID as regId")
        .get("/api/v1/resource/SESSION/1/Login")
        .check(jsonPath("$.Register._id_").saveAs("regId"))
        .check(status.is(200)))

  val patchCorrectLogin = http("User enters correct credentials (username and password)")
    .patch(s"/api/v1/resource/SESSION/1/")
    .body(ElFileBody("io/gatling/tests/requests/correct_login.json")).asJson
    .check(status.is(200))

  val patchIncorrectLogin = http("User enters incorrect credentials")
    .patch(s"/api/v1/resource/SESSION/1/")
    .body(ElFileBody("io/gatling/tests/requests/incorrect_login.json")).asJson
    .check(status.is(200))

  val patchCorrectRegister = http("User enters register credentials (userId does not exist yet)")
    .patch("/api/v1/resource/SESSION/1")
    .body(ElFileBody("io/gatling/tests/requests/correct_register.json")).asJson
    .check(status.is(200))

  val getMyAccountReturns200 = http("User gets MyAccount")
    .get("/api/v1/resource/SESSION/1/MyAccount")
    .check(status.is(200))

  val getMyScriptReturns200 = http("User can get MyScripts page")
    .get("/api/v1/resource/SESSION/1/MyScripts")
    .check(status.is(200))

  val getMyScriptReturns401 = http("User cannot get MyScripts page")
    .get("/api/v1/resource/SESSION/1/MyScripts")
    .check(status.is(401))

  val postNewScript = http("User posts NewScript")
    .post("/api/v1/resource/Script")
    .check(jsonPath("$._id_").saveAs("scriptId"))
    .check(status.is(200))

  val patchNewScriptName = http("User changes NewScript assignment name")
    .patch("/api/v1/resource/Script/Script_${scriptId}/Nieuw_32_script")
    .body(RawFileBody("io/gatling/tests/requests/new_script_name.json")).asJson
    .check(status.is(200))

  val patchNewScriptContent = http("User changes NewScript script content")
    .patch("/api/v1/resource/Script/Script_${scriptId}/Nieuw_32_script")
    .body(RawFileBody("io/gatling/tests/requests/new_script_content.json")).asJson
    .check(status.is(200))

  val patchNewScriptCompile = http("User compiles the NewScript")
    .patch("/api/v1/resource/Script/Script_${scriptId}/Nieuw_32_script")
    .body(RawFileBody("io/gatling/tests/requests/new_script_compile.json")).asJson
    .check(jsonPath("$.content.Actual_32_info.Compiler_32_message").is("This script of Enrollment contains no type errors."))
    .check(status.is(200))

  val getMyScriptsScriptId = http("User gets the newly created NewScript from MyScripts page")
    .get("/api/v1/resource/Script/Script_${scriptId}/Nieuw_32_script")
    .check(status.is(200))

  val patchIncorrectRegister = http("User enters register credentials (userId does already exist)")
    .patch("/api/v1/resource/SESSION/1")
    .body(ElFileBody("io/gatling/tests/requests/incorrect_register.json")).asJson
    .check(status.is(200))

  val getMyAccountReturns401 = http("User cannot get into My Account page")
    .get("/api/v1/resource/SESSION/1/MyAccount")
    .check(status.is(401))

  val postScript = http("save the script ID as scrID")
    .post("/api/v1/resource/Script")
    .check(jsonPath("$._id_").saveAs("scrId"))
    .check(status.is(200))

  val patchIncorrectCompileScriptContent = http("User enters incorrect script content")
    .patch("/api/v1/resource/Script/${scrId}/Nieuw_32_script")
    .body(RawFileBody("io/gatling/tests/requests/incorrect_compile.json")).asJson
    .check(status.is(200))

  val patchIncorrectCompileScript = http("check error code")
    .get("/api/v1/resource/Script/${scrId}/Nieuw_32_script")
    .check(jsonPath("$.Actual_32_info.Compiler_32_message").saveAs("errMsg"))
    .check(substring("${errMsg}").exists)
    .check(status.is(200))

}