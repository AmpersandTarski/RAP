package io.gatling.tests

import scala.concurrent.duration._

import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.jdbc.Predef._

class RecordedSimulation3 extends Simulation {

  val httpProtocol = http
    .baseUrl("https://rap.cs.ou.nl")
    .inferHtmlResources(BlackList(""".*\.js""", """.*\.css""", """.*\.gif""", """.*\.jpeg""", """.*\.jpg""", """.*\.ico""", """.*\.woff""", """.*\.woff2""", """.*\.(t|o)tf""", """.*\.png""", """.*detectportal\.firefox\.com.*"""), WhiteList())

  val headers_0 = Map(
    "accept" -> "*/*",
    "accept-encoding" -> "gzip, deflate, br",
    "accept-language" -> "nl-NL,nl;q=0.9,en-US;q=0.8,en;q=0.7",
    "authorization" -> "SAPISIDHASH 1669108882_355e1816cb9af3ab0ba2916e7c7e7791446544b0",
    "content-type" -> "application/json",
    "origin" -> "https://www.youtube.com",
    "sec-ch-ua" -> """Google Chrome";v="107", "Chromium";v="107", "Not=A?Brand";v="24""",
    "sec-ch-ua-mobile" -> "?0",
    "sec-ch-ua-platform" -> "Windows",
    "sec-fetch-dest" -> "empty",
    "sec-fetch-mode" -> "cors",
    "sec-fetch-site" -> "same-origin",
    "user-agent" -> "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36",
    "x-client-data" -> "CIm2yQEIo7bJAQjBtskBCKmdygEIlaHLAQjG4cwBCO7tzAEIpPvMAQio/MwB",
    "x-goog-authuser" -> "0",
    "x-goog-pageid" -> "undefined",
    "x-goog-request-time" -> "1669108882889",
    "x-goog-visitor-id" -> "Cgt3YUNibjJBZ1d6YyiFqfKbBg%3D%3D",
    "x-origin" -> "https://www.youtube.com",
    "x-youtube-ad-signals" -> "dt=1669108871548&flash=0&frm=2&u_tz=60&u_his=24&u_h=864&u_w=1536&u_ah=864&u_aw=1536&u_cd=24&bc=31&bih=-12245933&biw=-12245933&brdim=0%2C0%2C0%2C0%2C1536%2C0%2C1536%2C864%2C560%2C315&vis=1&wgl=true&ca_type=image",
    "x-youtube-client-name" -> "56",
    "x-youtube-client-version" -> "1.20221116.01.00",
    "x-youtube-time-zone" -> "Europe/Amsterdam",
    "x-youtube-utc-offset" -> "60")

  val headers_1 = Map(
    "accept" -> "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
    "accept-encoding" -> "gzip, deflate, br",
    "accept-language" -> "nl-NL,nl;q=0.9,en-US;q=0.8,en;q=0.7",
    "sec-ch-ua" -> """Google Chrome";v="107", "Chromium";v="107", "Not=A?Brand";v="24""",
    "sec-ch-ua-mobile" -> "?0",
    "sec-ch-ua-platform" -> "Windows",
    "sec-fetch-dest" -> "document",
    "sec-fetch-mode" -> "navigate",
    "sec-fetch-site" -> "same-origin",
    "sec-fetch-user" -> "?1",
    "upgrade-insecure-requests" -> "1",
    "user-agent" -> "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36")

  val headers_2 = Map(
    "User-Agent" -> "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36",
    "sec-ch-ua" -> """Google Chrome";v="107", "Chromium";v="107", "Not=A?Brand";v="24""",
    "sec-ch-ua-mobile" -> "?0",
    "sec-ch-ua-platform" -> "Windows")

  val headers_8 = Map(
    "Accept" -> "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
    "Service-Worker-Navigation-Preload" -> "true",
    "Upgrade-Insecure-Requests" -> "1",
    "User-Agent" -> "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36",
    "sec-ch-ua" -> """Google Chrome";v="107", "Chromium";v="107", "Not=A?Brand";v="24""",
    "sec-ch-ua-mobile" -> "?0",
    "sec-ch-ua-platform" -> "Windows")

