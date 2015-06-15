# Android saddler sample

This is sample repository of automatically review android codes.

## Sample

[https://github.com/noboru-i/android-saddler-sample/pull/1](https://github.com/noboru-i/android-saddler-sample/pull/1)

![](https://raw.githubusercontent.com/wiki/noboru-i/android-saddler-sample/images/pull_request_sample.png)

## Setting

### Add check task.

Add below line at build.gradle.

```
apply from: "https://raw.githubusercontent.com/monstar-lab/gradle-android-ci-check/1.0.0/ci.gradle"
```

### Modify circle.yml.

Override test section.

```
test:
  override:
    - scripts/saddler.sh
```

### Add scripts/saddler.sh.

Add below shell script.

`https://github.com/noboru-i/android-saddler-sample/blob/master/scripts/saddler.sh`

### Set at CircleCI.

Set `GITHUB_ACCESS_TOKEN=your_access_token` to `Environment Variables`.
