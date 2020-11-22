# Cron Jobs

- One CronJob object is like one line of a crontab/cron table file. It runs a job periodically on a given schedule, written in Cron format.
- All CronJob schedule times are based on the **timezone** of the **kube-controller-manager**.
- CronJobs are useful for creating periodic and recurring tasks, like running backups or sending emails. 
- A CronJob is counted as missed if it has failed to be created at its scheduled time.
- CronJob Controller checks how many schedules it missed in the duration from its last scheduled time until now. 
- If there are more than 100 missed schedules, then it does not start the job and logs the error
  ```yaml
  apiVersion: batch/v1beta1
  kind: CronJob
  metadata:
    name: hello
  spec:
    schedule: "*/1 * * * *"
    jobTemplate:
      spec:
        template:
          spec:
            containers:
            - name: hello
              image: busybox
              args:
              - /bin/sh
              - -c
              - date; echo Hello from the Kubernetes cluster
            restartPolicy: OnFailure
  
  ```