package io.gatling.tests

import scala.concurrent.duration._

import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.jdbc.Predef._

class RecordedSimulation4 extends Simulation {

	val httpProtocol = http
		.baseUrl("http://horloge.rap.cs.ou.nl")
		.inferHtmlResources(BlackList(""".*\.js""", """.*\.css""", """.*\.gif""", """.*\.jpeg""", """.*\.jpg""", """.*\.ico""", """.*\.woff""", """.*\.woff2""", """.*\.(t|o)tf""", """.*\.png""", """.*detectportal\.firefox\.com.*"""), WhiteList())
		.acceptHeader("application/json, text/plain, */*")
		.acceptEncodingHeader("gzip, deflate")
		.acceptLanguageHeader("nl-NL,nl;q=0.9,en-US;q=0.8,en;q=0.7")
		.userAgentHeader("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36")

	val headers_0 = Map(
		"Accept" -> "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
		"Cache-Control" -> "max-age=0",
		"Upgrade-Insecure-Requests" -> "1")



	val scn = scenario("RecordedSimulation4")
		.exec(http("request_0")
			.get("/")
			.headers(headers_0)
			.resources(http("request_1")
			.get("/api/v1/app/navbar")
			.check(status.is(500))))
		.pause(424)
		.exec(http("request_2")
			.get("/api/v1/admin/installer?defaultPop=true")
			.resources(http("request_3")
			.get("/api/v1/app/navbar")))
		.pause(4)
		.exec(http("request_4")
			.get("/api/v1/admin/installer?defaultPop=true")
			.resources(http("request_5")
			.get("/api/v1/app/navbar")))
		.pause(65)
		.exec(http("request_6")
			.get("/app/project/ifcOverview.view.html")
			.resources(http("request_7")
			.get("/api/v1/resource/SESSION/1/Overview"),
            http("request_8")
			.get("/api/v1/resource/Module"),
            http("request_9")
			.get("/api/v1/resource/Course"),
            http("request_10")
			.get("/api/v1/resource/Student")))

	setUp(scn.inject(atOnceUsers(1))).protocols(httpProtocol)
}