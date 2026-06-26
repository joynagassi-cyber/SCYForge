# 🎙️ SCY-FORGE — SYSTÈME VOCAL LIVEKIT (ARENA, BRAIN, CHRONICLE, COSMOS, DAG)
**ID Spécification** : S00_LIVEKIT_VOICE_SPEC  
**Date** : 2026-06-26  
**Statut** : 🟢 SPÉCIFICATION TECHNIQUE VALIDÉE  
**Projet open-source** : [LiveKit](https://livekit.io) + [LiveKit Agents](https://docs.livekit.io/agents/) (Apache 2.0)

---

## 1. Pourquoi LiveKit ?

Le système vocal de SCY Forge est critique pour 5 fonctionnalités majeures :
1. **ARENA** — Roleplay Full-AI (l'utilisateur parle, le persona IA répond en voix)
2. **BRAIN** — Professor AI vocal (questions/réponses mains-libres)
3. **CHRONICLE** — Conversation-native WhatsApp/push (Daily Pulse vocal, résurrection)
4. **COSMOS** — Navigation vocale agentique (« montre-moi mes lacunes »)
5. **DAG** — Navigation et planification vocale du parcours

**Sans LiveKit**, coder tout ça reviendrait à :
- Gérer manuellement le WebRTC (STUN/TURN/ICE)
- Gérer manuellement la détection de tour (quand l'utilisateur a fini de parler)
- Gérer manuellement les interruptions (l'utilisateur coupe la parole à l'IA)
- Gérer manuellement le VAD (Voice Activity Detection)
- Gérer manuellement l'écho (l'IA s'entend elle-même → feedback loop)
- Gérer manuellement le streaming audio bidirectionnel basse latence

**Avec LiveKit**, tout ça est **pré-construit et production-ready** :
- WebRTC infrastructure gérée (LiveKit Cloud ou self-hosted)
- **VAD intégré** (Silero VAD local ou server VAD OpenAI)
- **Détection de tour adaptive** (distingue vraie interruption vs backchanneling "hmm")
- **Interruption management** (l'utilisateur coupe → l'IA stoppe immédiatement)
- **Echo cancellation natif** (BVC - Background Voice Cancellation)
- **OpenAI Realtime API** intégré (speech-in / speech-out, un seul modèle)
- **Frontend components React** prêts (`@livekit/components-react`)

---

## 2. Architecture LiveKit dans SCY Forge

```
┌──────────────────────────────────────────────────────────────────┐
│                    UTILISATEUR (Navigateur / Mobile)             │
│                                                                  │
│  frontend_react/src/components/VoiceInterface.tsx                │
│  ├── LiveKitRoom (connexion WebRTC)                             │
│  ├── RoomAudioRenderer (audio output)                           │
│  ├── BarVisualizer (visualisation onde sonore)                  │
│  ├── useVoiceAssistant (état listening/thinking/speaking)       │
│  └── Push-to-talk optionnel                                     │
└──────────────────────────┬───────────────────────────────────────┘
                           │ WebRTC (audio bidirectionnel)
                           ▼
┌──────────────────────────────────────────────────────────────────┐
│              LIVEKIT SERVER (Cloud ou self-hosted Docker)        │
│  ├── Room management (1 room par session vocale)                │
│  ├── TURN/STUN (NAT traversal)                                  │
│  ├── BVC Noise Cancellation (Krisp)                             │
│  └── Dispatch rules (route vers le bon agent worker)            │
└──────────────────────────┬───────────────────────────────────────┘
                           │
                           ▼
┌──────────────────────────────────────────────────────────────────┐
│              LIVEKIT AGENT WORKER (Python sidecar Docker)        │
│  backend_ts/src/voice/agent_worker.py                           │
│                                                                  │
│  ┌── ARENA Voice Agent ──────────────────────────────────────┐  │
│  │ AgentSession(                                                 │  │
│  │   llm=openai.realtime.RealtimeModel(voice="marin"),        │  │
│  │   turn_detection=AdaptiveInterruption(),                    │  │
│  │   vad=silero.VAD.load(),                                     │  │
│  │   instructions=HSM_PERSONA_INSTRUCTIONS,                     │  │
│  │ )                                                             │  │
│  └──────────────────────────────────────────────────────────┘  │
│  ┌── BRAIN Voice Agent ───────────────────────────────────────┐  │
│  │ AgentSession(                                                 │  │
│  │   llm=openai.realtime.RealtimeModel(                        │  │
│  │     modalities=["text"],  # text-only → TTS séparé         │  │
│  │   ),                                                          │  │
│  │   stt=assemblyai.STT(),    # STT séparé                     │  │
│  │   tts=cartesia.TTS("sonic-3"), # TTS séparé                │  │
│  │   turn_detection=MultilingualModel(),                       │  │
│  │ )                                                             │  │
│  └──────────────────────────────────────────────────────────┘  │
│  ┌── CHRONICLE Voice Agent ──────────────────────────────────┐  │
│  │ AgentSession(                                                 │  │
│  │   llm=openai.realtime.RealtimeModel(voice="alloy"),       │  │
│  │   turn_detection="server_vad",                              │  │
│  │ )                                                             │  │
│  └──────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

---

## 3. Les 2 Architectures Vocales

### Architecture A — Realtime complet (1 modèle fait tout)

**Pour ARENA et CHRONICLE** : latence minimale, voix naturelle.

```
[Parole utilisateur] ──► OpenAI Realtime API (GPT-4o Realtime)
                            ├── Comprend la parole (audio-in)
                            ├── Génère la réponse (raisonnement)
                            └── Parle la réponse (audio-out)
                                    │
                                    ▼
                        [Réponse vocale en streaming]
```

**Avantages** : latence ultra-basse (~300ms), voix naturelle émotionnelle, gère les interruptions nativement.
**Coût** : ~$0.06/min (OpenAI Realtime API).

### Architecture B — Cascade (STT + LLM + TTS séparés)

**Pour BRAIN et COSMOS** : contrôle total, coût optimisé, RAG personnalisé.

```
[Parole utilisateur]
       │
       ▼
[STT : AssemblyAI / Deepgram] ──► texte
       │
       ▼
[LLM : DeepSeek V4 + RAG SCY-BRAIN] ──► réponse texte
       │ (avec citations, Thread-of-Thought, humilité)
       ▼
[TTS : Cartesia Sonic-3 / OpenAI TTS] ──► audio streaming
       │
       ▼
[Réponse vocale]
```

**Avantages** : contrôle total (RAG personnalisé, charte humilité, citations), coût optimisé (~$0.01/min avec DeepSeek).
**Latence** : ~800ms-1.2s (acceptable pour Q&R pédagogique, pas pour roleplay temps réel).

---

## 4. Les 5 Cas d'Usage Vocaux SCY Forge

### 4.1 ARENA — Roleplay Full-AI Vocal (Architecture A)

```python
# backend_ts/src/voice/arena_voice_agent.py

from livekit.agents import Agent, AgentSession, JobContext, WorkerOptions, cli
from livekit.plugins import openai, silero, noise_cancellation
from livekit.plugins.turn_detector.multilingual import MultilingualModel

# Le persona ARENA avec HSM (Hiérarchical State Machine)
ARENA_PERSONA_INSTRUCTIONS = """
Tu es {persona_role}. {persona_psychology}
État actuel : {hsm_state} (Méfiant/Intéressé/Convaincu/Fermé).
Ton mood score est {mood_score}/1.0.
Adapte ton ton selon ton état psychologique.
Si l'utilisateur dit quelque chose de brillant → deviens plus intéressé.
Si l'utilisateur monopolise la parole → reste poli mais froid.
Niveau de résistance calibré : {difficulty_level}.
"""

class ArenaVoiceAgent(Agent):
    def __init__(self, persona_config: dict):
        super().__init__(
            instructions=ARENA_PERSONA_INSTRUCTIONS.format(**persona_config),
            # Architecture A : Realtime complet (speech-in/speech-out)
            llm=openai.realtime.RealtimeModel(
                voice=persona_config.get("voice", "marin"),
                turn_detection=TurnDetection(
                    type="server_vad",
                    threshold=0.5,
                    prefix_padding_ms=300,
                    silence_duration_ms=500,
                    create_response=True,
                    interrupt_response=True,  # L'utilisateur peut couper
                ),
            ),
            vad=silero.VAD.load(),  # VAD local pour précision
        )

    async def on_enter(self):
        # L'agent commence la conversation (premier message du persona)
        await self.session.generate_reply(
            instructions="Démarre le scénario. Présente-toi en persona."
        )

async def entrypoint(ctx: JobContext):
    await ctx.connect(auto_subscribe=AutoSubscribe.AUDIO_ONLY)

    # Récupérer le persona depuis les métadonnées de la room
    persona_config = ctx.room.metadata  # JSON avec role, psychologie, etc.

    session = AgentSession(
        # Architecture A : tout-en-un Realtime
        # Pas besoin de STT/TTS séparés
    )

    await session.start(
        room=ctx.room,
        agent=ArenaVoiceAgent(persona_config),
        room_input_options=RoomInputOptions(
            noise_cancellation=noise_cancellation.BVC(),  # Écho cancellation
        ),
    )

if __name__ == "__main__":
    cli.run_app(WorkerOptions(
        entrypoint_fnc=entrypoint,
        agent_name="arena-voice-agent",
    ))
```

### 4.2 BRAIN — Professor AI Vocal (Architecture B)

```python
# backend_ts/src/voice/brain_voice_agent.py

from livekit.agents import Agent, AgentSession, JobContext, WorkerOptions, cli
from livekit.plugins import openai, assemblyai, cartesia, silero, noise_cancellation
from livekit.plugins.turn_detector.multilingual import MultilingualModel

BRAIN_INSTRUCTIONS = """
Tu es Professor AI de SCY Forge. RÈGLES STRICTES :
1. Max 2 paragraphes par réponse (D-OPT-022)
2. Toujours finir par une question socratique ciblée
3. Humilité totale : jamais juger, jamais condescendre
4. Si tu ne sais pas → dis-le honnêtement
5. Adapte ton ton : ELI5 pour débutant, ELI-PhD pour expert
6. Thread-of-Thought : relie au nœud ASCENT actuel
"""

class BrainVoiceAgent(Agent):
    def __init__(self, user_context: dict):
        super().__init__(
            instructions=BRAIN_INSTRUCTIONS,
            # Architecture B : cascade (contrôle total du RAG)
            stt=assemblyai.STT(),  # STT haute précision
            llm=openai.LLM.with_cerebras(model="llama-3.3-70b"),
            # Ou : llm=deepseek.LLM(model="deepseek-v4"),
            tts=cartesia.TTS(
                model="sonic-3",
                voice="friend",  # Voix chaleureuse
                speed_alpha=0.95,
                reduce_latency=True,
            ),
            vad=silero.VAD.load(),
            turn_detection=MultilingualModel(),  # Détecte fin de tour multilingue
        )

    async def on_user_turn_completed(self, turn_ctx, new_message):
        """Hook : avant que le LLM ne réponde, injecter le RAG SCY-BRAIN"""
        user_text = new_message.text_content

        # Triple Retrieval (Dense + BM25 + Graph + RRF)
        rag_context = await brain_rag.retrieve(user_text, top_k=5)

        # Injecter le contexte RAG dans la conversation
        turn_ctx.add_message(
            role="system",
            content=f"Contexte de tes sources : {rag_context}"
        )

        # Suggestions intelligentes (3 questions complémentaires)
        suggestions = await doc_suggester.suggest(user_text)

async def entrypoint(ctx: JobContext):
    await ctx.connect()

    session = AgentSession()
    await session.start(
        room=ctx.room,
        agent=BrainVoiceAgent(user_context),
        room_input_options=RoomInputOptions(
            noise_cancellation=noise_cancellation.BVC(),
        ),
    )
```

### 4.3 CHRONICLE — Daily Pulse Vocal (Architecture A, court)

```python
# backend_ts/src/voice/chronicle_voice_agent.py

class ChronicleVoiceAgent(Agent):
    def __init__(self, user_prefs: dict):
        super().__init__(
            instructions="""
            Tu es CHRONICLE, le Knowledge Guardian de SCY Forge.
            CHARTE D'HUMILITÉ TOTALE :
            - L'oubli est normal, jamais une faute
            - Proposer, jamais imposer
            - Honnêteté radicale
            - Court, utile, précis (zéro blabla)
            
            Mission : donner le Daily Pulse (bulletin de santé mémoire).
            """,
            llm=openai.realtime.RealtimeModel(
                voice="alloy",  # Voix douce
                turn_detection=TurnDetection(
                    type="server_vad",
                    silence_duration_ms=800,  # Plus patient (pas d'interruption)
                ),
            ),
        )

    async def on_enter(self):
        """Au démarrage : donner le Daily Pulse"""
        health = await health_monitor.get(user_id)
        concept_of_day = await pulse_generator.get_concept(user_id)

        await self.session.generate_reply(
            instructions=f"""
            Donne le Daily Pulse :
            - Santé globale : {health.score}%
            - {len(health.critical)} concepts critiques
            - Concept du jour : {concept_of_day.name}
            Rappel express : {concept_of_day.cran5}
            
            Reste sobre, humble, court. Termine par :
            "Si tu veux faire les 3 cartes dues, c'est 2 min. Ou pas."
            """
        )
```

### 4.4 COSMOS — Navigation Vocale Agentique

```python
# L'utilisateur dit : "Montre-moi mes lacunes en React"
# → COSMOS bascule automatiquement vers le Mode 14 (Radar)

class CosmosVoiceAgent(Agent):
    async def on_user_turn_completed(self, turn_ctx, new_message):
        command = new_message.text_content.lower()

        # Routing vocal vers COSMOS
        if "lacunes" in command or "faiblesses" in command:
            await cosmos_api.visualize(
                mode=CosmosMode.M14,  # Radar
                filter=DataFilter.Domain(extract_domain(command)),
                auto_switch=True,
            )
        elif "timeline" in command or "calendrier" in command:
            await cosmos_api.visualize(mode=CosmosMode.GANTT)
        elif "arbre" in command or "structure" in command:
            await cosmos_api.visualize(mode=CosmosMode.THEMATIC_TREE)
```

### 4.5 DAG — Navigation Vocale du Parcours

```python
# L'utilisateur dit : "Où j'en suis dans mon parcours ?"
# → CHRONICLE répond + COSMOS bascule sur la Roadmap

class DagVoiceAgent(Agent):
    async def on_user_turn_completed(self, turn_ctx, new_message):
        command = new_message.text_content.lower()

        if "parcours" in command or "où j'en suis" in command:
            progress = await ascent.get_progress(user_id)
            await cosmos_api.visualize(
                mode=CosmosMode.M04,  # Roadmap ASCENT
                highlight=[progress.current_node_id],
            )
            # CHRONICLE répond vocalement
            await self.session.generate_reply(
                instructions=f"""
                Dis : "Tu es sur {progress.current_node_name}.
                {progress.percent}% complété. SMI {progress.smi}/100.
                Prochain nœud : {progress.next_node}. Tu veux continuer ?"
                """
            )
```

---

## 5. Frontend — Composants React LiveKit

### 5.1 Installation

```bash
cd frontend_react
pnpm add @livekit/components-react livekit-client
```

### 5.2 Composant VoiceInterface

```tsx
// frontend_react/src/components/VoiceInterface.tsx

import {
  LiveKitRoom,
  RoomAudioRenderer,
  BarVisualizer,
  useVoiceAssistant,
  useTracks,
} from '@livekit/components-react';
import { Track } from 'livekit-client';

interface VoiceInterfaceProps {
  token: string;        // Token LiveKit (généré côté serveur)
  serverUrl: string;    // LiveKit Cloud URL ou self-hosted
  agentType: 'arena' | 'brain' | 'chronicle' | 'cosmos';
}

export const VoiceInterface: React.FC<VoiceInterfaceProps> = ({
  token,
  serverUrl,
  agentType,
}) => {
  return (
    <LiveKitRoom
      serverUrl={serverUrl}
      token={token}
      connect={true}
      audio={true}
      video={false}
      // Data channel pour COSMOS agent commands
      data-lake-className="voice-room"
    >
      <VoiceAssistantUI agentType={agentType} />
      <RoomAudioRenderer />  {/* Audio output */}
    </LiveKitRoom>
  );
};

const VoiceAssistantUI: React.FC<{ agentType: string }> = ({ agentType }) => {
  const { audioTrack, state } = useVoiceAssistant();

  // state = 'listening' | 'thinking' | 'speaking'
  const stateLabel = {
    listening: '🎙️ J'écoute...',
    thinking: '🤔 Je réfléchis...',
    speaking: '💬 Je parle...',
  }[state] || 'Prêt';

  return (
    <div className="flex flex-col items-center gap-4">
      {/* Visualisation de l'onde sonore */}
      {audioTrack && (
        <BarVisualizer
          trackRef={audioTrack}
          state={state}
          className="h-20 w-full"
        />
      )}

      {/* État de l'agent */}
      <div className="text-electric-blue text-lg font-medium">
        {stateLabel}
      </div>

      {/* Badge type d'agent */}
      <div className="text-sm text-gray-400">
        {agentType === 'arena' && '⚔️ Simulation ARENA'}
        {agentType === 'brain' && '🧠 Professor AI'}
        {agentType === 'chronicle' && '🤝 CHRONICLE'}
      </div>

      {/* Bouton raccrocher */}
      <button
        className="px-4 py-2 rounded-full bg-red-600 text-white"
        onClick={() => window.location.reload()}
      >
        Terminer
      </button>
    </div>
  );
};
```

### 5.3 Génération de Token LiveKit (côté serveur)

```typescript
// backend_ts/src/voice/token-generator.ts

import { AccessToken } from 'livekit-server-sdk';

export async function generateVoiceToken(
  userId: string,
  agentType: 'arena' | 'brain' | 'chronicle' | 'cosmos',
  roomName?: string,
): Promise<{ token: string; url: string }> {
  const room = roomName || `scy-${agentType}-${userId}-${Date.now()}`;

  const at = new AccessToken(
    process.env.LIVEKIT_API_KEY!,
    process.env.LIVEKIT_API_SECRET!,
    {
      identity: userId,
      metadata: JSON.stringify({ agentType, userId }),
    }
  );

  at.addGrant({
    room,
    roomJoin: true,
    canPublish: true,
    canSubscribe: true,
    // L'utilisateur peut publier son audio (micro)
    // mais pas le vidéo
  });

  return {
    token: at.toJwt(),
    url: process.env.LIVEKIT_URL!,
  };
}
```

---

## 6. Détection de Tour & Interruptions

### Les 3 modes de Turn Detection LiveKit

| Mode | Comment | Latence | Utilisé pour |
|------|---------|---------|-------------|
| **Server VAD** | OpenAI détecte la fin de parole côté serveur | ~500ms | ARENA (temps réel), CHRONICLE |
| **Adaptive** | LiveKit Cloud ML distingue vraie interruption vs "hmm" backchanneling | ~300ms | ARENA (anti-faux-interruptions) |
| **Multilingual Model** | Modèle ONNX local multilingue (CPU, <500MB RAM) | ~400ms | BRAIN (multilingue), COSMOS |

### Configuration recommandée par agent

```python
# ARENA : temps réel, interruptions autorisées
turn_detection=TurnDetection(
    type="server_vad",
    threshold=0.5,
    silence_duration_ms=500,    # 500ms de silence = fin de tour
    interrupt_response=True,     # L'utilisateur peut couper la parole
)

# BRAIN : plus patient (Q&R pédagogique)
turn_handling=TurnHandlingOptions(
    endpointing={
        "min_delay": 1.0,      # Attend 1s avant de répondre
        "max_delay": 3.0,      # Max 3s
    },
    interruption={
        "mode": "adaptive",     # Distingue vraie coupure vs "hmm"
    },
)

# CHRONICLE : encore plus patient (conversation décontractée)
turn_detection=TurnDetection(
    type="server_vad",
    silence_duration_ms=800,     # Plus patient
    interrupt_response=False,    # Ne pas couper CHRONICLE
)
```

---

## 7. Noise Cancellation & Echo

```python
# BVC (Background Voice Cancellation) — Krisp intégré LiveKit Cloud
room_input_options=RoomInputOptions(
    noise_cancellation=noise_cancellation.BVC(),  # Desktop/mobile
    # Pour téléphonie SIP :
    # noise_cancellation=noise_cancellation.BVCTelephony(),
)
```

**Sans BVC** : l'agent entend son propre echo → feedback loop → interruption involontaire.
**Avec BVC** : l'echo est éliminé, l'agent entend uniquement l'utilisateur.

---

## 8. Déploiement Docker

```yaml
# docker/docker-compose.yml (ajout sidecar LiveKit)

services:
  # ... sidecars existants ...

  livekit-server:
    image: livekit/livekit-server:latest
    ports:
      - "7880:7880"    # TCP (WebRTC)
      - "7881:7881"    # TCP (WebRTC TLS)
      - "7882:7882/udp" # UDP (WebRTC media)
    volumes:
      - ./livekit/config.yaml:/etc/livekit.yaml
    # Pour production : LiveKit Cloud (pas self-hosted)

  voice-agent-worker:
    build:
      context: ./backend_ts
      dockerfile: voice.Dockerfile
    environment:
      - LIVEKIT_URL=wss://livekit-server:7881
      - LIVEKIT_API_KEY=${LIVEKIT_API_KEY}
      - LIVEKIT_API_SECRET=${LIVEKIT_API_SECRET}
      - OPENAI_API_KEY=${OPENAI_API_KEY}
    depends_on:
      - livekit-server
```

### Configuration LiveKit (`livekit/config.yaml`)

```yaml
port: 7880
bind_addresses:
  - "0.0.0.0"

rtc:
  tcp_port: 7881
  port_range_start: 50000
  port_range_end: 60000
  use_external_ip: true

turn:
  enabled: true
  domain: turn.scyforge.app
  tls_port: 5349
  udp_port: 3478

# Pour production : utiliser LiveKit Cloud (gratuit jusqu'à 50 users simultanés)
```

---

## 9. Coûts

| Service | Free tier | Usage SCY Forge | Coût estimé |
|---------|-----------|----------------|-------------|
| **LiveKit Cloud** | 50 participants simultanés, 10K min/mois | Sessions vocales | $0 (Free tier) |
| **OpenAI Realtime API** | Payant | ARENA (roleplay), CHRONICLE | ~$0.06/min (Premium users) |
| **AssemblyAI STT** | 5h gratuites/mois | BRAIN (cascade) | ~$0.012/min |
| **Cartesia TTS** | 100K caractères/mois | BRAIN TTS | ~$0.005/1K chars |
| **Silero VAD** | Open-source (MIT) | Tous les agents (local) | $0 |
| **LiveKit Turn Detector** | Open-source (ONNX, CPU) | BRAIN, COSMOS | $0 |

> **Optimisation** : pour les utilisateurs Free tier, utiliser la cascade (DeepSeek V4 + Silero VAD + TTS local) = ~$0.001/min.
> Pour Premium : Realtime API = meilleure qualité.

---

## 10. Dépendances LiveKit à Ajouter au Manifeste

### NPM (frontend)
```bash
pnpm add @livekit/components-react livekit-client livekit-server-sdk
```

### Python (voice agent worker)
```bash
pip install livekit-agents livekit-plugins-openai livekit-plugins-silero
pip install livekit-plugins-assemblyai livekit-plugins-cartesia
pip install livekit-plugins-noise-cancellation livekit-plugins-turn-detector
```

### Docker
- `livekit/livekit-server:latest` (self-hosted) OU LiveKit Cloud (SaaS)

---

## 11. Requirements (RFC 2119)

### Voice Infrastructure
- Le système SHALL utiliser LiveKit comme infrastructure WebRTC pour toutes les sessions vocales.
- Le système SHALL créer une room LiveKit par session vocale (ARENA, BRAIN, CHRONICLE).
- Le système SHALL générer un token LiveKit côté serveur (jamais côté client).

### ARENA Vocal
- Le système SHALL utiliser l'Architecture A (Realtime complet) pour ARENA.
- Le système SHALL permettre les interruptions (`interrupt_response=True`).
- Le système SHALL activer le BVC (noise cancellation).

### BRAIN Vocal
- Le système SHALL utiliser l'Architecture B (Cascade STT+LLM+TTS) pour BRAIN.
- Le système SHALL injecter le contexte RAG SCY-BRAIN avant la génération LLM.
- Le système SHALL appliquer la Charte d'Humilité sur toutes les réponses vocales.
- Le système SHALL utiliser le Multilingual Turn Detector.

### CHRONICLE Vocal
- Le système SHALL utiliser l'Architecture A (Realtime, voix courte).
- Le système SHALL NE PAS autoriser les interruptions de CHRONICLE (il parle, puis écoute).
- Le Daily Pulse vocal SHALL être < 30 secondes.

### COSMOS & DAG Vocal
- Le système SHALL router les commandes vocales vers CosmosAgentAPI.
- Le système SHALL basculer automatiquement le mode COSMOS selon la commande.

### Frontend
- Le système SHALL utiliser `@livekit/components-react` pour l'UI vocale.
- Le BarVisualizer SHALL afficher l'état (listening/thinking/speaking).

---

## 12. Test cases

- **TC1 (ARENA vocal)** : Utilisateur parle → persona IA répond vocalement < 1s → interruption fonctionne.
- **TC2 (BRAIN vocal)** : « Explique-moi useEffect » → RAG injecté → réponse humble 2 para + question socratique.
- **TC3 (CHRONICLE vocal)** : Daily Pulse < 30s → sobre, humble, CTA « 2 min ? ».
- **TC4 (COSMOS vocal)** : « Montre-moi mes lacunes » → COSMOS bascule Radar M14 automatiquement.
- **TC5 (DAG vocal)** : « Où j'en suis ? » → Roadmap M04 affichée + CHRONICLE répond progression.
- **TC6 (Interruption)** : Utilisateur coupe ARENA → l'IA stoppe immédiatement (< 100ms).
- **TC7 (Echo)** : Pas de feedback loop (BVC actif).
- **TC8 (Multilingue)** : BRAIN détecte la fin de tour en français (Multilingual Model).
