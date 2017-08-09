google-chrome-repo:
  pkgrepo.managed:
    - humanname: Google Chrome
    - name: deb [arch=amd64] http://dl.google.com/linux/chrome/deb stable main
    - file: /etc/apt/sources.list.d/google-chrome.list
    - key_url: https://dl.google.com/linux/linux_signing_key.pub
