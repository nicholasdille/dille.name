<!-- .slide: id="gitlab_job_deps" class="vertical-center" -->

<i class="fa-duotone fa-cubes fa-8x fa-duotone-colors-inverted" style="float: right; color: grey;"></i>

## Job dependencies

---

## Job dependencies 1/

`needs` [](https://docs.gitlab.com/ee/ci/yaml/#needs) can start jobs from the next stage early...

```yaml
job1:
  stage: stage1
  #...
job2:
  stage: stage2
  needs: job1
  #...
```

...or delay them in the same stage

```yaml
job1:
  stage: test
  #...
job2:
  stage: test
  needs: job1
  #...
```

---

## Job dependencies 2/2

Depend on a job but do not consume artifacts [](https://docs.gitlab.com/ee/ci/yaml/#needsartifacts):

```yaml
job_name:
  #...

job_name2:
  needs:
    job: job_name
    artifacts: false
```

Consume artifacts from parent (upstream) pipeline [](https://docs.gitlab.com/ee/ci/yaml/#needspipelinejob):

```yaml
job_name:
  script: cat artifact.txt
  needs:
    - pipeline: $PARENT_PIPELINE_ID
      job: create-artifact
```

---

## Hands-On

See chapter [Job dependencies](/hands-on/2024-11-12/065_job_dependencies/exercise/)