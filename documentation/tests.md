# Test Documentation
RAP is tested with the [Gatling](https://gatling.io/) framework. Gatling is a tool for web applications, designed for DevOps and Continuous Integration. In RAP, Gatling is used to make automated tests of the functionality of RAP.

Gatling enables the creation of **simulations**. These simulations simulate a user's behaviour so that the tests can see if the application does the expected behaviour.

## Folder Structure
This is the recommended folder structure by [liatrio](https://github.com/liatrio/gatling-maven-showcase).
```
.
|__ src
   |__ test
      |__ scala
         |__ io/gatling/tests
            |__ common
            |__ requests
            |__ scenarios
            |__ simulations
```

## Example Simulation
A test simulation consists of the setup which takes the scenario, where the scenario executes a series of http requests.

```
package computerdatabase // 1

import scala.concurrent.duration._

// 2
import io.gatling.core.Predef._
import io.gatling.http.Predef._

class BasicSimulation extends Simulation { // 3

  val httpProtocol = http // 4
    .baseUrl("http://computer-database.gatling.io") // 5
    .acceptHeader("text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8") // 6
    .doNotTrackHeader("1")
    .acceptLanguageHeader("en-US,en;q=0.5")
    .acceptEncodingHeader("gzip, deflate")
    .userAgentHeader("Mozilla/5.0 (Windows NT 5.1; rv:31.0) Gecko/20100101 Firefox/31.0")

  val scn = scenario("BasicSimulation") // 7
    .exec(
      http("request_1") // 8
        .get("/")) // 9
    .pause(5) // 10

  setUp( // 11
    scn.inject(atOnceUsers(1)) // 12
  ).protocols(httpProtocol) // 13
}
```
1. The optional package.
2. The required imports.
3. The class declaration. Note that it extends Simulation.
4. The common configuration to all HTTP requests.
5. The baseUrl that will be prepended to all relative urls.
6. Common HTTP headers that will be sent with all the requests.
7. The scenario definition.
8. An HTTP request, named request_1. This name will be displayed in the final reports.
9. The url this request targets with the GET method.
10. Some pause/think time.
11. Where one sets up the scenarios that will be launched in this Simulation.
12. Declaring that we will inject one single user into the scenario named scn.
13. Attaching the HTTP configuration declared above.

More details regarding the Gatling tests can be found [here](https://gatling.io/docs/gatling/tutorials/quickstart/)

## Test Simulations
Test simulations try to simulate the user's behaviour. This way, tests can be created to see if the simulated user's behaviour also gives the expected results of the application. The test simulations are the following:

1. A user can login when credentials are correct
2. A user cannot login when credentials are incorrect
3. A user can register
4. A user cannot register when the user already exists
5. A user can create a new script
6. A user can compile a script
