from os import getenv
from datetime import datetime
import signal
import subprocess
from apscheduler.schedulers.blocking import BlockingScheduler
from apscheduler.triggers.cron import CronTrigger

DOMAINS = getenv("DOMAINS", "")
EMAIL = getenv("EMAIL", "")
if not DOMAINS or not EMAIL:
    raise ValueError("Environment variables DOMAINS and EMAIL must be set.")


def certonly():
    cmd = (
        "certbot", "certonly",
        "--domains", DOMAINS,
        "--manual",
        "--preferred-challenges", "dns",
        "--manual-auth-hook", "python /app/auth.py",
        "--manual-cleanup-hook", "python /app/cleanup.py",
        "--agree-tos",
        "--email", EMAIL,
        "--no-eff-email",
        "--keep-until-expiring",
        "--work-dir", "/app/work",
        "--logs-dir", "/app/log",
        "--config-dir", "/app/config",
    )
    if getenv("DRY_RUN", "").lower() in ["true", "1", "yes"]:
        cmd += ("--dry-run",)

    print(f"{datetime.now()} | Execute command: ↲\n", subprocess.list2cmdline(cmd))
    subprocess.run(cmd)


if __name__ == "__main__":

    def job_func():
        certonly()
        print("The next renewal try is at: ", job.next_run_time)

    scheduler = BlockingScheduler()
    trigger = CronTrigger.from_crontab(
        getenv("CRON_SCHEDULE") or "0 0 1/10 * *"
    )  # Every 10 days by default
    job = scheduler.add_job(job_func, trigger, next_run_time=datetime.now())

    def handle_sigterm(signum, frame):
        print("Received SIGTERM, shutting down scheduler...")
        scheduler.shutdown(wait=False)

    signal.signal(signal.SIGTERM, handle_sigterm)

    try:
        scheduler.start()
    except (KeyboardInterrupt, SystemExit):
        pass
