<!-- .slide: id="gitlab_schedules" class="vertical-center" -->

<i class="fa-duotone fa-calendar-clock fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Schedules

---

## Schedules

Execute pipelines on a `schedule` [](https://docs.gitlab.com/ee/ci/pipelines/schedules.html)

Schedule is specified using cron syntax <i class="fa-duotone fa-face-hand-peeking fa-duotone-colors"></i>

Scheduled pipelines run on a specific branch...

...and can have variables

Creator is referenced and shown as the triggerer

Creator must have role Developer or have merge permissions on protected branches

Maximum frequency configured during instance rollout [](https://docs.gitlab.com/ee/administration/cicd.html#change-maximum-scheduled-pipeline-frequency)

### Hands-On

1. Schedule pipeline to run in 5 minutes
1. Check pipeline