  val headers_9 = Map(
    "accept" -> "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
    "accept-encoding" -> "gzip, deflate, br",
    "accept-language" -> "nl-NL,nl;q=0.9,en-US;q=0.8,en;q=0.7",
    "sec-ch-ua" -> """Google Chrome";v="107", "Chromium";v="107", "Not=A?Brand";v="24""",
    "sec-ch-ua-mobile" -> "?0",
    "sec-ch-ua-platform" -> "Windows",
    "sec-fetch-dest" -> "iframe",
    "sec-fetch-mode" -> "navigate",
    "sec-fetch-site" -> "cross-site",
    "service-worker-navigation-preload" -> "true",
    "upgrade-insecure-requests" -> "1",
    "user-agent" -> "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36",
    "x-client-data" -> "CIm2yQEIo7bJAQjBtskBCKmdygEIlaHLAQjG4cwBCO7tzAEIpPvMAQio/MwB")

  val headers_10 = Map(
    "accept" -> "application/json, text/plain, */*",
    "accept-encoding" -> "gzip, deflate, br",
    "accept-language" -> "nl-NL,nl;q=0.9,en-US;q=0.8,en;q=0.7",
    "sec-ch-ua" -> """Google Chrome";v="107", "Chromium";v="107", "Not=A?Brand";v="24""",
    "sec-ch-ua-mobile" -> "?0",
    "sec-ch-ua-platform" -> "Windows",
    "sec-fetch-dest" -> "empty",
    "sec-fetch-mode" -> "cors",
    "sec-fetch-site" -> "same-origin",
    "user-agent" -> "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36")

  val headers_11 = Map(
    "accept" -> "*/*",
    "accept-encoding" -> "gzip, deflate, br",
    "accept-language" -> "nl-NL,nl;q=0.9,en-US;q=0.8,en;q=0.7",
    "content-type" -> "application/json+protobuf",
    "origin" -> "https://www.youtube.com",
    "sec-ch-ua" -> """Google Chrome";v="107", "Chromium";v="107", "Not=A?Brand";v="24""",
    "sec-ch-ua-mobile" -> "?0",
    "sec-ch-ua-platform" -> "Windows",
    "sec-fetch-dest" -> "empty",
    "sec-fetch-mode" -> "cors",
    "sec-fetch-site" -> "cross-site",
    "user-agent" -> "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36",
    "x-client-data" -> "CIm2yQEIo7bJAQjBtskBCKmdygEIlaHLAQjG4cwBCO7tzAEIpPvMAQio/MwB",
    "x-goog-api-key" -> "AIzaSyDyT5W0Jh49F30Pqqtyfdf7pDLFKLJoAnw",
    "x-user-agent" -> "grpc-web-javascript/0.1")

  val headers_15 = Map(
    "accept" -> "image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8",
    "accept-encoding" -> "gzip, deflate, br",
    "accept-language" -> "nl-NL,nl;q=0.9,en-US;q=0.8,en;q=0.7",
    "sec-ch-ua" -> """Google Chrome";v="107", "Chromium";v="107", "Not=A?Brand";v="24""",
    "sec-ch-ua-mobile" -> "?0",
    "sec-ch-ua-platform" -> "Windows",
    "sec-fetch-dest" -> "image",
    "sec-fetch-mode" -> "no-cors",
    "sec-fetch-site" -> "same-origin",
    "user-agent" -> "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36",
    "x-client-data" -> "CIm2yQEIo7bJAQjBtskBCKmdygEIlaHLAQjG4cwBCO7tzAEIpPvMAQio/MwB")

  val headers_16 = Map(
    "accept" -> "application/json, text/plain, */*",
    "accept-encoding" -> "gzip, deflate, br",
    "accept-language" -> "nl-NL,nl;q=0.9,en-US;q=0.8,en;q=0.7",
    "content-type" -> "application/json",
    "origin" -> "https://rap.cs.ou.nl",
    "sec-ch-ua" -> """Google Chrome";v="107", "Chromium";v="107", "Not=A?Brand";v="24""",
    "sec-ch-ua-mobile" -> "?0",
    "sec-ch-ua-platform" -> "Windows",
    "sec-fetch-dest" -> "empty",
    "sec-fetch-mode" -> "cors",
    "sec-fetch-site" -> "same-origin",
    "user-agent" -> "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36")


  val scn = scenario("RecordedSimulation3")

