# learning-istio

## Kubernetes Cluster

Done in Azure with Terraform. See `./terraform_kubernetes_cluster`

## Istio

Mostly `bash` in `./istio`. I've provided some write-up here along with a TLDR (summary) and take-away note(s) at the end. They're all intended to be run from the `./istio` dir. 

### 00 Install Istio

[Getting started with Istio](https://istio.io/latest/docs/setup/getting-started/)
is simple. You download the `istioctl` tool and install it with this command. Istio comes with several “profiles”. These profiles are like ready-made values files. The profile defines the configuration for the Istio operator.  

```sh
istioctl install --set profile=demo -y
```

You can dump that profile with this command. It’s 540 lines tho. 

```sh
istioctl profile dump demo 
```

The most basic component of Istio is the envoy proxy. To enable automatic sidecar injection in a namespace (automatically install envoy) you need to label it. You can also use istioctl to alter YAML files before applying them but nah. 

```sh
kubectl label namespace default istio-injection=enabled
```

#### TLDR

This is made easy by the `istioctl` tool. Just run the scripts to install istio and download the sample applications locally.
- 📝 Istio automatic sidecar injection is only automatic if you label your namespace

### 01 Install the bookinfo sample app

Istio comes with a *bunch* of sample apps, this one is 
[the `bookinfo` app](https://istio.io/latest/docs/examples/bookinfo/).
Bookinfo is comprised of four services, their service accounts, and their deployments. They are all contained in the first file. The second file (Gateway) deploys our first istio object, a 
[Gateway](https://istio.io/latest/docs/concepts/traffic-management/#gateways)
, which is analogous to an ingress controller in native kubernetes. It also deploys a 
[VirtualService](https://istio.io/latest/docs/concepts/traffic-management/#virtual-services)
which is like a normal kubernetes service but with more service-mesh 
[synergy](https://www.statista.com/chart/24102/share-who-hate-business-phrases/).

The samples downloded in the first step provide manifests. 
```sh
kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml
kubectl apply -f samples/bookinfo/networking/bookinfo-gateway.yaml
kubectl apply -f samples/bookinfo/networking/destination-rule-all.yaml
```

#### TLDR
- 📝 Istio Gateway: Like a k8s ingress that also does egress. Essentially a proxy.
- 📝 Istio VirtualService: Like a k8s service but with more rules. These map requests to destinations via routing rules.

### 02 Addons
These addons are expressly for _demo purposes_. 
The Istio docs make clear that if you want to run any of these servies in production you should deploy them as standalone applications.

Deploy the addons:
```sh
kubectl apply -f samples/addons/grafana.yaml
kubectl apply -f samples/addons/jaeger.yaml
kubectl apply -f samples/addons/kiali.yaml
kubectl apply -f samples/addons/prometheus.yaml
```

Generate some traffic:
```sh
export ingress_ip=$(kubectl get svc istio-ingressgateway -n istio-system \
  -o jsonpath='{.status.loadBalancer.ingress[0].ip}'; echo)
for i in {1..500}; do curl -s -o /dev/null http://$ingress_ip/productpage; done
```

Get the [Kiali dashboard](https://kiali.io/documentation/latest/features/):
```sh
istioctl dashboard kiali
```

#### Addons TLDR
Istio works well with these applications.

- [Grafana](https://grafana.com/) for observability dashboards
- [Jaeger](https://www.jaegertracing.io/) for distributed tracing
- [Kiali](https://kiali.io/) as an Istio management console
- [Prometheus](https://en.wikipedia.org/wiki/Prometheus) for his liver



### 
