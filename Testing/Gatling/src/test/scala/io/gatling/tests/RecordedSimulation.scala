package io.gatling.tests

import scala.concurrent.duration._

import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.jdbc.Predef._

class RecordedSimulation extends Simulation {

	val httpProtocol = http
		.baseUrl("https://rap.cs.ou.nl")
		.inferHtmlResources(BlackList(""".*\.js""", """.*\.css""", """.*\.gif""", """.*\.jpeg""", """.*\.jpg""", """.*\.ico""", """.*\.woff""", """.*\.woff2""", """.*\.(t|o)tf""", """.*\.png""", """.*detectportal\.firefox\.com.*"""), WhiteList())
		.userAgentHeader("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36")

	val headers_0 = Map(
		"accept" -> "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
		"accept-encoding" -> "gzip, deflate, br",
		"accept-language" -> "nl-NL,nl;q=0.9,en-US;q=0.8,en;q=0.7",
		"sec-ch-ua" -> """Google Chrome";v="107", "Chromium";v="107", "Not=A?Brand";v="24""",
		"sec-ch-ua-mobile" -> "?0",
		"sec-ch-ua-platform" -> "macOS",
		"sec-fetch-dest" -> "document",
		"sec-fetch-mode" -> "navigate",
		"sec-fetch-site" -> "same-origin",
		"sec-fetch-user" -> "?1",
		"upgrade-insecure-requests" -> "1")

	val headers_1 = Map(
		"accept" -> "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
		"accept-encoding" -> "gzip, deflate, br",
		"accept-language" -> "nl-NL,nl;q=0.9,en-US;q=0.8,en;q=0.7",
		"sec-ch-ua" -> """Google Chrome";v="107", "Chromium";v="107", "Not=A?Brand";v="24""",
		"sec-ch-ua-mobile" -> "?0",
		"sec-ch-ua-platform" -> "macOS",
		"sec-fetch-dest" -> "iframe",
		"sec-fetch-mode" -> "navigate",
		"sec-fetch-site" -> "cross-site",
		"upgrade-insecure-requests" -> "1",
		"x-client-data" -> "CJa2yQEIpLbJAQjEtskBCKmdygEIlaHLAQjv7cwBCPT5zAEIp/vMAQip/MwB")

	val headers_2 = Map(
		"accept" -> "*/*",
		"accept-encoding" -> "gzip, deflate, br",
		"accept-language" -> "nl-NL,nl;q=0.9,en-US;q=0.8,en;q=0.7",
		"origin" -> "https://www.youtube.com",
		"sec-ch-ua" -> """Google Chrome";v="107", "Chromium";v="107", "Not=A?Brand";v="24""",
		"sec-ch-ua-mobile" -> "?0",
		"sec-ch-ua-platform" -> "macOS",
		"sec-fetch-dest" -> "empty",
		"sec-fetch-mode" -> "cors",
		"sec-fetch-site" -> "cross-site",
		"x-client-data" -> "CJa2yQEIpLbJAQjEtskBCKmdygEIlaHLAQjv7cwBCPT5zAEIp/vMAQip/MwB")

	val headers_3 = Map(
		"accept" -> "application/json, text/plain, */*",
		"accept-encoding" -> "gzip, deflate, br",
		"accept-language" -> "nl-NL,nl;q=0.9,en-US;q=0.8,en;q=0.7",
		"sec-ch-ua" -> """Google Chrome";v="107", "Chromium";v="107", "Not=A?Brand";v="24""",
		"sec-ch-ua-mobile" -> "?0",
		"sec-ch-ua-platform" -> "macOS",
		"sec-fetch-dest" -> "empty",
		"sec-fetch-mode" -> "cors",
		"sec-fetch-site" -> "same-origin")

	val headers_4 = Map(
		"sec-ch-ua" -> """Google Chrome";v="107", "Chromium";v="107", "Not=A?Brand";v="24""",
		"sec-ch-ua-mobile" -> "?0",
		"sec-ch-ua-platform" -> "macOS")

