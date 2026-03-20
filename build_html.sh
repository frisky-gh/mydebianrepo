#!/bin/sh
set -eu

OUT=index.html
PACKAGESGZ=./Packages.gz

cat > "$OUT" <<'EOF'
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="utf-8">
  <title>My Debian APT Repository</title>
  <style>
    body { font-family: sans-serif; }
    table { border-collapse: collapse; }
    th, td { border: 1px solid #ccc; padding: 4px 8px; }
    th { background: #f0f0f0; }
  </style>
</head>
<body>
<h1>My Debian APT Repository</h1>

<p>
APT repository hosted on GitHub Pages.
</p>

<h2>APT usage</h2>
<pre>
curl -fsSL https://frisky-gh.github.io/mydebianrepo/frisky-gh-repo.asc |
sudo gpg --dearmor -o /etc/apt/keyrings/frisky-gh-repo.gpg

echo "deb [signed-by=/etc/apt/keyrings/frisky-gh-repo.gpg] https://frisky-gh.github.io/mydebianrepo/ ./https://frisky-gh.github.io/mydebianrepo/ ./" |
sudo tee /etc/apt/sources.list.d/frisky-gh-repo.list
</pre>

<h2>Packages</h2>
<table>
<tr><th>Name</th><th>Version</th><th>Description</th></tr>
EOF

zcat "$PACKAGESGZ" |
awk '
  /^Package:/     { p=$2 }
  /^Version:/     { v=$2 }
  /^Description:/ { d=$0; sub("Description: ","",d) }
  /^$/ {
    if (p != "") {
      printf "<tr><td>%s</td><td>%s</td><td>%s</td></tr>\n", p, v, d
    }
    p=v=d=""
  }
' >> "$OUT"

cat >> "$OUT" <<'EOF'
</table>
</body>
</html>
EOF
