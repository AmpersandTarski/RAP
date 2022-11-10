package io.gatling.tests

import scala.concurrent.duration._

import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.jdbc.Predef._

class RecordedSimulation3 extends Simulation {

	val httpProtocol = http
		.baseUrl("https://rap.cs.ou.nl")
		.inferHtmlResources(BlackList(""".*\.js""", """.*\.css""", """.*\.gif""", """.*\.jpeg""", """.*\.jpg""", """.*\.ico""", """.*\.woff""", """.*\.woff2""", """.*\.(t|o)tf""", """.*\.png""", """.*detectportal\.firefox\.com.*"""), WhiteList())
		.userAgentHeader("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36")

	val headers_0 = Map(
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
		"upgrade-insecure-requests" -> "1")

	val headers_1 = Map(
		"Accept" -> "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
		"Service-Worker-Navigation-Preload" -> "true",
		"Upgrade-Insecure-Requests" -> "1",
		"sec-ch-ua" -> """Google Chrome";v="107", "Chromium";v="107", "Not=A?Brand";v="24""",
		"sec-ch-ua-mobile" -> "?0",
		"sec-ch-ua-platform" -> "Windows")

	val headers_2 = Map(
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
		"x-client-data" -> "CIm2yQEIo7bJAQjBtskBCKmdygEIlaHLAQj9u8wBCNi8zAEIxuHMAQju7cwBCP7tzAEI6fbMAQ==")

	val headers_3 = Map(
		"accept" -> "application/json, text/plain, */*",
		"accept-encoding" -> "gzip, deflate, br",
		"accept-language" -> "nl-NL,nl;q=0.9,en-US;q=0.8,en;q=0.7",
		"sec-ch-ua" -> """Google Chrome";v="107", "Chromium";v="107", "Not=A?Brand";v="24""",
		"sec-ch-ua-mobile" -> "?0",
		"sec-ch-ua-platform" -> "Windows",
		"sec-fetch-dest" -> "empty",
		"sec-fetch-mode" -> "cors",
		"sec-fetch-site" -> "same-origin")

	val headers_4 = Map(
		"sec-ch-ua" -> """Google Chrome";v="107", "Chromium";v="107", "Not=A?Brand";v="24""",
		"sec-ch-ua-mobile" -> "?0",
		"sec-ch-ua-platform" -> "Windows")

	val headers_6 = Map(
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
		"x-client-data" -> "CIm2yQEIo7bJAQjBtskBCKmdygEIlaHLAQj9u8wBCNi8zAEIxuHMAQju7cwBCP7tzAEI6fbMAQ==",
		"x-goog-api-key" -> "AIzaSyDyT5W0Jh49F30Pqqtyfdf7pDLFKLJoAnw",
		"x-user-agent" -> "grpc-web-javascript/0.1")

	val headers_8 = Map(
		"accept" -> "image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8",
		"accept-encoding" -> "gzip, deflate, br",
		"accept-language" -> "nl-NL,nl;q=0.9,en-US;q=0.8,en;q=0.7",
		"sec-ch-ua" -> """Google Chrome";v="107", "Chromium";v="107", "Not=A?Brand";v="24""",
		"sec-ch-ua-mobile" -> "?0",
		"sec-ch-ua-platform" -> "Windows",
		"sec-fetch-dest" -> "image",
		"sec-fetch-mode" -> "no-cors",
		"sec-fetch-site" -> "same-origin",
		"x-client-data" -> "CIm2yQEIo7bJAQjBtskBCKmdygEIlaHLAQj9u8wBCNi8zAEIxuHMAQju7cwBCP7tzAEI6fbMAQ==")

	val headers_10 = Map(
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
		"sec-fetch-site" -> "same-origin")

	val uri1 = "https://jnn-pa.googleapis.com/$rpc/google.internal.waa.v1.Waa"
	val uri2 = "https://www.youtube.com"
	val uri3 = "https://yt3.ggpht.com/ytc/AMLnZu899uda-HHUxI1TThdfuD1ySjsgcAHNe1V4xg=s68-c-k-c0x00ffffff-no-rj"
	val uri5 = "https://i.ytimg.com/vi/zPqRbCvXz7M/sddefault.jpg"

