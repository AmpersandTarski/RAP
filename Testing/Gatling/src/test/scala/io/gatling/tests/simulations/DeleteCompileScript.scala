package io.gatling.tests.simulations

import io.gatling.core.Predef.Simulation
import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.jdbc.Predef._
import io.gatling.tests.common.RAPDefaults
import io.gatling.tests.scenarios.RAPScenarios

class DeleteCompileScript extends Simulation {
  setUp(
    RAPScenarios.runDeleteAllScripts
      .inject(atOnceUsers(1))
      .protocols(RAPDefaults.httpProtocol)
  )

}
