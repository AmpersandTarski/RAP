package io.gatling.tests.scenarios

import io.gatling.tests.requests.RAPRequests
import io.gatling.core.Predef.*
import io.gatling.http.Predef.*
import io.gatling.jdbc.Predef.*

object RAPScenarios {
  val runSuccessfulLogin =
    scenario("Successful Login Scenario")
      .exec(RAPRequests.getLogin)
      .exec(RAPRequests.patchCorrectLogin)
      .exec(RAPRequests.getMyScript
                       .check(status.is(200)))

  val runUnsuccessfulLogin =
    scenario("Unsuccessful Login Scenario")
      .exec(RAPRequests.getLogin)
      .exec(RAPRequests.patchIncorrectLogin)
      .exec(RAPRequests.getMyScript
                       .check(status.is(401)))
}
