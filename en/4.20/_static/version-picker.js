(function () {
  function currentVersion() {
    const parts = location.pathname.split("/").filter(Boolean);
    // /docs/en/<version>/...
    if (parts[0] === "docs" && parts[1] === "en" && parts[2]) return parts[2];
    return null;
  }

  function samePageTarget(versionBaseUrl) {
    const parts = location.pathname.split("/").filter(Boolean);
    if (parts.length < 3) return versionBaseUrl;
    const rest = parts.slice(3).join("/");
    if (!rest) return versionBaseUrl;
    return versionBaseUrl.replace(/\/$/, "") + "/" + rest;
  }

  async function run() {
    const container = document.querySelector(".rst-other-versions");
    if (!container) return;

    let manifest;
    try {
      const res = await fetch("/docs/versions.json", { cache: "no-store" });
      if (!res.ok) return;
      manifest = await res.json();
    } catch {
      return;
    }

    const versions = Array.isArray(manifest.versions) ? manifest.versions : [];
    if (!versions.length) return;

    const curr = currentVersion();

    // Build <dl> the RTD theme expects
    const dl = document.createElement("dl");
    const dt = document.createElement("dt");
    dt.textContent = "Versions";
    dl.appendChild(dt);

    versions.forEach((v) => {
      const dd = document.createElement("dd");
      const a = document.createElement("a");
      a.textContent = v.title || v.id;
      a.href = v.url;

      if (curr && v.id === curr) {
        const strong = document.createElement("strong");
        strong.appendChild(a);
        dd.appendChild(strong);
      } else {
        dd.appendChild(a);
      }
      dl.appendChild(dd);
    });

    // Replace existing dl if present
    const existingDl = container.querySelector("dl");
    if (existingDl) existingDl.replaceWith(dl);
    else container.prepend(dl);

    // Update the top label "v: X" if present
    const label = document.querySelector(".rst-current-version");
    if (label && curr) {
      label.innerHTML = label.innerHTML.replace(/v:\s*[^<\n]+/, "v: " + curr);
    }
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", run);
  } else {
    run();
  }
})();