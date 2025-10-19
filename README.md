name: Afili Auto Workflow

on:
  workflow_dispatch:   # avvio manuale dal tab "Actions"

jobs:
  afili:
    runs-on: ubuntu-latest
    steps:
      - name: Scarica i file del progetto
        uses: actions/checkout@v4
      - name: Installa Python
        uses: actions/setup-python@v5
        with:
          python-version: "3.10"
      - name: Esegui lo script Afili
        run: |
          python3 script_afili.py