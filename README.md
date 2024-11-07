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
1. Edit `alertmanager.yml`
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
1. Create a folder inside `/config` directory
2. Add and create the template file with `.tmpl` extension, which is the format for Go templating system
3. Reference that file in your `alertmanager.yml` configuration file. For instance:

```YAML
templates:
  - '/config/templates/template.tmpl'
```
4. Inside `template.tmpl` you define some templates like `{{ define "<template_name>" }}...{{ end }}`. To see them, it is needed to reference the specific template to load in `alertmanager.yml`. For example:

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

# Useful references
- [Alertmanager configuration file](https://prometheus.io/docs/alerting/latest/configuration/)
- [Alertmanager template configuration](https://prometheus.io/docs/alerting/latest/notifications/)
- [Alertmanager API Specification](https://github.com/prometheus/alertmanager/blob/main/api/v2/openapi.yaml)
- [Go templating system](https://pkg.go.dev/text/template)