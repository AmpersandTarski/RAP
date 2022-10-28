package io.gatling.tests.simulations

import io.gatling.tests.common.RAPDefaults
import io.gatling.tests.scenarios.RAPScenarios
import io.gatling.core.Predef.*
import io.gatling.http.Predef.*
import io.gatling.jdbc.Predef.*

class SuccessfulLogin extends Simulation {
  setUp(
    RAPScenarios.runSuccessfulLogin
                .inject(atOnceUsers(1))
                .protocols(RAPDefaults.httpProtocol)
    )
}
