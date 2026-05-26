import { useState, useEffect } from "react";

const LICENSE_URL =
  "https://gist.githubusercontent.com/caironf3nexorai/20aa31d03760d9368265c5eca8d98c74/raw/control.json";

type LicenseStatus = "checking" | "active" | "blocked";

export function useLicenseCheck() {
  const [status, setStatus] = useState<LicenseStatus>("checking");
  const [msg, setMsg] = useState("");

  useEffect(() => {
    const check = async () => {
      try {
        const res = await fetch(`${LICENSE_URL}?t=${Date.now()}`, {
          cache: "no-store",
        });
        if (!res.ok) throw new Error();
        const data = await res.json();
        setStatus(data.status === "1" ? "active" : "blocked");
        setMsg(data.msg || "");
      } catch {
        setStatus("blocked");
      }
    };

    check();
  }, []);

  return { status, msg };
}
