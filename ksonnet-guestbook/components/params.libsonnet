{
  global: {
    // User-defined global parameters; accessible to all component and environments, Ex:
    // replicas: 4,
  },
  components: {
    // Component-level parameters, defined initially from 'ks prototype use ...'
    // Each object below should correspond to a component in the components/ directory
    "guestbook-ui": {
      containerPort: 80,
      image: "gcr.io/heptio-images/ks-guestbook-demo:0.1",
      name: "ks-guestbook-ui",
      replicas: 1,
      servicePort: 80,
      type: "LoadBalancer",
      securityGroups: "sg-0bc6ba66872152017",
      k8sIngressClass: "alb",
      albBackendProtocol: "HTTP",
      albScheme: "internet-facing",
      albListenPorts: '[{"HTTP": 80}]',
      albSubnets: "IngressSubnetAz1, IngressSubnetAz2, IngressSubnetAz3",
      albSecurityGroups: "intuit-cidr-ingress-tcp-80",
      healthCheckPath: "/",
      sslPolicy: "ELBSecurityPolicy-TLS-1-2-2017-01"
    },
  },
}