	val headers_6 = Map(
		"accept" -> "*/*",
		"accept-encoding" -> "gzip, deflate, br",
		"accept-language" -> "nl-NL,nl;q=0.9,en-US;q=0.8,en;q=0.7",
		"content-type" -> "application/json+protobuf",
		"origin" -> "https://www.youtube.com",
		"sec-ch-ua" -> """Google Chrome";v="107", "Chromium";v="107", "Not=A?Brand";v="24""",
		"sec-ch-ua-mobile" -> "?0",
		"sec-ch-ua-platform" -> "macOS",
		"sec-fetch-dest" -> "empty",
		"sec-fetch-mode" -> "cors",
		"sec-fetch-site" -> "cross-site",
		"x-client-data" -> "CJa2yQEIpLbJAQjEtskBCKmdygEIlaHLAQjv7cwBCPT5zAEIp/vMAQip/MwB",
		"x-goog-api-key" -> "AIzaSyDyT5W0Jh49F30Pqqtyfdf7pDLFKLJoAnw",
		"x-user-agent" -> "grpc-web-javascript/0.1")

	val headers_8 = Map(
		"accept" -> "image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8",
		"accept-encoding" -> "gzip, deflate, br",
		"accept-language" -> "nl-NL,nl;q=0.9,en-US;q=0.8,en;q=0.7",
		"sec-ch-ua" -> """Google Chrome";v="107", "Chromium";v="107", "Not=A?Brand";v="24""",
		"sec-ch-ua-mobile" -> "?0",
		"sec-ch-ua-platform" -> "macOS",
		"sec-fetch-dest" -> "image",
		"sec-fetch-mode" -> "no-cors",
		"sec-fetch-site" -> "same-origin",
		"x-client-data" -> "CJa2yQEIpLbJAQjEtskBCKmdygEIlaHLAQjv7cwBCPT5zAEIp/vMAQip/MwB")

	val headers_9 = Map(
		"accept" -> "*/*",
		"accept-encoding" -> "gzip, deflate, br",
		"accept-language" -> "nl-NL,nl;q=0.9,en-US;q=0.8,en;q=0.7",
		"content-type" -> "application/json",
		"origin" -> "https://www.youtube.com",
		"sec-ch-ua" -> """Google Chrome";v="107", "Chromium";v="107", "Not=A?Brand";v="24""",
		"sec-ch-ua-mobile" -> "?0",
		"sec-ch-ua-platform" -> "macOS",
		"sec-fetch-dest" -> "empty",
		"sec-fetch-mode" -> "cors",
		"sec-fetch-site" -> "same-origin",
		"x-client-data" -> "CJa2yQEIpLbJAQjEtskBCKmdygEIlaHLAQjv7cwBCPT5zAEIp/vMAQip/MwB",
		"x-goog-request-time" -> "1669709820846",
		"x-goog-visitor-id" -> "Cgt4YW1HZGNFVThRdyj8_5acBg%3D%3D",
		"x-youtube-ad-signals" -> "dt=1669709820683&flash=0&frm=2&u_tz=60&u_his=7&u_h=1117&u_w=1728&u_ah=1085&u_aw=1728&u_cd=30&bc=31&bih=-12245933&biw=-12245933&brdim=0%2C37%2C0%2C37%2C1728%2C32%2C1728%2C1080%2C560%2C315&vis=1&wgl=true&ca_type=image&bid=ANyPxKpVWmtvU-G42aznUJe2RWP5pCQf5zY-72Q9yNGtu8Il_gW3XJlyesr2u8xgPaYF42Jp0L5z7X1SC28kL29VRckjYxRLFA",
		"x-youtube-client-name" -> "56",
		"x-youtube-client-version" -> "1.20221120.00.00",
		"x-youtube-time-zone" -> "Europe/Amsterdam",
		"x-youtube-utc-offset" -> "60")

