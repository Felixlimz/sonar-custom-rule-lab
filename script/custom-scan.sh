#!/bin/bash
echo "Running custom scan..."
OUTPUT=custom-issues.json
echo "[" > $OUTPUT
FIRST=true
for file in $(find . -name "*.java"); do
LINE_NUM=0
while IFS= read -r line; do
LINE_NUM=$((LINE_NUM+1))
if [[ "$line" == *"HARDCODE_PASSWORD"* ]]; then
if [ "$FIRST" = false ]; then
echo "," >> $OUTPUT
fi
FIRST=false
cat <<EOF >> $OUTPUT
{
"engineId": "custom-scanner",
"ruleId": "hardcoded-password",
"severity": "CRITICAL",
"type": "VULNERABILITY",
"primaryLocation": {
"message": "Hardcoded password detected",
"filePath": "$file",
"textRange": {
"startLine": $LINE_NUM,
"endLine": $LINE_NUM
}
}
}
EOF
fi
done < "$file"
done
echo "]" >> $OUTPUT
echo "Custom scan finished"