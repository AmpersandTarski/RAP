# everything is deployed in the namespace "rap", which you have to include in ALL kubectl commands:
kubectl get pods -o wide --namespace rap

#copy testpod.yaml(studentprototype) file to internal-kubectl(elevated) pod
# zet hier je "pad" neer
kubectl cp ./deployment/resources/testpod.yaml internal-kubectl:testpod.yaml -c internal-kubectl -n rap

#Enter internal-kubectl commandline
kubectl exec -it internal-kubectl --namespace rap -- /bin/sh

#Run student prototype
kubectl apply -f ./testpod.yaml --namespace rap

#Base64 encode the script text. Used "`" instead of " ' " in the script in order to encode the whole block of text. USe the output of script in kubernetes yaml file as argument
#echo -n "text" | base64

echo -n 'CONTEXT Enrollment IN ENGLISH
PURPOSE CONTEXT Enrollment
{+ A complete course consists of several modules.
Students of a course can enroll for any module that is part of the course.
+}

PATTERN Courses
-- The concepts
CONCEPT Student "Someone who wants to study at this institute"
PURPOSE CONCEPT Student 
{+We have to know what person studies at this institute, so the system needs to keep track of them.+}
CONCEPT Course "A complete course that prepares for a diploma"
PURPOSE CONCEPT Course 
{+We have to know what courses there are, so the system needs to keep track of them.+}
CONCEPT Module "An educational entity with a single exam"
PURPOSE CONCEPT Module 
{+We have to know what modules exist, so the system needs to keep track of them.+}

-- The relations and the initial population
RELATION takes [Student*Course]
MEANING "A student takes a complete course"

POPULATION takes CONTAINS
[ ("Peter", "Management")
; ("Susan", "Business IT")
; ("John", "Business IT")
]

RELATION isPartOf[Module*Course]
MEANING "A module part of a complete course"

POPULATION isPartOf[Module*Course] CONTAINS
[ ("Finance", "Management")
; ("Business Rules", "Business IT")
; ("Business Analytics", "Business IT")
; ("IT-Governance", "Business IT")
; ("IT-Governance", "Management")
]

RELATION isEnrolledFor [Student*Module]
MEANING "Students enroll for each module in the course separately"

-- The one rule in this model
RULE ModuleEnrollment: isEnrolledFor |- takes;isPartOf~
MEANING "A student can enroll for any module that is part of the course the student takes"
MESSAGE "Attempt to enroll student(s) for a module that is not part of the student`s course."
VIOLATION (TXT "Student ", SRC I, TXT " enrolled for the module ", TGT I, TXT " which is not part of the course ", SRC I[Student];takes)
ENDPATTERN

INTERFACE Overview : "_SESSION"                  cRud
BOX <TABS>
     [ Students : V[SESSION*Student]             cRuD
       BOX <TABLE>
                [ "Student" : I[Student]         cRud
                , "Enrolled for" : isEnrolledFor cRUD
                , "Course" : takes CRUD
                ]
     , Course : V[SESSION*Course]                cRuD
       BOX <TABLE>
                [ "Course" : I                   cRud
                , "Modules" : isPartOf~          CRUD
                ]
     , Modules : V[SESSION*Module]               cRud
       BOX <TABLE>
                [ "Modules" : I                  cRuD
                , "Course" : isPartOf            cRUd
                , "Students" : isEnrolledFor~    CRUD
                ]
     ]

ENDCONTEXT' | base64

# get external ip address from ingress controller
$EXTERNALIP = (kubectl get service ingress-nginx-controller --namespace rap -o jsonpath="{.status.loadBalancer.ingress[0].ip}")
# open student123
Start-Process "http://$EXTERNALIP/student123/index.php"