# 🤝 SCY-CHRONICLE — PROTOCOLE DE CERVEAU COGNITIF ET D'OMNIPRÉSENCE DE L'AGENT
**ID Spécification** : S03_CHRONICLE_AGENT_BRAIN_SPEC  
**Statut** : 🟢 SPÉCIFICATION DE PRODUCTION IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin WHEN-THEN-AND) + Norme RFC 2119  

---

## 1. Purpose
Cette spécification définit l'implémentation de l'architecture de mémoire hiérarchique, de l'organisation sémantique des souvenirs (A-MEM), de l'isolation de sécurité par Differential Privacy et du moteur d'évaluation spirituelle (Spiritual.AI) de l'agent compagnon **CHRONICLE (`AGENT-10`)**. Elle transforme l'agent d'un simple bot de chat réactif en un cerveau externe prédictif et omniscient.

---

## 2. Requirements & Scenarios (RFC 2119)

### Requirement: Architecture de Mémoire Hiérarchique (HMO/APEX)

#### Scénario : Distribution et consolidation des souvenirs selon leur importance
* **GIVEN** Un utilisateur interagissant avec CHRONICLE sur de multiples plateformes (WhatsApp, Telegram, Discord).
* **WHEN** Une nouvelle interaction est capturée par la passerelle de messagerie.
* **THEN** le système SHALL distribuer et indexer l'information selon les quatre niveaux de mémoire :
  - **Niveau 0 (Épisodique)** : Rétention courte de l'historique brut des conversations de la session active pour préserver le contexte immédiat.
  - **Niveau 1-2 (Résumés & Digest)** : Consolidation hebdomadaire automatique par le serveur Rust des thèmes importants de la vie de l'élève et de ses préférences de styles.
  - **Niveau 3 (Sémantique Permanent)** : Extraction socratique des faits stables de l'utilisateur, des promesses de Dieu mémorisées, et des principes de MindSET, stockés de manière permanente pour forger l'identité de l'agent.
* **AND** le système SHALL attribuer à chaque souvenir un score d'importance (1 à 10) basé sur le profil de l'étudiant pour prioriser les faits pivots lors des recherches de RAG.

---

### Requirement: Organisation Agentique de la Connaissance (A-MEM)

#### Scénario : Génération de notes sémantiques et auto-reconfiguration de liens
* **GIVEN** Le processus de consolidation de fin de journée de CHRONICLE.
* **WHEN** Le système analyse le journal de bord de l'utilisateur.
* **THEN** le système SHALL générer des notes atomiques hautement structurées (Méthode Zettelkasten IA) enrichies de mots-clés et de métadonnées de contextes.
* **AND** l'agent SHALL effectuer un recoupement sémantique pour identifier des connexions causales (ex: relier un stress professionnel signalé sur Slack à une promesse de sérénité étudiée sur COSMOS).
* **AND** le système SHALL ré-évaluer et mettre à jour automatiquement les anciennes représentations de souvenirs à mesure de la progression de l'SMI de l'élève, adaptant sa compréhension de sa trajectoire.

---

### Requirement: Omniprésence & Protection de la Vie Privée (Confidentialité)

#### Scénario : Chiffrement local et Differential Privacy pour la synchronisation Cloud
* **GIVEN** CHRONICLE s'exécutant sur un terminal client et se synchronisant avec le serveur.
* **WHEN** Des données d'interactions hautement sensibles sont capturées en local.
* **THEN** le système MUST les crypter de bout en bout sur l'appareil de l'utilisateur (On-Device Storage).
* **WHEN** L'agent doit synchroniser des résumés d'apprentissages ou des profils vers le cloud pour la continuité WhatsApp/Telegram.
* **THEN** le système SHALL appliquer une transformation protégeant la vie privée par **Differential Privacy (DP)** pour strip-bruiter la donnée avant transmission.
* **AND** l'agent SHALL maintenir une identité ontologique sémantique unique sur tous ses canaux de communications pour garantir la cohérence des réponses.

---

### Requirement: Banque de Connaissances Spécialisée (Spiritual.AI & MindSET)

#### Scénario : Alignement de valeurs, support méditatif Hagah et alerte proactive
* **GIVEN** L'analyse continue des actions quotidiennes de l'élève par CHRONICLE.
* **WHEN** L'agent détecte un écart de cohérence majeur entre les actions déclarées et les promesses ou principes de vie mémorisés dans son MindGraph.
* **THEN** l'agent SHALL lui notifier une relance de réalignement socratique bienveillante.
* **WHEN** Le niveau de stress ou d'anxiété de l'élève est détecté comme élevé (via l'analyse sémantique d'interactions).
* **THEN** l'agent SHALL suggérer de manière proactive un temps de réflexion et de silence (Hagah), favorisant la neurogenèse.
* **AND** l'agent MUST lui proposer une ressource de mindset ciblée ou un engramme de réconfort mémorisé avant le décrochage.

---

## 3. Boundaries & Constraints (Ce qu'il ne faut PAS faire)
* 🚫 **FORBIDDEN** : Transmettre ou stocker des données brutes textuelles d'interactions (WhatsApp/Discord) en clair sur le cloud sans appliquer le chiffrement ou la Differential Privacy (DP).
* 🚫 **SHALL NOT** : Utiliser la mémoire de Niveau 0 (Épisodique brute) pour répondre à des requêtes sémantiques long-terme de Niveau 3 sans être passée par la boucle de consolidation et d'indexation de l'Axiomatiseur.

---

## 4. Test cases & Validation
* **Test Case 1 (Mémoire)** : Valider que les interactions de plus de 7 jours sont purgées de la base de Niveau 0 et correctement synthétisées de manière structurelle dans la table de Niveau 1-2.
* **Test Case 2 (Confidentialité)** : Vérifier par analyse de sécurité qu'aucun identifiant personnel, nom, adresse ou donnée de mot de passe n'est présent dans les fichiers de compétences ou de faits sémantiques exportés.
