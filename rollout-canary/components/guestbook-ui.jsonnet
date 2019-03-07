local env = std.extVar("__ksonnet/environments");
local params = std.extVar("__ksonnet/params").components["guestbook-ui"];
[
   {
      "apiVersion": "v1",
      "kind": "Service",
      "metadata": {
         "name": params.name 
      },
      "spec": {
         "ports": [
            {
               "port": params.canaryServicePort,
               "targetPort": params.containerPort
            }
         ],
         "selector": {
            "app": params.name
         },
         "type": params.type
      }
   },
   {
      "apiVersion": "argoproj.io/v1alpha1",
      "kind": "Rollout",
      "metadata": {
         "name": params.name
      },
      "spec": {
         "replicas": params.replicas,
         "selector": {
            "matchLabels": {
               "app": params.name
            },
         },
         "template": {
            "metadata": {
               "labels": {
                  "app": params.name
               }
            },
            "spec": {
               "containers": [
                  {
                     "image": params.image,
                     "name": params.name,
                     "ports": [
                     {
                        "containerPort": params.containerPort
                     }
                     ]
                  }
               ]
            }
         },
         "minReadySeconds": 10,
         "strategy": {
            "canary": {
               "maxSurge": 1,
               "maxUnavailable": 0,
               "steps": [
                  {
                     "setWeight" : 20,
                  },
                  {
                     "pause": {
                        "duration": 30,
                     },
                  },
                  {
                     "setWeight" : 40,
                  },
                  {
                     "pause": {},
                  },
               ],
            },
         },
      },
   }
]