	val scn = scenario("RecordedSimulation3")
		.exec(http("request_0")
			.get("/")
			.headers(headers_0)
			.resources(http("request_1")
				.get(uri2 + "/embed/zPqRbCvXz7M")
				.headers(headers_1),
				http("request_2")
					.get(uri2 + "/embed/zPqRbCvXz7M")
					.headers(headers_2),
				http("request_3")
					.get("/api/v1/app/navbar")
					.headers(headers_3),
				http("request_4")
					.get(uri5 + "?sqp=-oaymwEmCIAFEOAD8quKqQMa8AEB-AGiCYAC9gaKAgwIABABGGUgZShlMA8=&rs=AOn4CLDx0yNzCItbsaDBTuVWWz0tGHIBmg")
					.headers(headers_4),
				http("request_5")
					.get(uri3)
					.headers(headers_4),
				http("request_6")
					.post(uri1 + "/Create")
					.headers(headers_6)
					.body(RawFileBody("io/gatling/tests/recordedsimulation3/0006_request.dat")),
				http("request_7")
					.post(uri1 + "/GenerateIT")
					.headers(headers_6)
					.body(RawFileBody("io/gatling/tests/recordedsimulation3/0007_request.dat")),
				http("request_8")
					.get(uri2 + "/generate_204?oDo1KQ")
					.headers(headers_8),
				http("request_9")
					.get("/api/v1/resource/SESSION/1/Login")
					.headers(headers_3)))
		.pause(4)
		.exec(http("request_10")
			.patch("/api/v1/resource/SESSION/1")
			.headers(headers_10)
			.body(RawFileBody("io/gatling/tests/recordedsimulation3/0010_request.json"))
			.resources(http("request_11")
				.get("/api/v1/app/navbar")
				.headers(headers_3),
				http("request_12")
					.get("/api/v1/resource/SESSION/1/Login")
					.headers(headers_3)))
		.pause(6)
		.exec(http("request_13")
			.patch("/api/v1/resource/SESSION/1")
			.headers(headers_10)
			.body(RawFileBody("io/gatling/tests/recordedsimulation3/0013_request.json"))
			.resources(http("request_14")
				.get("/api/v1/app/navbar")
				.headers(headers_3),
				http("request_15")
					.get("/api/v1/resource/SESSION/1/MyScripts")
					.headers(headers_3)))
		.pause(9)

		.exec(http("request_16")
			.post("/api/v1/resource/Script")
			.headers(headers_10)
			.body(RawFileBody("io/gatling/tests/recordedsimulation3/0016_request.json"))
			.resources(http("request_17")
				.get("/api/v1/resource/Script/Script_89d8397e-e9ff-40af-8a4d-db68ec5e6ae4/Nieuw_32_script")
				.headers(headers_3)))
		.pause(3)
		.exec(http("request_18")
			.patch("/api/v1/resource/Script/Script_89d8397e-e9ff-40af-8a4d-db68ec5e6ae4/Nieuw_32_script")
			.headers(headers_10)
			.body(RawFileBody("io/gatling/tests/recordedsimulation3/0018_request.json")))
		.pause(4)
		.exec(http("request_19")
			.patch("/api/v1/resource/Script/Script_89d8397e-e9ff-40af-8a4d-db68ec5e6ae4/Nieuw_32_script")
			.headers(headers_10)
			.body(RawFileBody("io/gatling/tests/recordedsimulation3/0019_request.json")))
		.pause(9)
		.exec(http("request_20")
			.patch("/api/v1/resource/Script/Script_89d8397e-e9ff-40af-8a4d-db68ec5e6ae4/Nieuw_32_script")
			.headers(headers_10)
			.body(RawFileBody("io/gatling/tests/recordedsimulation3/0020_request.json")))
		.pause(5)
		.exec(http("request_21")
			.patch("/api/v1/resource/Script/Script_89d8397e-e9ff-40af-8a4d-db68ec5e6ae4/Nieuw_32_script")
			.headers(headers_10)
			.body(RawFileBody("io/gatling/tests/recordedsimulation3/0021_request.json")))

	setUp(scn.inject(atOnceUsers(1))).protocols(httpProtocol)
}