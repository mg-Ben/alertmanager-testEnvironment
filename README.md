# Prometheus Alertmanager - Test Environment
This repository provides a test environment with Docker and lets user test configurations for Alertmanager by configuring the `alertmanager.yml` file.

Requirements:
- Linux OS
- Gmail account with an Application Password configured (to receive alerts)
- Docker installed

# How to start
## 1. Create a gmail account to receive alerts and add an application password
Once the gmail account has been created, follow [these steps](https://support.google.com/mail/answer/185833?hl=es-419) on how to create an application password.

# How to use
1. Create a new directory called `./config/`
1. Create file inside `./config/`: `./config/alertmanager.yml` and edit it as you want
2. Edit `.env.template`
3. Start Alertmanager container:

```shell
sudo bash alertmanager-start.sh
```

4. Create an example alert in `alarm.json`
5. Send that alert to your gmail account:

```shell
sudo bash alarm-test.sh
```

# Others
## How to create and apply a notification template
1. Add and create the template file with `.tmpl` extension where you want (e.g. you can create a folder inside `./config/`, like `./config/templates/` and create there your templates), which is the format for Go templating system
2. Reference that file in your `alertmanager.yml` configuration file. For instance:

```YAML
templates:
  - '/config/templates/template.tmpl'
```
3. Inside `template.tmpl` you define some templates like `{{ define "<template_name>" }}...{{ end }}`. To see them, it is needed to reference the specific template to load in `alertmanager.yml`. For example:

```YAML
receivers:
  - name: ...
    email_configs:
      - to: '...@gmail.com'
        html: '{{ template "<template_name>" . }}'
```

### How to create and apply a notification template subject
On condition that you want to apply a custom subject for the received notification mail:
1. Define it in the `.tmpl` file (that is being referenced from `alertmanager.yml`, specifically in the `templates:` section). For example:

```.tmpl
...
{{ define "<my_mail_subject>" }}
<My Subject>
{{end}}
...
```

2. Import the `<my_mail_subject>` in `alertmanager.yml` as a header for the mail notifications:

```YAML
receivers:
  - name: ...
    email_configs:
      - to: '...@gmail.com'
        headers:
          subject: '{{ template "<my_mail_subject>" . }}'
        html: '{{ template "<template_name>" . }}'
        
```

### How to manually resolve alerts
Whenever you POST alerts to Alertmanager, you can simulate the time instants _from_ and _to_ they are firing with `startsAt` and `endsAt` fields. For instance, you can create a test alert `alarm.json` like:

```JSON
{
  "labels": {
    "alertname": "test-alert"
  },
  "startsAt": "2024-11-05T10:02:40.544069-06:00",
  "endsAt": "2024-12-05T10:02:40.544069-06:00"
}
```

And that alert would be active (i.e. _Firing_) from `2024-11-05T10:02:40.544069-06:00` to `2024-12-05T10:02:40.544069-06:00`.

However, to prevent it from firing until the `endsAt` date, you can manually resolve it through modifying the `endsAt` field to another past value and then POST the alert again to alertmanager with the same `labels`:

```JSON
{
  "labels": {
    "alertname": "test-alert"
  },
  "startsAt": "2024-11-05T10:02:40.544069-06:00",
  "endsAt": "2024-11-05T10:03:40.544069-06:00"
}
```

# Useful references
- [Alertmanager configuration file](https://prometheus.io/docs/alerting/latest/configuration/)
- [Alertmanager template configuration](https://prometheus.io/docs/alerting/latest/notifications/)
- [Alertmanager API Specification](https://github.com/prometheus/alertmanager/blob/main/api/v2/openapi.yaml)
- [Go templating system](https://pkg.go.dev/text/template)