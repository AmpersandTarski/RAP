package io.gatling.tests.scenarios

import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.jdbc.Predef._
import io.gatling.tests.requests.RAPRequests

object RAPScenarios {
  val runSuccessfulLogin =
    scenario("Successful Login Scenario")
      .exec(RAPRequests.getLogin)
      .exec(RAPRequests.patchCorrectLogin)
      .exec(RAPRequests.getMyScript
                       .check(status.is(200)))

  val runUnsuccessfulLogin =
    scenario("Unsuccessful Login")
      .exec(RAPRequests.getLogin)
      .exec(RAPRequests.patchIncorrectLogin)
      .exec(RAPRequests.getMyScript
                       .check(status.is(401)))
}
