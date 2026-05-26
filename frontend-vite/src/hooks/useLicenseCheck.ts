import { useState, useEffect } from "react";

const LICENSE_URL = import.meta.env.VITE_LICENSE_URL;

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
