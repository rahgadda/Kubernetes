# Jobs

- A Job creates one or more Pods and ensures that a specified number of them successfully terminate. A Job can also be used to run multiple Pods in parallel.
- As pods successfully complete, the Job tracks the successful completions. When a specified number of successful completions is reached, the task (ie, Job) is complete.
- Deleting a Job will clean up the Pods it created.
- There are three main types of task suitable to run as a Job:
  - **Non-parallel Jobs:**
    - These are non-parallel Jobs.
    - Only one Pod is started, unless the Pod fails.
    - Job is complete as soon as its Pod terminates successfully.
  - **Parallel Jobs with a fixed completion count:**
    - Fixed Count Success.
    - Represents the overall task, and is complete when there is one successful Pod for each value in the range 1 to .spec.completions
  - **Parallel Jobs with a work queue:**
    - At-least one Success.
    - Pods must coordinate themselves or an external service to determine what each should work on.
    - Each Pod is independently capable of determining whether or not all its peers are done, and thus that the entire Job is done.
    - Once at least one Pod has terminated with success and all Pods are terminated, then the Job is completed with success. 
    - No other Pod should still be doing any work for this task or writing any output if at least one Pod has terminated. 

  ```yaml
  apiVersion: batch/v1
  kind: Job
  metadata:
    name: pi
  spec:
    template:
      spec:
        containers:
        - name: pi
          image: perl
          command: ["perl",  "-Mbignum=bpi", "-wle", "print bpi  (2000)"]
        restartPolicy: Never
    backoffLimit: 4
  ```