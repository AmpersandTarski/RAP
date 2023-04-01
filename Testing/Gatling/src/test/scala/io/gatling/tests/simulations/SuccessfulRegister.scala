package io.gatling.tests.simulations

import io.gatling.tests.common.RAPDefaults
import io.gatling.tests.scenarios.RAPScenarios
import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.jdbc.Predef._

class SuccessfulRegister extends Simulation {
  setUp(
    RAPScenarios.runSuccessfulRegister
      .inject(atOnceUsers(1))
      .protocols(RAPDefaults.httpProtocol)
  )
}
