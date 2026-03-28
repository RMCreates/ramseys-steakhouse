#!/bin/bash
cp index.html docs/
cp booking.html docs/
cp admin.html docs/
cp logo.png docs/
cp menu.html docs/
cp about.html docs/
cp contact.html docs/
git add .
git commit -m "${1:-update}"
git push
echo "Deployed successfully!"
