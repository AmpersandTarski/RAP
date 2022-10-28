package io.gatling.tests.simulations

import io.gatling.tests.common.RAPDefaults
import io.gatling.tests.scenarios.RAPScenarios
import io.gatling.core.Predef.*
import io.gatling.http.Predef.*
import io.gatling.jdbc.Predef.*

class UnsuccessfulLogin extends Simulation {
  setUp(
    RAPScenarios.runUnsuccessfulLogin
                .inject(atOnceUsers(1))
                .protocols(RAPDefaults.httpProtocol)
    )
}
