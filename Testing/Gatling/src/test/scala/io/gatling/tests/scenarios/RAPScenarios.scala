package io.gatling.tests.scenarios

import io.gatling.tests.requests.RAPRequests
import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.jdbc.Predef._

object RAPScenarios {
  val runSuccessfulLogin =
    scenario("Successful Login Scenario")
      .exec(RAPRequests.getHome)
      .exec(RAPRequests.getLogin)
      .exec(RAPRequests.patchCorrectLogin)
      .exec(RAPRequests.getMyScriptReturns200)

  val runUnsuccessfulLogin =
    scenario("Unsuccessful Login Scenario")
      .exec(RAPRequests.getHome)
      .exec(RAPRequests.getLogin)
      .exec(RAPRequests.patchIncorrectLogin)
      .exec(RAPRequests.getMyScriptReturns401)

  val runCreateNewScript = scenario("Creation of a new script Scenario")
    .exec(RAPRequests.getHome)
    .exec(RAPRequests.getLogin)
    .exec(RAPRequests.patchCorrectLogin)
    .exec(RAPRequests.getMyScriptReturns200)
    .exec(RAPRequests.postNewScript)
    .exec(RAPRequests.patchNewScriptName)
    .exec(RAPRequests.patchNewScriptContent)
    .exec(RAPRequests.getMyScriptsScriptId)

  val runCompileNewScript = scenario("Compiling a new script Scenario")
    .exec(RAPRequests.getHome)
    .exec(RAPRequests.getLogin)
    .exec(RAPRequests.patchCorrectLogin)
    .exec(RAPRequests.getMyScriptReturns200)
    .exec(RAPRequests.postNewScript)
    .exec(RAPRequests.patchNewScriptName)
    .exec(RAPRequests.patchNewScriptContent)
    .exec(RAPRequests.patchNewScriptCompile)
    .exec(RAPRequests.getMyScriptsScriptId)

  val runSuccessfulRegister = scenario("Successful Register scenario")
    .exec(RAPRequests.getLogin)
    .exec(RAPRequests.getRegister)
    .exec(RAPRequests.patchCorrectRegister)
    .exec(RAPRequests.getMyAccountReturns200)

  val runUnsuccessfulRegister = scenario("Unsuccessful Register scenario")
    .exec(RAPRequests.getLogin)
    .exec(RAPRequests.getRegister)
    .exec(RAPRequests.patchIncorrectRegister)
    .exec(RAPRequests.getMyAccountReturns401)

  val runUnsuccessfulCompile = scenario("Unsuccessful compile scenario")
    .exec(RAPRequests.getHome)
    .exec(RAPRequests.getLogin)
    .exec(RAPRequests.patchCorrectLogin)
    .exec(RAPRequests.getMyScriptReturns200)
    .exec(RAPRequests.postNewScript)
    .exec(RAPRequests.patchIncorrectCompileScriptContent)
    .exec(RAPRequests.getCheckErrorMessage)

  val runSuccessfulCompileButtons = scenario("Run successful script and press the script buttons")
    .exec(RAPRequests.getHome)
    .exec(RAPRequests.getLogin)
    .exec(RAPRequests.patchCorrectLogin)
    .exec(RAPRequests.getMyScriptReturns200)
    .exec(RAPRequests.postNewScript)
    .exec(RAPRequests.patchCorrectCompileScriptContentAndName)
    .exec(RAPRequests.patchCorrectButtons)

  val runDeleteAllScripts = scenario("Compile three scripts and delete those scripts")
    .exec(RAPRequests.getHome)
    .exec(RAPRequests.getLogin)
    .exec(RAPRequests.patchCorrectLogin)
    .exec(RAPRequests.getMyScriptReturns200)
    .exec(RAPRequests.postNewScript)
    .exec(RAPRequests.patchCorrectCompileScriptContentAndName)
    .exec(RAPRequests.deleteScripts)
    .exec(RAPRequests.postNewScript)
    .exec(RAPRequests.patchCorrectCompileScriptContentAndName)
    .exec(RAPRequests.deleteScripts)
    .exec(RAPRequests.postNewScript)
    .exec(RAPRequests.patchCorrectCompileScriptContentAndName)
    .exec(RAPRequests.deleteScripts)
}
