# Module 1 : Ingestion & 11 Multi-Source Cores — ENVIRONNEMENT TECHNIQUE DE CODAGE DE RÉFÉRENCE
**ID Module** : M01_INGESTION_CORES  
**Statut de Sûreté** : 🟢 INTÉGRITÉ COGNITIVE ET TECHNIQUE VALIDÉE (ZÉRO INVENTIONS AUTORISÉES)  
**Date d'Émission** : 2026-06-12  

---

## 🧭 Fiche de Synthèse
* **Description Fonctionnelle** : Système d'ingestion multilingue à 11 Cores à coût d'infrastructure nul (0$).
* **Stack Technique Officielle** : Mastra TS, Docling (Docker), Scrapling, Composio OAuth, Whisper, yt-transcript-rs
* **Patterns d'Ingénierie à Respecter** : MapReduce L0-L4, Ingestion Queue, OAuth Session Handshake

---

# 📥 MODULE 1 : Ingestion & 11 Multi-Source Cores — Spécifications de Codage

## 1. Description du Module
Ce module gère l'ingestion asynchrone multilingue d'informations brutes à partir de 11 sources distinctes, et leur conversion en Markdown sémantique propre.

## 2. Ingestion Cores & Stack Technique
1. **YouTube** : `youtube-dl` + `yt-transcript-rs` -> transcriptions, chapitres et timestamps.
2. **Web/Article** : **Scrapling** + `dom_smoothie` -> clean HTML, contournement anti-bot.
3. **Academic** : APIs Scholar/arXiv + extraction de DOI/ISBN.
4. **Google Drive** : **Composio** OAuth + `google-drive3`.
5. **Podcast** : Whisper API -> transcription + diarization.
6. **Financial** : SEC EDGAR APIs + Earnings calls transcripts.
7. **Twitter/X** : Twitter API v2 -> reconstruction de threads récursifs.
8. **Wikipedia** : MediaWiki API -> wikilinks-to-graph extraction.
9. **Science** : arXiv API -> formules LaTeX et figures.
10. **TikTok** : Web scraping + Whisper.
11. **Reddit** : Roux Crate -> comments tree extraction.

## 3. Pattern de Code (Mastra TS Adaptateur Ingestion)
```typescript
import { Step } from '@mastra/core';
import { exec } from 'child_process';

export const youtubeIngestStep = new Step({
  id: 'youtube-ingest',
  execute: async ({ context }) => {
    const videoUrl = context.url;
    // Exécution du binaire d'extraction (0$ infrastructure)
    const transcript = await runYtTranscript(videoUrl);
    return { transcript, status: 'parsed' };
  }
});

async function runYtTranscript(url: string): Promise<string> {
  return new Promise((resolve, reject) => {
    exec(`yt-transcript-rs --url "${url}"`, (error, stdout) => {
      if (error) reject(error);
      resolve(stdout.trim());
    });
  });
}
```


---

## 🛑 DIRECTIVES STRICTES CONTRE L'HALLUCINATION (AI DE CODELING)
Pour garantir la réussite absolue du codage de ce module par nos agents de développement :
1. **Ne jamais inventer d'APIs tierces** : Utilise scrupuleusement les bibliothèques et connecteurs listés dans la stack.
2. **Ne pas modifier les structures de données** : Référence-toi à l'index SQL consolidé de la base de données Insforge.
3. **Respecter la palette de couleurs spatiale** : Ne jamais introduire de rouge ou de bleu fade en dehors des tokens d'interface fixés dans `design.md`.
4. **Validation des schémas** : Tout retour JSON d'agent s'appuie sur la validation stricte de modèles **Zod** avec gestion de retries.
