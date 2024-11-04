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