	val headers_10 = Map(
		"accept" -> "*/*",
		"accept-encoding" -> "gzip, deflate, br",
		"accept-language" -> "nl-NL,nl;q=0.9,en-US;q=0.8,en;q=0.7",
		"content-type" -> "application/json",
		"origin" -> "https://www.youtube.com",
		"sec-ch-ua" -> """Google Chrome";v="107", "Chromium";v="107", "Not=A?Brand";v="24""",
		"sec-ch-ua-mobile" -> "?0",
		"sec-ch-ua-platform" -> "macOS",
		"sec-fetch-dest" -> "empty",
		"sec-fetch-mode" -> "cors",
		"sec-fetch-site" -> "same-origin",
		"x-client-data" -> "CJa2yQEIpLbJAQjEtskBCKmdygEIlaHLAQjv7cwBCPT5zAEIp/vMAQip/MwB",
		"x-goog-request-time" -> "1669709822829",
		"x-goog-visitor-id" -> "Cgt4YW1HZGNFVThRdyj8_5acBg%3D%3D",
		"x-youtube-ad-signals" -> "dt=1669709820683&flash=0&frm=2&u_tz=60&u_his=7&u_h=1117&u_w=1728&u_ah=1085&u_aw=1728&u_cd=30&bc=31&bih=-12245933&biw=-12245933&brdim=0%2C37%2C0%2C37%2C1728%2C32%2C1728%2C1080%2C560%2C315&vis=1&wgl=true&ca_type=image&bid=ANyPxKpVWmtvU-G42aznUJe2RWP5pCQf5zY-72Q9yNGtu8Il_gW3XJlyesr2u8xgPaYF42Jp0L5z7X1SC28kL29VRckjYxRLFA",
		"x-youtube-client-name" -> "56",
		"x-youtube-client-version" -> "1.20221120.00.00",
		"x-youtube-time-zone" -> "Europe/Amsterdam",
		"x-youtube-utc-offset" -> "60")

	val headers_12 = Map(
		"accept" -> "application/json, text/plain, */*",
		"accept-encoding" -> "gzip, deflate, br",
		"accept-language" -> "nl-NL,nl;q=0.9,en-US;q=0.8,en;q=0.7",
		"content-type" -> "application/json",
		"origin" -> "https://rap.cs.ou.nl",
		"sec-ch-ua" -> """Google Chrome";v="107", "Chromium";v="107", "Not=A?Brand";v="24""",
		"sec-ch-ua-mobile" -> "?0",
		"sec-ch-ua-platform" -> "macOS",
		"sec-fetch-dest" -> "empty",
		"sec-fetch-mode" -> "cors",
		"sec-fetch-site" -> "same-origin")

    val uri1 = "https://jnn-pa.googleapis.com/$rpc/google.internal.waa.v1.Waa"
    val uri2 = "https://www.youtube.com"
    val uri3 = "https://yt3.ggpht.com/ytc/AMLnZu899uda-HHUxI1TThdfuD1ySjsgcAHNe1V4xg=s68-c-k-c0x00ffffff-no-rj"
    val uri4 = "https://googleads.g.doubleclick.net/pagead/id"
    val uri6 = "https://i.ytimg.com/vi/zPqRbCvXz7M/sddefault.jpg"

