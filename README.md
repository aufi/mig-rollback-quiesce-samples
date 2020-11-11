# OpenShift migration Rollback Quiesce sample data

A set of YAML files which set up a new namespace in OCP and create objects useful for Quiesce testing (part of OpenShift migration rollback).

## Objects and their quiesce method

| Type | Un/quiesced by |
|---|---|
| Deployment, StatefulSets, ReplicaSet and related | .Spec.Replicas count |
|  DaemonSet | .Spec.Template.Spec.NodeSelector selector update |
|  Job | .Spec.Parallelism count |
|  CronJob | .Spec.Suspend true/false |

## Usage

Login to your OCP4 cluster first and run make.

```
make
```

Example output

```
$ make
cat manifests/*.yaml > mig-rollback-samples.yaml
oc delete namespace --ignore-not-found=true mig-rollback-samples 
namespace "mig-rollback-samples" deleted
oc apply -f mig-rollback-samples.yaml
namespace/mig-rollback-samples created
cronjob.batch/pi-cronjob created
daemonset.apps/hello-daemonset created
deploymentconfig.apps.openshift.io/frontend-dc created
job.batch/pi-job created
```

Objects in OCP cluster

```
# oc get all -n mig-rollback-samples                                                                                                                                         

NAME                              READY   STATUS             RESTARTS   AGE
pod/frontend-dc-1-deploy          1/1     Running            0          28s
pod/frontend-dc-1-jggt7           0/1     ImagePullBackOff   0          26s
pod/frontend-dc-1-mbxkc           0/1     ImagePullBackOff   0          26s
pod/pi-cronjob-1605093840-9m7d8   0/1     Completed          0          14s
pod/pi-job-vh6dj                  0/1     Completed          0          28s

NAME                                  DESIRED   CURRENT   READY   AGE
replicationcontroller/frontend-dc-1   2         2         0	  28s

NAME                             DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
daemonset.apps/hello-daemonset   0         0         0       0            0           role=worker     31s

NAME                              COMPLETIONS   DURATION   AGE
job.batch/pi-cronjob-1605093840   1/1           13s        16s
job.batch/pi-job                  1/1           12s        30s

NAME                       SCHEDULE	 SUSPEND   ACTIVE   LAST SCHEDULE   AGE
cronjob.batch/pi-cronjob   */1 * * * *   False     1        22s             33s

NAME                                             REVISION   DESIRED   CURRENT   TRIGGERED BY
deploymentconfig.apps.openshift.io/frontend-dc   1          2         2         config
```