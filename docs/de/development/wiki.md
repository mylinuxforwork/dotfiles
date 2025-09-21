# Zur Mitwirkung am Wiki

Dieses Wiki wurde mit [VitePress](https://vitepress.dev/) erstellt.

Die Wiki-Dateien findest du im Repository [ml4w dotfiles](https://github.com/mylinuxforwork/dotfiles).

Wenn du beitragen möchtest: Forke das Repo, nimm deine Änderungen vor und öffne einen Pull Request.

## Docs lokal bauen

Installiere `bun` von der offiziellen Seite: https://bun.sh

Abhängigkeiten installieren:

```sh
bun install
```

VitePress als Dev-Abhängigkeit hinzufügen (falls nötig):

```sh
bun add -D vitepress
```

Dev-Server starten, um Änderungen live zu sehen:

```sh
bun run docs:dev
```

Build testen:

```sh
bun run docs:build
```

Vorschau:

```sh
bun run docs:preview
```

Stelle sicher, dass deine Änderungen keine Fehler einführen. Teste alles lokal, bevor du einen PR öffnest.

## Richtlinien

Wenn deine Änderungen Inhalte hinzufügen (z. B. eine neue Anleitung), achte auf Genauigkeit und klare, saubere Markdown-Formatierung.

Wir bitten außerdem, keine kompletten Umschreibungen oder vollständige Texte ausschließlich durch LLMs erstellen zu lassen.

Bitte vermeide `em dashes` in den Docs.

> Unsere Devise: sauber & minimal also bitte halte dich an diese Richtlinien.

## Mehrsprachigkeit

> [!WARNING]
>
> Dokumentationen in anderen Sprachen als Englisch sind möglicherweise nicht aktuell. Überprüfe das angezeigte Datum und die angezeigte ml4w-Version und ziehe im Zweifel die englische Dokumentation zu Rate.

> [!NOTE]
> Letzte Aktualisierung: 21. September 2025
> Basierend auf ml4w Version: 2.9.9.2

**Um eine neue Sprache hinzuzufügen, gehe wie folgt vor:**

1. Erstelle einen Ordner mit dem Sprachcode (z. B. `docs/de/`) und lege dort die übersetzten Markdown-Dateien ab.
2. Füge die Locale in `.vitepress/config.ts` hinzu. Minimalbeispiel:

```ts
// .vitepress/config.ts
export default {
  locales: {
    de: {
      label: "Deutsch",
      lang: "de-DE",
      title: 'ML4W Dotfiles für Hyprland Wiki',
      description: 'Eine fortschrittliche und voll ausgestattete Konfiguration für den dynamischen Tiling-Window-Manager Hyprland',
    }
  }
}
```

3. Stelle sicher, dass Routen und Navigation das Sprachpräfix (z. B. `/de/`) verwenden, und passe interne Links entsprechend an.
4. Gib in diesem Abschnitt das Datum und die ml4w-Version an, die der letzten Änderung der Dokumentation in dieser Sprache entsprechen.

> Danke für deine Unterstützung.
