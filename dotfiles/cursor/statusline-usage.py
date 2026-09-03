#!/usr/bin/env python3
"""Fetch Cursor dashboard spend into a JSON cache for the CLI statusline.

Uses the local CLI session in ~/.config/cursor/auth.json. Never prints tokens.
"""
import base64
import datetime
import json
import os
import sys
import time
import urllib.error
import urllib.request

cache_path = sys.argv[1]
session_start_ms = int(sys.argv[2] or 0)
session_id = sys.argv[3] if len(sys.argv) > 3 else ""
auth_path = os.path.expanduser("~/.config/cursor/auth.json")
out = {"ok": False, "ts": int(time.time()), "session_id": session_id}


def write(data):
    tmp = cache_path + ".tmp"
    with open(tmp, "w") as f:
        json.dump(data, f)
    os.replace(tmp, cache_path)


def main():
    auth = json.loads(open(auth_path).read())
    token = (auth.get("accessToken") or "").strip()
    if not token:
        write(out)
        return
    if "::" in token:
        cookie_val = token.replace("::", "%3A%3A")
    else:
        payload = token.split(".")[1]
        payload += "=" * (-len(payload) % 4)
        claims = json.loads(base64.urlsafe_b64decode(payload))
        sub = str(claims.get("sub") or "").split("|")[-1]
        cookie_val = "%s%%3A%%3A%s" % (sub, token)

    def req(path, method="GET", body=None, timeout=8):
        headers = {
            "Cookie": "WorkosCursorSessionToken=" + cookie_val,
            "Accept": "application/json",
            "User-Agent": "cursor-statusline/1.0",
        }
        data = None
        if body is not None:
            data = json.dumps(body).encode()
            headers["Content-Type"] = "application/json"
            headers["Origin"] = "https://cursor.com"
        request = urllib.request.Request(
            "https://cursor.com" + path, data=data, headers=headers, method=method
        )
        with urllib.request.urlopen(request, timeout=timeout) as resp:
            raw = resp.read().decode("utf-8", "ignore")
        return json.loads(raw) if raw else {}

    summary = req("/api/usage-summary")
    me = req("/api/auth/me")
    user_id = me.get("id")
    now_ms = int(time.time() * 1000)
    start_iso = summary.get("billingCycleStart") or ""
    try:
        cycle_start = datetime.datetime.fromisoformat(start_iso.replace("Z", "+00:00"))
        cycle_start_ms = int(cycle_start.timestamp() * 1000)
    except Exception:
        cycle_start_ms = now_ms - 30 * 24 * 3600 * 1000

    cycle_cents = None
    session_cents = None
    if user_id is not None:
        agg = req(
            "/api/dashboard/get-aggregated-usage-events",
            "POST",
            {
                "teamId": 0,
                "startDate": str(cycle_start_ms),
                "endDate": str(now_ms),
                "userId": user_id,
            },
        )
        if agg.get("totalCostCents") is not None:
            cycle_cents = float(agg["totalCostCents"])
        if session_start_ms > 0:
            sess = req(
                "/api/dashboard/get-aggregated-usage-events",
                "POST",
                {
                    "teamId": 0,
                    "startDate": str(session_start_ms),
                    "endDate": str(now_ms),
                    "userId": user_id,
                },
            )
            if sess.get("totalCostCents") is not None:
                session_cents = float(sess["totalCostCents"])

    if cycle_cents is None:
        used = (((summary.get("individualUsage") or {}).get("overall") or {}).get("used"))
        if used is not None:
            cycle_cents = float(used)

    out.update(
        {
            "ok": True,
            "cycle_cents": cycle_cents,
            "session_cents": session_cents,
            "session_start_ms": session_start_ms,
        }
    )
    write(out)


if __name__ == "__main__":
    try:
        main()
    except Exception:
        try:
            write(out)
        except Exception:
            pass
        sys.exit(0)
