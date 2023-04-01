// required for Gatling core structure DSL
import io.gatling.core.Predef._

// required for Gatling HTTP DSL
import io.gatling.http.Predef._

// can be omitted if you don't use jdbcFeeder
import io.gatling.jdbc.Predef._

// can be omitted if you don't use cookies
import io.gatling.http.cookie._

// used for specifying durations with a unit, eg "5 minutes"
// import scala.concurrent.duration._

// used to generate random session identifiers
// import scala.util.Random

class RAPtest extends Simulation {

  private val httpProtocol = http
    .baseUrl("https://rap.cs.ou.nl")
    .inferHtmlResources(AllowList(), DenyList())
    .acceptHeader("*/*")
    .acceptEncodingHeader("gzip, deflate")
    .acceptLanguageHeader("nl-NL,nl;q=0.9,en-US;q=0.8,en;q=0.7,de;q=0.6")
    .doNotTrackHeader("1")
    .userAgentHeader("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36")
  
  // private val feeder = Iterator.continually {
  //   Map("sessionid" -> s"${Random.alphanumeric.filter(isDigit).take(20).mkString}")
  // }

  // def getRandomSessionID() = Map("sessId" -> Random.nextInt(1000000).toString)
  // val feeder = Iterator.continually(getRandomSessionID())

  private val login =
    exec(
      http("Home")
        .get("/")
    )
    // .feed(feeder)
    .pause(2)
    .exec(
      http("Display the login screen")
        .get("/api/v1/resource/SESSION/1/Login")
        .check(jsonPath("$._id_").find.saveAs("sessId"))
    )
    .pause(2)
    .exec (
      http("Fill Userid/Password")
        .patch("/api/v1/resource/SESSION/1")
        .body(StringBody(""" [{ "op":"replace",
                                "path":"/Login/#{sessId}/Login/#{sessId}/Userid",
                                "value":"pietertje"
                              },
                              { "op":"replace",
                                "path":"/Login/#{sessId}/Login/#{sessId}/Password",
                                "value":"slechtpaswoord"
                              },
                              { "op":"replace",
                                "path":"/Login/#{sessId}/Login/#{sessId}/Login/property",
                                "value":true
                              }] """)).asJson
    )
    .exec(
      http("Display MyScripts")
        .get("/api/v1/resource/SESSION/1/MyScripts")
    )
    .pause(2)
    
    private val newScript =
      exec(
        http("Ask for a New Script")
          .post("/api/v1/resource/Script")
          .check(jsonPath("$._id_").saveAs("scriptId"))
      )
      .pause(2)
      .exec(
        http("Display New Script")
          .get("/api/v1/resource/Script/${scriptId}/Nieuw_32_script")
      )
      .pause(2)
      .exec(
        http("Type New Script")
          .patch("/api/v1/resource/Script/${scriptId}/Nieuw_32_script")
          .body(StringBody(""" [{ "op":"replace",
                                  "path":"/Meta_45_info/opdracht",
                                  "value":"Enroll"
                                },
                                { "op":"replace",
                                  "path":"/Content",
                                  "value":"CONTEXT Enrollment IN ENGLISH\nPURPOSE CONTEXT Enrollment\n{+ A complete course consists of several modules.\nStudents of a course can enroll for any module that is part of the course.\n+}\n\nPATTERN Courses\n-- The concepts\nCONCEPT Student \"Someone who wants to study at this institute\"\nPURPOSE CONCEPT Student \n{+We have to know what person studies at this institute, so the system needs to keep track of them.+}\nCONCEPT Course \"A complete course that prepares for a diploma\"\nPURPOSE CONCEPT Course \n{+We have to know what courses there are, so the system needs to keep track of them.+}\nCONCEPT Module \"An educational entity with a single exam\"\nPURPOSE CONCEPT Module \n{+We have to know what modules exist, so the system needs to keep track of them.+}\n\n-- The relations and the initial population\nRELATION takes [Student*Course]\nMEANING \"A student takes a complete course\"\n\nPOPULATION takes CONTAINS\n[ (\"Peter\", \"Management\")\n; (\"Susan\", \"Business IT\")\n; (\"John\", \"Business IT\")\n]\n\nRELATION isPartOf[Module*Course]\nMEANING \"A module part of a complete course\"\n\nPOPULATION isPartOf[Module*Course] CONTAINS\n[ (\"Finance\", \"Management\")\n; (\"Business Rules\", \"Business IT\")\n; (\"Business Analytics\", \"Business IT\")\n; (\"IT-Governance\", \"Business IT\")\n; (\"IT-Governance\", \"Management\")\n]\n\nRELATION isEnrolledFor [Student*Module]\nMEANING \"Students enroll for each module in the course separately\"\n\n-- The one rule in this model\nRULE ModuleEnrollment: isEnrolledFor |- takes;isPartOf~\nMEANING \"A student can enroll for any module that is part of the course the student takes\"\nMESSAGE \"Attempt to enroll student(s) for a module that is not part of the student's course.\"\nVIOLATION (TXT \"Student \", SRC I, TXT \" enrolled for the module \", TGT I, TXT \" which is not part of the course \", SRC I[Student];takes)\nENDPATTERN\n\nINTERFACE Overview : \"_SESSION\"                  cRud\nBOX <TABS>\n     [ Students : V[SESSION*Student]             cRuD\n       BOX <TABLE>\n                [ \"Student\" : I[Student]         cRud\n                , \"Enrolled for\" : isEnrolledFor cRUD\n                , \"Course\" : takes CRUD\n                ]\n     , Course : V[SESSION*Course]                cRuD\n       BOX <TABLE>\n                [ \"Course\" : I                   cRud\n                , \"Modules\" : isPartOf~          CRUD\n                ]\n     , Modules : V[SESSION*Module]               cRud\n       BOX <TABLE>\n                [ \"Modules\" : I                  cRuD\n                , \"Course\" : isPartOf            cRUd\n                , \"Students\" : isEnrolledFor~    CRUD\n                ]\n     ]\n\nENDCONTEXT"
                                }] """)).asJson
      )
      .pause(2)

