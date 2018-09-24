local env = std.extVar("__ksonnet/environments");
local params = std.extVar("__ksonnet/params").components["guestbook-ui"];
local securityGroups = if params.securityGroups != '' then {"service.beta.kubernetes.io/aws-load-balancer-extra-security-groups": params.securityGroups} else {};

[
   {
    apiVersion: "extensions/v1beta1",
    kind: "Ingress",
    metadata: {
      name: params.name,
      annotations: {
        "kubernetes.io/ingress.class": params.k8sIngressClass,
        "alb.ingress.kubernetes.io/backend-protocol": params.albBackendProtocol,
        "alb.ingress.kubernetes.io/scheme": params.albScheme,
        "alb.ingress.kubernetes.io/listen-ports": params.albListenPorts,
        "alb.ingress.kubernetes.io/subnets": params.albSubnets,
        "alb.ingress.kubernetes.io/security-groups": params.albSecurityGroups,
        "alb.ingress.kubernetes.io/healthcheck-path": params.healthCheckPath,
        "alb.ingress.kubernetes.io/ssl-policy": params.sslPolicy,
      },
      labels: {app: params.name},
    },
    spec: {
      rules: [
        {
          http: {
            paths: [
              {
                path: "/",
                backend: {
                  serviceName: params.name,
                  servicePort: params.servicePort
                }
              }
            ]
          }
        }
      ]
    }
  },
  {
    apiVersion: "v1",
    kind: "Service",
    metadata: { name: params.name },
    spec: {
        ports: [{
            port: params.servicePort,
            targetPort: params.containerPort
        }],
        selector: {
            app: params.name
        },
        type: "NodePort"
    }
  }, 
  {
      "apiVersion": "apps/v1beta2",
      "kind": "Deployment",
      "metadata": {
        "name": params.name,
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
         }
      }
  }
]
