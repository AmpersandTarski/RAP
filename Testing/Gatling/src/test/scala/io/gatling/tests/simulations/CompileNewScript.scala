package io.gatling.tests.simulations

import io.gatling.core.Predef.*
import io.gatling.http.Predef.*
import io.gatling.jdbc.Predef.*
import io.gatling.tests.common.RAPDefaults
import io.gatling.tests.scenarios.RAPScenarios

class CompileNewScript extends Simulation {
  setUp(
    RAPScenarios.runCompileNewScript
                .inject(atOnceUsers(1))
                .protocols(RAPDefaults.httpProtocol)
    )
}