    private val accounts =
      exec(
        http("Create and delete an account")
          .patch("/api/v1/app/roles")
          .body(StringBody(""" [{ "id":"AccountManager",
                                  "label":"AccountManager",
                                  "active":true
                                }
                               ,{ "id":"Advanced",
                                  "label":"Advanced",
                                  "active":false
                                }
                               ,{ "id":"Tutor",
                                  "label":"Tutor",
                                  "active":false
                                }
                               ,{ "id":"User",
                                  "label":"User",
                                  "active":true
                                }] """)).asJson
      )
      .pause(2)
      .exec(
        http("Get the navbar with a menu adjusted to the new roles")
          .get("/api/v1/app/navbar")
      )
      .pause(2)
      .exec(
        http("Get all current accounts")
          .get("/api/v1/resource/SESSION/1/Accounts")
      )
      .pause(2)
      .exec(
        http("Make a new account")
          .post("/api/v1/resource/SESSION/1/Accounts")
          .check(jsonPath("$.content._id_").saveAs("accountId"))
      )
      .pause(2)
      .exec(
        http("Get all persons")
          .get("/api/v1/resource/Person")
      )
      .pause(2)
      .exec(
        http("Provide an id and name for the new account")
          .patch("/api/v1/resource/SESSION/1/Accounts/#{accountId}")
          .body(StringBody("[{\"op\":\"replace\",\"path\":\"/Persoonlijk_32_ID\",\"value\":\"sjaakb\"},{\"op\":\"replace\",\"path\":\"/Persoon\",\"value\":\"Sjaak\"}]")).asJson
      )
      .pause(2)
      .exec(
        http("Delete the account")
          .delete("/api/v1/resource/SESSION/1/Accounts/#{accountId}")
      )
      .pause(2)

    private val run =
      exec(
        http("Compile the Script")
          .patch("/api/v1/resource/Script/${scriptId}/Nieuw_32_script")
          .body(StringBody(""" [{ "op":"replace",
                                  "path":"/Actual_32_info/compile/property",
                                  "value":true
                                }] """)).asJson
          .check(jsonPath("$.content.Actual_32_info.controls._id_").saveAs("scriptVersion"))
      )
      .pause(2)
      .exec(
        http("Functional Specification")
          .patch("/api/v1/resource/Script/${scriptId}/Nieuw_32_script")
          .body(StringBody(""" [{ "op":"replace",
                                  "path":"/Actual_32_info/controls/${scriptVersion}/Functional_32_spec_46__32_document/property",
                                  "value":true
                                }] """)).asJson
      )
      .pause(2)
      .exec(
        http("Prototype")
          .patch("/api/v1/resource/Script/${scriptId}/Nieuw_32_script")
          .body(StringBody(""" [{ "op":"replace",
                                  "path":"/Actual_32_info/controls/${scriptVersion}/Prototype/property",
                                  "value":true
                                }] """)).asJson
      )
      .pause(2)
      .exec(
        http("Show the Atlas")
          .get("/api/v1/resource/SESSION/1/Atlas")
      )
      .pause(2)

    private val studenten = scenario("Studenten")
    .exec(login, newScript, run)
    private val accountMgmt = scenario("Account Managers")
    .exec(login, accounts)
    private val docenten = scenario("Docenten")
    .exec(login, newScript, run)

	setUp(accountMgmt.inject(atOnceUsers(1))).protocols(httpProtocol)
}