	val scn = scenario("RecordedSimulation")
		.exec(http("request_0")
			.get("/")
			.headers(headers_0)
			.resources(http("request_1")
			.get(uri2 + "/embed/zPqRbCvXz7M")
			.headers(headers_1),
            http("request_2")
			.get(uri4)
			.headers(headers_2),
            http("request_3")
			.get("/api/v1/app/navbar")
			.headers(headers_3),
            http("request_4")
			.get(uri3)
			.headers(headers_4),
            http("request_5")
			.get(uri6 + "?sqp=-oaymwEmCIAFEOAD8quKqQMa8AEB-AGiCYAC9gaKAgwIABABGGUgZShlMA8=&rs=AOn4CLDx0yNzCItbsaDBTuVWWz0tGHIBmg")
			.headers(headers_4),
            http("request_6")
			.post(uri1 + "/Create")
			.headers(headers_6)
			.body(RawFileBody("io/gatling/tests/recordedsimulation/0006_request.dat")),
            http("request_7")
			.post(uri1 + "/GenerateIT")
			.headers(headers_6)
			.body(RawFileBody("io/gatling/tests/recordedsimulation/0007_request.dat")),
            http("request_8")
			.get(uri2 + "/generate_204?RnsTGg")
			.headers(headers_8),
            http("request_9")
			.post(uri2 + "/youtubei/v1/log_event?alt=json&key=AIzaSyAO_FJ2SlqU8Q4STEHLGCilw_Y9_11qcW8")
			.headers(headers_9)
			.body(RawFileBody("io/gatling/tests/recordedsimulation/0009_request.json"))))
		.pause(1)
		.exec(http("request_10")
			.post(uri2 + "/youtubei/v1/log_event?alt=json&key=AIzaSyAO_FJ2SlqU8Q4STEHLGCilw_Y9_11qcW8")
			.headers(headers_10)
			.body(RawFileBody("io/gatling/tests/recordedsimulation/0010_request.json")))
		.pause(2)
		.exec(http("request_11")
			.get("/api/v1/resource/SESSION/1/Login")
			.headers(headers_3))
		.pause(3)
		.exec(http("request_12")
			.patch("/api/v1/resource/SESSION/1")
			.headers(headers_12)
			.body(RawFileBody("io/gatling/tests/recordedsimulation/0012_request.json"))
			.resources(http("request_13")
			.get("/api/v1/app/navbar")
			.headers(headers_3),
            http("request_14")
			.get("/api/v1/resource/SESSION/1/Login")
			.headers(headers_3)))
		.pause(4)
		.exec(http("request_15")
			.patch("/api/v1/resource/SESSION/1")
			.headers(headers_12)
			.body(RawFileBody("io/gatling/tests/recordedsimulation/0015_request.json"))
			.resources(http("request_16")
			.get("/api/v1/app/navbar")
			.headers(headers_3),
            http("request_17")
			.get("/api/v1/resource/SESSION/1/MyScripts")
			.headers(headers_3)))
		.pause(10)
		.exec(http("request_18")
			.post("/api/v1/resource/SESSION/1/MyScripts/Account_2936a949-f6ee-49e0-b5a6-0033c834fbec/_EMPTY_")
			.headers(headers_12)
			.body(RawFileBody("io/gatling/tests/recordedsimulation/0018_request.json")))
		.pause(2)
		.exec(http("request_19")
			.get("/api/v1/resource/Script/Script_26bb5dea-290b-4d85-b847-a5fffd70ae4f/Nieuw_32_script")
			.headers(headers_3))
		.pause(13)
		.exec(http("request_20")
			.patch("/api/v1/resource/Script/Script_26bb5dea-290b-4d85-b847-a5fffd70ae4f/Nieuw_32_script")
			.headers(headers_12)
			.body(RawFileBody("io/gatling/tests/recordedsimulation/0020_request.json")))
		.pause(2)
		.exec(http("request_21")
			.patch("/api/v1/resource/Script/Script_26bb5dea-290b-4d85-b847-a5fffd70ae4f/Nieuw_32_script")
			.headers(headers_12)
			.body(RawFileBody("io/gatling/tests/recordedsimulation/0021_request.json")))
		.pause(2)
		.exec(http("request_22")
			.patch("/api/v1/resource/Script/Script_26bb5dea-290b-4d85-b847-a5fffd70ae4f/Nieuw_32_script")
			.headers(headers_12)
			.body(RawFileBody("io/gatling/tests/recordedsimulation/0022_request.json")))
		.pause(8)
		.exec(http("request_23")
			.get("/api/v1/resource/SESSION/1/Atlas")
			.headers(headers_3))

	setUp(scn.inject(atOnceUsers(1))).protocols(httpProtocol)
}