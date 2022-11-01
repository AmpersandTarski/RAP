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

  val runCreateNewScript = scenario("RecordedSimulation")
    .exec(RAPRequests.getHome)
    .exec(RAPRequests.getLogin)
    .exec(RAPRequests.patchCorrectLogin)
    .exec(RAPRequests.getMyScriptReturns200)
    .exec(RAPRequests.postNewScript)
    .exec(RAPRequests.patchNewScript)
    .exec(RAPRequests.getMyScriptsScriptId)
}