    .exec(http("request_16")
      .post("/api/v1/resource/Script")
      .headers(headers_16)
      .body(RawFileBody("io/gatling/tests/recordedsimulation3/0016_request.json"))
      .resources(http("request_17")
        .get("/api/v1/resource/Script/Script_a86f18f8-f7ce-48cc-a482-deb0cbea63fa/Nieuw_32_script")
        .headers(headers_10)))
    .pause(3)
    .exec(http("request_18")
      .patch("/api/v1/resource/Script/Script_a86f18f8-f7ce-48cc-a482-deb0cbea63fa/Nieuw_32_script")
      .headers(headers_16)
      .body(RawFileBody("io/gatling/tests/recordedsimulation3/containsEverything.json")))
    .pause(2)
    .exec(http("request_19")
      .patch("/api/v1/resource/Script/Script_a86f18f8-f7ce-48cc-a482-deb0cbea63fa/Nieuw_32_script")
      .headers(headers_16)
      .body(RawFileBody("io/gatling/tests/recordedsimulation3/0019_request.json")))
    .pause(3)
    .exec(http("request_20")
      .post("/api/v1/resource/Script")
      .headers(headers_16)
      .body(RawFileBody("io/gatling/tests/recordedsimulation3/0020_request.json"))
      .resources(http("request_21")
        .get("/api/v1/resource/Script/Script_d30b534e-8622-4ef0-96fb-dacb5ea57f14/Nieuw_32_script")
        .headers(headers_10)))
    .pause(3)
    .exec(http("request_22")
      .patch("/api/v1/resource/Script/Script_d30b534e-8622-4ef0-96fb-dacb5ea57f14/Nieuw_32_script")
      .headers(headers_16)
      .body(RawFileBody("io/gatling/tests/recordedsimulation3/0022_request.json")))
    .pause(3)
    .exec(http("request_23")
      .patch("/api/v1/resource/Script/Script_d30b534e-8622-4ef0-96fb-dacb5ea57f14/Nieuw_32_script")
      .headers(headers_16)
      .body(RawFileBody("io/gatling/tests/recordedsimulation3/0023_request.json")))
    .pause(2)
    .exec(http("request_24")
      .post("/api/v1/resource/Script")
      .headers(headers_16)
      .body(RawFileBody("io/gatling/tests/recordedsimulation3/0024_request.json"))
      .resources(http("request_25")
        .get("/api/v1/resource/Script/Script_8787326b-c711-4433-880b-680d560475dc/Nieuw_32_script")
        .headers(headers_10)))
    .pause(4)
    .exec(http("request_26")
      .patch("/api/v1/resource/Script/Script_8787326b-c711-4433-880b-680d560475dc/Nieuw_32_script")
      .headers(headers_16)
      .body(RawFileBody("io/gatling/tests/recordedsimulation3/0026_request.json")))
    .pause(14)
    .exec(http("request_27")
      .patch("/api/v1/resource/Script/Script_8787326b-c711-4433-880b-680d560475dc/Nieuw_32_script")
      .headers(headers_16)
      .body(RawFileBody("io/gatling/tests/recordedsimulation3/0027_request.json")))
    .pause(1)
    .exec(http("request_28")
      .get("/api/v1/resource/SESSION/1/MyScripts")
      .headers(headers_10))
    .pause(3)
    .exec(http("request_29")
      .delete("/api/v1/resource/SESSION/1/MyScripts/Account_598460ff-69c9-4f8f-a7aa-e1023b9de6b4/_EMPTY_/Script_8787326b-c711-4433-880b-680d560475dc")
      .headers(headers_16)
      .body(RawFileBody("io/gatling/tests/recordedsimulation3/0029_request.json")))
    .pause(3)
    .exec(http("request_30")
      .delete("/api/v1/resource/SESSION/1/MyScripts/Account_598460ff-69c9-4f8f-a7aa-e1023b9de6b4/_EMPTY_/Script_a86f18f8-f7ce-48cc-a482-deb0cbea63fa")
      .headers(headers_16)
      .body(RawFileBody("io/gatling/tests/recordedsimulation3/0030_request.json")))
    .pause(2)
    .exec(http("request_31")
      .delete("/api/v1/resource/SESSION/1/MyScripts/Account_598460ff-69c9-4f8f-a7aa-e1023b9de6b4/_EMPTY_/Script_d30b534e-8622-4ef0-96fb-dacb5ea57f14")
      .headers(headers_16)
      .body(RawFileBody("io/gatling/tests/recordedsimulation3/0031_request.json")))

  setUp(scn.inject(atOnceUsers(1))).protocols(httpProtocol)
}