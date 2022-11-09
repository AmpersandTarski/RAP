package io.gatling.tests.simulations

import io.gatling.tests.common.RAPDefaults
import io.gatling.tests.scenarios.RAPScenarios
import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.jdbc.Predef._

class UnsuccessfulRegister extends Simulation {
  setUp(
    RAPScenarios.runUnsuccessfulRegister
      .inject(atOnceUsers(1))
      .protocols(RAPDefaults.httpProtocol)
  )
}
