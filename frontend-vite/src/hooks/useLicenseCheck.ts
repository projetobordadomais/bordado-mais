import { useState, useEffect } from "react";

const LICENSE_URL = import.meta.env.VITE_LICENSE_URL;

type LicenseStatus = "checking" | "active" | "blocked";

export function useLicenseCheck() {
  const [status, setStatus] = useState<LicenseStatus>("checking");
  const [msg, setMsg] = useState("");

  useEffect(() => {
    const check = async () => {
      try {
        // Extrair o ID do gist a partir da URL raw no .env
        // Ex: https://gist.githubusercontent.com/user/20aa31d03760d9368265c5eca8d98c74/raw/...
        const match = LICENSE_URL.match(/gist\.githubusercontent\.com\/[^\/]+\/([a-f0-9]+)/);
        const gistId = match ? match[1] : "20aa31d03760d9368265c5eca8d98c74";

        // Usar a API do GitHub para bypassar o cache de 5 minutos do Raw
        const res = await fetch(`https://api.github.com/gists/${gistId}?t=${Date.now()}`, {
          cache: "no-store",
        });
        if (!res.ok) throw new Error();
        const apiData = await res.json();
        
        // O conteúdo vem como uma string dentro de files["control.json"].content
        const contentStr = apiData?.files?.["control.json"]?.content;
        const data = contentStr ? JSON.parse(contentStr) : {};
        
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
