# Spécification — Artizyn

**Version :** 1.1
**Statut :** brouillon — à valider et signer
**Établi le :** {{date}}
**Signé par :** ________________________ (nom, fonction) le ____________

---

# Partie A — Couche client

*Cette partie décrit ce qui sera construit, en langage courant. Elle constitue l'engagement contractuel. Merci de la lire intégralement : en la signant, vous confirmez qu'elle décrit bien le produit attendu, que les exclusions sont comprises et que les hypothèses listées sont acceptées.*

---

## 1. Objet

Artizyn est une place de marché régionale qui met en relation les professionnels du bâtiment et des travaux publics de la région Provence-Alpes-Côte d'Azur avec les particuliers ayant besoin de leurs services.

La plateforme fonctionne dans les deux sens. Un client publie gratuitement une demande de travaux et la reçoivent automatiquement tous les artisans dont le métier et la zone d'intervention correspondent. Un artisan publie ses prestations disponibles, que les clients consultent et filtrent librement.

Les artisans paient un abonnement mensuel. Les clients ne paient rien, ni à l'inscription, ni à la mise en relation, ni à la fin des travaux. Artizyn ne prélève aucune commission et n'intervient à aucun moment dans le règlement entre le client et l'artisan.

---

## 2. Périmètre inclus

1. Inscription et authentification pour trois types d'utilisateurs : artisan, client, syndic
2. Profil artisan : raison sociale, présentation, photos de réalisations, métiers, ville, rayon d'intervention, certifications déclarées
3. Abonnement mensuel par carte bancaire, en trois formules : 35 €, 80 €, 100 €
4. Publication gratuite et illimitée de demandes de travaux par les clients
5. Mise en relation automatique : tout artisan dont le métier correspond et dont le rayon couvre le lieu du chantier reçoit la demande, avec possibilité pour le client de désigner un métier secondaire
6. Information immédiate du client lorsqu'aucun artisan ne couvre sa demande, et diffusion différée dès qu'un artisan correspondant s'inscrit
7. Réponse de l'artisan à une demande reçue, sous forme de message accompagné d'une estimation de prix
8. Modification et annulation d'une demande par le client, à tout moment
9. Publication de prestations par l'artisan, consultables et filtrables par les clients
10. Recherche et filtrage des artisans et des prestations par métier, ville, prix et note
11. Messagerie interne entre client et artisan, avec pièces jointes
12. Sélection par le client de l'artisan retenu
13. Clôture du chantier par l'artisan, avec clôture automatique à défaut
14. Avis client noté de 1 à 5 après clôture, avec droit de réponse de l'artisan
15. Calendrier de disponibilité interne, accessible à toutes les formules
16. Comptes collaborateurs rattachés au compte artisan, selon la formule
17. Export PDF des devis et factures, à partir de la formule à 80 €
18. Mise en avant dans les résultats de recherche selon la formule
19. Tableau de bord artisan : demandes reçues, propositions envoyées, prestations, avis, abonnement
20. Tableau de bord administrateur : statistiques, modération, suspension de comptes
21. Interface, e-mails et contenus intégralement en français
22. Affichage adapté aux téléphones et tablettes
23. Référencement de base : `robots.txt` et plan de site

---

## 3. Périmètre explicitement exclu

Les éléments suivants ne sont pas compris. Leur ajout ultérieur fera l'objet d'une demande de modification chiffrée.

1. Application mobile native iOS ou Android — le site est adapté au mobile mais n'est pas une application téléchargeable
2. Paiement des travaux via la plateforme, séquestre, ou tout flux financier entre client et artisan
3. Prélèvement d'une commission sur les chantiers réalisés
4. Notifications en temps réel dans le navigateur ou notifications push
5. Appels vidéo ou visioconférence
6. Mise en avant payante à l'unité, en dehors des formules d'abonnement
7. Vérification par Artizyn des certifications, qualifications RGE, assurances décennales ou numéros SIRET déclarés par les artisans — ces informations sont déclaratives
8. Rédaction des mentions légales, CGU, CGV et politique de confidentialité — ces textes sont fournis par le client
9. Facturation automatique entre artisan et client, ou édition de devis au format légal
10. Synchronisation avec Google Agenda ou tout agenda externe — reportée en version ultérieure
11. Traduction du site dans une autre langue que le français
12. Import de données depuis un système existant
13. Prestations humaines associées à la formule à 100 € — session mensuelle de stratégie, support téléphonique, accompagnement dédié — assurées par Artizyn et non par la plateforme
14. Gestion multi-bâtiments ou portefeuille de biens pour les syndics
15. Procédure formelle de contestation d'un avis — seule la suppression manuelle par l'administrateur est prévue
16. Vérification d'identité des clients

---

## 4. Rôles utilisateurs

| Rôle | Peut faire | Ne peut pas faire |
|---|---|---|
| **Artisan (titulaire du compte)** | Créer et modifier son profil ; choisir ses métiers dans la limite de sa formule ; définir sa ville et son rayon dans la limite de sa formule ; charger des photos ; recevoir les demandes correspondantes et y répondre ; publier des prestations ; renseigner ses disponibilités ; échanger par messagerie ; marquer un chantier terminé ; répondre à un avis ; inviter et retirer des collaborateurs ; gérer et résilier son abonnement | Dépasser les limites de sa formule ; modifier ou supprimer un avis reçu ; accéder aux coordonnées d'un client avant d'avoir été sélectionné ; publier plus de prestations que sa formule ne l'autorise |
| **Collaborateur** | Consulter les demandes reçues ; y répondre ; échanger par messagerie ; consulter et modifier les prestations ; renseigner les disponibilités ; consulter les avis | Gérer l'abonnement ; changer de formule ; résilier ; inviter ou retirer d'autres collaborateurs ; répondre à un avis |
| **Client** | Publier gratuitement des demandes ; les modifier ou les annuler à tout moment ; consulter les artisans et les prestations ; filtrer les résultats ; échanger par messagerie ; sélectionner l'artisan retenu ; déposer un avis après clôture | Déposer un avis sans avoir sélectionné d'artisan ; déposer plus d'un avis par chantier ; modifier ou supprimer un avis publié ; accéder aux coordonnées d'un artisan avant sélection |
| **Syndic** | Tout ce qu'un client peut faire, avec une raison sociale et un numéro SIRET affichés sur son profil | Gérer plusieurs bâtiments séparément ; accéder à des fonctions réservées |
| **Administrateur** | Consulter les statistiques ; suspendre ou réactiver un compte artisan ; supprimer un avis ; consulter les demandes de support | Modifier un profil artisan ; intervenir dans une conversation ; modifier un abonnement en cours |

---

## 5. Formules d'abonnement

| | **35 € / mois** | **80 € / mois** | **100 € / mois** |
|---|---|---|---|
| Photos de réalisations | 3 | Illimité | Illimité |
| Métiers | 1 | 3 | 10 |
| Rayon d'intervention maximal | 25 km | 50 km | 100 km |
| Réception des demandes correspondantes | Oui | Oui | Oui |
| Réponse aux demandes | Oui | Oui | Oui |
| Prestations publiées | 1 | 5 | Illimité |
| Messagerie | Oui | Oui | Oui |
| Avis clients | Oui | Oui | Oui |
| Calendrier de disponibilité | Oui | Oui | Oui |
| Collaborateurs | — | 2 | 10 |
| Badges (RGE, assurance, certifications) | — | Oui | Oui |
| Export PDF devis et factures | — | Oui | Oui |
| Mise en avant | — | Positions 1 à 3 des résultats | Bandeau dédié au-dessus des résultats |
| Tableau de bord | Simple | Avancé | Avancé |
| Page entreprise dédiée | — | — | Oui |
| Support | E-mail | E-mail et messagerie | Téléphone et VIP |

*Le rayon d'intervention est plafonné par formule. Un artisan peut définir un rayon inférieur au plafond de sa formule, jamais supérieur.*

---

## 6. Parcours principaux

### 6.1 — Un client publie une demande et choisit un artisan

1. Le client crée un compte gratuitement
2. Il publie une demande : métier concerné, description, budget indicatif, ville, code postal, photos éventuelles
3. La demande parvient automatiquement à tous les artisans ayant sélectionné ce métier et dont le rayon d'intervention couvre le code postal du chantier
4. Chaque artisan concerné reçoit un e-mail et voit la demande dans son tableau de bord
5. Les artisans intéressés répondent par un message accompagné d'une estimation de prix
6. Le client consulte les profils, les avis et les propositions reçues, et échange par messagerie
7. Il sélectionne l'artisan retenu ; les coordonnées des deux parties sont alors mutuellement accessibles
8. La demande passe au statut « en cours » et n'accepte plus de nouvelles réponses
9. Les travaux et le règlement se déroulent hors plateforme
10. L'artisan indique que le chantier est terminé ; à défaut, la demande se clôture automatiquement au bout de 14 jours
11. Le client est invité par e-mail à déposer un avis, avec un rappel après 7 jours
12. Il dépose une note de 1 à 5 et un commentaire, visibles sur la fiche publique de l'artisan
13. L'artisan peut publier une réponse unique sous cet avis

### 6.2 — Un artisan s'inscrit et reçoit des demandes

1. L'artisan crée un compte et renseigne son profil
2. Il choisit une formule et règle par carte bancaire ; son abonnement devient actif immédiatement
3. Il sélectionne ses métiers, dans la limite de sa formule
4. Il indique sa ville et son rayon d'intervention, dans la limite de sa formule
5. Il charge des photos de ses réalisations, dans la limite de sa formule
6. Il renseigne ses disponibilités dans le calendrier interne
7. Les demandes correspondantes lui parviennent par e-mail et apparaissent dans son tableau de bord
8. Il répond à celles qui l'intéressent
9. Il échange avec le client par messagerie
10. S'il est sélectionné, le chantier apparaît comme en cours dans son tableau de bord

### 6.3 — Un artisan publie une prestation et un client le contacte

1. L'artisan publie une prestation : métier, intitulé, description, fourchette de prix, délai indicatif, ville, jusqu'à 5 photos
2. La prestation apparaît dans la liste publique, consultable par tous
3. Un client la trouve par recherche ou filtrage
4. Il consulte la fiche de l'artisan, ses réalisations et ses avis
5. Il le contacte par messagerie
6. L'échange se poursuit ; si un chantier en découle, il est traité hors du circuit des demandes

### 6.4 — Un artisan invite un collaborateur

1. L'artisan, en formule à 80 € ou 100 €, invite un collaborateur par e-mail
2. Le collaborateur crée son mot de passe et accède au compte de l'entreprise
3. Il consulte les demandes, y répond et échange par messagerie sous l'identité de l'entreprise
4. Il n'a accès ni à l'abonnement, ni à la facturation, ni à la gestion des autres collaborateurs
5. L'artisan titulaire peut retirer un collaborateur à tout moment

---

## 7. Critères d'acceptation

*Chaque ligne est vérifiable par observation directe. C'est la liste sur laquelle la recette sera prononcée.*

### Comptes et abonnements

| ID | Exigence | Comment vous le vérifiez |
|---|---|---|
| AC-01 | Création de compte client | Quand je m'inscris comme client avec un e-mail et un mot de passe, je dois recevoir un e-mail de confirmation et pouvoir me connecter |
| AC-02 | Création de compte artisan | Quand je m'inscris comme artisan, je dois être conduit au choix d'une formule avant d'accéder à mon tableau de bord |
| AC-03 | Souscription d'un abonnement | Quand je choisis une formule et que je règle par carte, je dois voir mon abonnement actif et sa date de renouvellement dans mon espace |
| AC-04 | Changement de formule | Quand je change de formule depuis mon espace, je dois voir la nouvelle formule et la date de prise d'effet |
| AC-05 | Résiliation | Quand je résilie mon abonnement, je dois voir la date jusqu'à laquelle mon compte reste actif |
| AC-06 | Échec de paiement | Quand mon paiement échoue, ma fiche ne doit plus apparaître dans les résultats de recherche, tandis que mon compte et mon historique restent accessibles |

### Profil artisan et limites de formule

| ID | Exigence | Comment vous le vérifiez |
|---|---|---|
| AC-07 | Profil artisan | Quand je renseigne ma raison sociale, ma présentation, ma ville et mon rayon, je dois voir ces informations sur ma fiche publique |
| AC-08 | Limite de métiers | Quand je suis en formule à 35 € et que j'ai déjà un métier sélectionné, je ne dois pas pouvoir en ajouter un second, et un message doit m'indiquer la formule requise |
| AC-09 | Limite de photos | Quand je suis en formule à 35 € et que j'ai chargé 3 photos, je ne dois pas pouvoir en ajouter une quatrième |
| AC-10 | Plafond de rayon | Quand je suis en formule à 35 €, je ne dois pas pouvoir enregistrer un rayon supérieur à 25 km ; en formule à 80 €, supérieur à 50 km ; en formule à 100 €, supérieur à 100 km |
| AC-11 | Badges | Quand je suis en formule à 80 € ou 100 € et que je déclare une qualification RGE, elle doit apparaître comme badge sur ma fiche |
| AC-12 | Calendrier de disponibilité | Quand je marque une période comme indisponible, elle doit apparaître comme telle sur ma fiche publique, quelle que soit ma formule |

### Demandes et mise en relation

| ID | Exigence | Comment vous le vérifiez |
|---|---|---|
| AC-13 | Publication d'une demande | Quand je publie une demande avec un métier, une description, un budget et un code postal, je dois la voir dans « Mes demandes » au statut « ouverte » |
| AC-14 | Règle de mise en relation | Quand je publie une demande de plomberie à Aix-en-Provence, tous les artisans ayant sélectionné « Plomberie » et dont le rayon couvre Aix doivent la recevoir — et aucun autre artisan |
| AC-14b | Métier secondaire facultatif | Quand je publie une demande et que j'indique un métier secondaire, les artisans ayant sélectionné l'un ou l'autre des deux métiers doivent la recevoir |
| AC-14c | Aucun artisan correspondant | Quand aucun artisan ne correspond à ma demande, je dois en être informé immédiatement après publication, avec l'indication que je serai averti si un artisan couvrant cette zone et ce métier s'inscrit |
| AC-14d | Notification différée en cas de couverture nouvelle | Quand un artisan s'inscrit et correspond à une demande ouverte restée sans destinataire, le client doit en être averti par e-mail et l'artisan doit recevoir la demande |
| AC-15 | Absence de limite de diffusion | Quand ma demande correspond au profil de trente artisans, les trente doivent la recevoir |
| AC-16 | Alerte artisan | Quand une demande correspond à mon métier et à ma zone, je dois recevoir un e-mail et la voir dans mon tableau de bord |
| AC-17 | Informations visibles avant sélection | Quand je consulte une demande reçue, je dois voir le prénom du client, la ville, le code postal, le métier, le budget, la description et les photos — et ni le nom de famille, ni l'adresse précise, ni le téléphone, ni l'e-mail |
| AC-18 | Nombre d'artisans destinataires — côté client | Quand je consulte ma demande, je dois voir combien d'artisans l'ont reçue |
| AC-18b | Nombre d'artisans destinataires — côté artisan | Quand je consulte une demande reçue, je dois voir combien d'autres artisans l'ont également reçue et combien y ont déjà répondu |
| AC-18c | Regroupement des alertes quotidiennes | Quand plusieurs demandes me parviennent le même jour, je dois recevoir un seul e-mail récapitulatif et non un e-mail par demande |
| AC-19 | Réponse à une demande | Quand je réponds à une demande par un message et une estimation de prix, le client doit voir ma proposition et pouvoir me répondre |
| AC-20 | Modification d'une demande | Quand je modifie ma demande après avoir reçu des réponses, elle doit porter la mention « modifiée le [date] » et chaque artisan ayant répondu doit en être informé par e-mail |
| AC-21 | Annulation d'une demande | Quand j'annule ma demande, elle doit disparaître du tableau de bord de tous les artisans concernés |

### Sélection, clôture et avis

| ID | Exigence | Comment vous le vérifiez |
|---|---|---|
| AC-22 | Sélection d'un artisan | Quand je sélectionne un artisan, la demande doit passer au statut « en cours » et n'accepter aucune nouvelle réponse |
| AC-23 | Ouverture des coordonnées | Quand j'ai été sélectionné, je dois voir le nom complet, le téléphone et l'adresse du client — et lui les miens |
| AC-24 | Clôture par l'artisan | Quand je marque le chantier terminé, la demande doit passer au statut « terminée » et le client doit recevoir un e-mail l'invitant à déposer un avis |
| AC-25 | Clôture automatique | Quand un chantier reste au statut « en cours » pendant 14 jours sans action, il doit se clôturer automatiquement et ouvrir le dépôt d'avis |
| AC-26 | Rappel d'avis | Quand je n'ai pas déposé d'avis 7 jours après la clôture, je dois recevoir un rappel unique par e-mail |
| AC-27 | Dépôt d'un avis | Quand je dépose un avis sur un chantier terminé, il doit apparaître sur la fiche publique de l'artisan avec la note, le commentaire et la date |
| AC-28 | Avis réservé à l'artisan retenu | Quand je n'ai pas été sélectionné sur un chantier, aucun avis me concernant ne doit pouvoir y être déposé |
| AC-29 | Unicité de l'avis | Quand j'ai déjà déposé un avis sur un chantier, je ne dois pas pouvoir en déposer un second |
| AC-30 | Droit de réponse | Quand je reçois un avis, je dois pouvoir publier une réponse unique, affichée sous cet avis sur ma fiche |
| AC-31 | Note moyenne | Quand un artisan a reçu plusieurs avis, sa fiche doit afficher la moyenne des notes et le nombre d'avis, cette même valeur apparaissant à l'identique partout où elle est affichée |

### Prestations

| ID | Exigence | Comment vous le vérifiez |
|---|---|---|
| AC-32 | Publication d'une prestation | Quand je publie une prestation avec un métier, un intitulé, une description, une fourchette de prix, un délai et une ville, elle doit apparaître dans la liste publique |
| AC-33 | Limite de prestations | Quand je suis en formule à 35 € et que j'ai déjà une prestation publiée, je ne dois pas pouvoir en publier une seconde, et un message doit m'indiquer la formule requise |
| AC-34 | Photos de prestation | Quand je crée une prestation, je dois pouvoir y joindre jusqu'à 5 photos |
| AC-35 | Consultation des prestations | Quand je consulte les prestations, je dois pouvoir filtrer par métier, ville, fourchette de prix et note de l'artisan |
| AC-36 | Prestations d'un abonnement expiré | Quand l'abonnement d'un artisan expire, ses prestations ne doivent plus apparaître publiquement tout en restant présentes dans son espace |

### Messagerie

| ID | Exigence | Comment vous le vérifiez |
|---|---|---|
| AC-37 | Envoi d'un message | Quand j'envoie un message depuis une demande ou une prestation, mon interlocuteur doit le voir dans sa messagerie avec l'historique complet de l'échange |
| AC-38 | Pièces jointes | Quand je joins une image ou un PDF de moins de 10 Mo, mon interlocuteur doit pouvoir l'ouvrir ; un fichier plus volumineux ou d'un autre format doit être refusé avec un message explicite |

### Collaborateurs

| ID | Exigence | Comment vous le vérifiez |
|---|---|---|
| AC-39 | Invitation d'un collaborateur | Quand je suis en formule à 80 € et que j'invite un collaborateur par e-mail, il doit recevoir une invitation lui permettant de créer son mot de passe |
| AC-40 | Limite de collaborateurs | Quand je suis en formule à 80 € et que j'ai déjà 2 collaborateurs actifs, je ne dois pas pouvoir en inviter un troisième |
| AC-41 | Droits d'un collaborateur | Quand je suis connecté comme collaborateur, je dois pouvoir répondre aux demandes et aux messages, et l'accès à l'abonnement, à la facturation et à la gestion des collaborateurs doit m'être refusé |
| AC-42 | Retrait d'un collaborateur | Quand je retire un collaborateur, il ne doit plus pouvoir se connecter au compte de l'entreprise |

### Recherche et mise en avant

| ID | Exigence | Comment vous le vérifiez |
|---|---|---|
| AC-43 | Recherche d'artisans | Quand je recherche des artisans, je dois pouvoir filtrer par métier, ville et note |
| AC-44 | Mise en avant formule 80 € | Quand je consulte les résultats, les positions 1 à 3 de la liste doivent être occupées par des artisans en formule à 80 € correspondant à ma recherche |
| AC-45 | Mise en avant formule 100 € | Quand je consulte les résultats, un bandeau distinct au-dessus de la liste doit présenter jusqu'à 4 artisans en formule à 100 €, identifié comme mise en avant, ces artisans n'occupant pas les positions 1 à 3 |
| AC-46 | Rotation du bandeau | Quand plus de 4 artisans en formule à 100 € correspondent à ma recherche, le bandeau doit présenter une sélection différente à chaque affichage |

### Tableaux de bord

| ID | Exigence | Comment vous le vérifiez |
|---|---|---|
| AC-47 | Tableau de bord artisan | Quand j'accède à mon tableau de bord, je dois voir le nombre de demandes reçues, de propositions envoyées, de chantiers en cours, d'avis reçus et ma note moyenne |
| AC-48 | Export PDF | Quand je suis en formule à 80 € ou 100 €, je dois pouvoir exporter un devis ou une facture au format PDF |
| AC-49 | Tableau de bord administrateur | Quand j'accède à l'administration, je dois voir le nombre d'artisans par formule, le chiffre d'affaires mensuel, le nombre de demandes publiées et de prestations actives |
| AC-49b | Volume de mises en relation par formule | Quand j'accède à l'administration, je dois voir le nombre moyen et médian de demandes reçues par artisan sur le mois écoulé, ventilé par formule d'abonnement |
| AC-49c | Demandes sans destinataire | Quand j'accède à l'administration, je dois voir la liste des demandes ouvertes n'ayant trouvé aucun artisan, avec leur métier et leur code postal |
| AC-50 | Suspension d'un artisan | Quand je suspends un compte artisan, sa fiche et ses prestations ne doivent plus apparaître dans les résultats de recherche |
| AC-51 | Suppression d'un avis | Quand je supprime un avis depuis l'administration, il doit disparaître de la fiche de l'artisan et la note moyenne doit être recalculée |

### Transverse

| ID | Exigence | Comment vous le vérifiez |
|---|---|---|
| AC-52 | Affichage mobile | Quand je consulte le site sur un téléphone, chaque page doit être lisible et utilisable sans défilement horizontal |
| AC-53 | Langue | Quand je navigue sur le site et que je reçois un e-mail de la plateforme, l'intégralité du contenu doit être en français |
| AC-54 | Référencement de base | Quand je consulte `/robots.txt` et `/sitemap.xml`, je dois obtenir des fichiers valides listant les pages publiques |

---

## 8. Hypothèses

*Chaque ligne correspond à une question restée sans réponse et à la décision prise en conséquence. En signant, vous acceptez ces décisions. Si l'une d'elles ne correspond pas à votre intention, elle doit être discutée avant signature.*

| Hypothèse | Pourquoi nous l'avons retenue | Ce qui change si elle est fausse |
|---|---|---|
| La correspondance des métiers est exacte, sur le métier principal ou sur le métier secondaire facultatif désigné par le client | Le client connaît la nature exacte de ses travaux mieux qu'une table d'affinité que nous devrions arbitrer et maintenir | Une table de proximité automatique entre métiers représente environ 2 jours, plus une décision métier sur chaque association, et produit des mises en relation que l'artisan n'a pas choisies |
| La distance est calculée depuis le code postal et non depuis la commune | Marseille couvre 240 km² et compte seize codes postaux ; une résolution à la commune produirait plusieurs kilomètres d'erreur en bordure de rayon | Une résolution à l'adresse exacte serait plus précise mais suppose que artisans et clients saisissent une adresse complète, ce qu'ils renseignent mal |
| Le trajet est mesuré à vol d'oiseau, sans tenir compte du relief | La région est montagneuse et 40 km peuvent représenter deux heures de route, mais un calcul par temps de trajet réel se facture à l'appel et serait appliqué à chaque publication pour chaque artisan correspondant | Un calcul par temps de trajet représente environ 2 jours et un coût mensuel proportionnel au volume d'activité |
| Les alertes de nouvelles demandes sont regroupées en un récapitulatif quotidien | Un e-mail par demande produit une saturation qui conduit l'artisan à ne plus les ouvrir, y compris pour les demandes qui l'intéressent | Un envoi immédiat par demande est plus réactif mais expose à la saturation, notamment lorsqu'un client republie plusieurs fois la même demande |
| Le rayon est plafonné par formule à 25, 50 et 100 km | Sans plafond, un artisan à 35 € couvre toute la région et la progression entre formules perd sa justification commerciale | Sans plafond, l'argument de montée en gamme s'affaiblit et le volume de mises en relation non pertinentes augmente |
| La distance est calculée à vol d'oiseau entre la commune de l'artisan et le code postal du chantier | Suffisant à l'échelle régionale et sans dépendance externe | Un calcul par temps de trajet réel suppose un service externe payant : environ 2 jours et un coût mensuel récurrent |
| La formule influence uniquement l'ordre d'affichage, jamais la réception d'une demande | Confirmé lors de l'entretien de cadrage | Si la formule filtrait la réception, la valeur de l'abonnement à 35 € s'en trouverait modifiée |
| Un rétrogradage de formule ne supprime rien automatiquement : un artisan passant de 100 € à 35 € conserve ses métiers et ses photos jusqu'à intervention manuelle | Un traitement automatique suppose de choisir ce qui est supprimé, décision qui n'a pas été arbitrée | Un traitement automatique représente environ 2 jours et nécessite une règle explicite de conservation |
| Un avis ne peut être déposé que par le client d'un chantier clôturé, sur le seul artisan qu'il a sélectionné | Sans cette règle, tout client peut noter tout artisan, et la réputation vendue aux abonnés n'est pas protégée | Règle structurante : son absence ouvre le système d'avis à l'abus |
| L'artisan déclare la fin du chantier ; à défaut le chantier se clôture seul au bout de 14 jours | Le client, une fois ses travaux réalisés, revient rarement clôturer lui-même ; sans cette règle la plupart des chantiers resteraient ouverts et sans avis | Une autre règle de clôture modifie le volume d'avis collectés, principal actif de la plateforme |
| Aucune vérification d'identité des clients | Hors périmètre d'un produit de première version | Un compte client fictif permet encore de fabriquer un avis. Une vérification représente plusieurs jours et un coût par contrôle |
| Aucune procédure de contestation d'avis : seule la suppression manuelle par l'administrateur est prévue | Une procédure formelle suppose des règles d'arbitrage à définir | Une procédure de contestation représente environ 2 jours et une charge de traitement continue |
| Les badges RGE, assurance et certifications sont déclaratifs, sans contrôle | Une vérification suppose un contrôle documentaire humain et engage la responsabilité d'Artizyn | Une vérification effective change la nature de la responsabilité de la plateforme et suppose un processus humain permanent |
| Les coordonnées ne sont mutuellement accessibles qu'après sélection de l'artisan par le client | Si les coordonnées étaient visibles dès la publication, la plateforme serait contournée dès la première mise en relation et l'abonnement perdrait sa valeur | Hypothèse commercialement la plus structurante du document |
| Les collaborateurs sont des comptes de connexion distincts, aux droits restreints | Un simple affichage de noms n'aurait pas de valeur d'usage pour une entreprise de dix personnes | S'il s'agissait d'un simple affichage, environ 3 jours seraient économisés |
| Le syndic est un client disposant d'une raison sociale et d'un SIRET, sans fonction supplémentaire ni paiement | Le brief mentionne un paiement optionnel sans contrepartie identifiable | Si le syndic devient une offre payante, son contenu reste à définir et à chiffrer séparément |
| Les seules notifications sont des e-mails : confirmation d'inscription, réinitialisation de mot de passe, reçu de paiement, récapitulatif quotidien des nouvelles demandes correspondantes, modification d'une demande à laquelle on a répondu, absence de destinataire pour une demande publiée, couverture nouvelle d'une demande restée sans destinataire, invitation à déposer un avis et son rappel, invitation d'un collaborateur | Sans alerte sur les nouvelles demandes, l'artisan n'a pas de raison de revenir sur la plateforme | Un système de notifications en temps réel représente environ 3 jours et concerne tous les domaines |
| Les prix affichés sont exprimés TTC | Les clients sont des particuliers | Un affichage HT sur une offre destinée aux particuliers pose une difficulté d'affichage réglementaire |
| La messagerie accepte images et PDF, dans la limite de 10 Mo par fichier | Les devis circulent au format PDF | Sans pièces jointes, environ 1 jour est économisé mais les échanges se déportent hors plateforme |
| Le chiffre d'affaires affiché en administration est lu depuis Stripe et non recalculé | Une seconde source de vérité sur le chiffre d'affaires produit inévitablement des écarts | Un calcul local suppose une réconciliation permanente avec Stripe |
| Aucune période d'essai sur les abonnements | Le brief n'en mentionne pas | Une période d'essai modifie la configuration de la facturation et la gestion des accès : environ 1 jour |
| Jusqu'à 5 photos par prestation, toutes formules confondues | Le brief ne précise rien sur ce point | Ajustement mineur |
| Le site est en français uniquement, e-mails et pages légales compris | Marché régional français, nom de domaine en `.fr` | Toute autre langue suppose une infrastructure de traduction : environ 3 jours, hors traduction elle-même |
| Le client fournit l'intégralité des textes légaux : CGU, CGV, mentions légales, politique de confidentialité | Ce n'est pas une prestation de développement | Sans ces textes, le site ne peut pas être mis en ligne, quel que soit son état d'avancement |

---

## 9. Décisions en attente

| Décision | Options | À décider avant | Responsable |
|---|---|---|---|
| Emplacement précis du bandeau de mise en avant de la formule à 100 € | Bandeau horizontal au-dessus des résultats / colonne latérale / carrousel | Phase 4 — rédaction des tests | Client |
| Règle de rotation du bandeau lorsque plus de 4 artisans en formule à 100 € correspondent | Rotation à chaque affichage / par ancienneté d'abonnement / par note | Phase 4 | Client |
| Report de la synchronisation Google Agenda en version ultérieure, remplacée par un calendrier interne | Confirmer le report / réintégrer au périmètre (environ 2 à 4 jours) | Signature | Client |
| Calendrier de disponibilité ouvert à toutes les formules, alors que le brief le réservait à la formule à 80 € | Confirmer l'ouverture / le réserver à la formule à 80 € | Signature | Client |
| Mécanisme de lancement : offre promotionnelle ou gratuité initiale pour les premiers artisans | À définir — sans amorçage, la place de marché est vide au lancement | Signature | Client |
| Contenu détaillé du tableau de bord administrateur au-delà des statistiques citées | À préciser | Phase 5 | Client |
| Durée de la garantie après recette | 30 / 60 / 90 jours | Signature | Prestataire |
| Signataire du présent document | — | Signature | Client |

---

# Partie B — Couche technique

*Cette partie s'adresse à l'équipe de développement. Elle ne fait pas partie de ce que le client valide, mais elle est produite à partir de la Partie A et ne doit rien contenir qui ne s'y rattache.*

---

## 10. Entités de données

### `users`
Géré par Supabase Auth.
**Champs :** `id`, `email`, `encrypted_password`, `email_confirmed_at`, `created_at`
**Cycle de vie :** créé à l'inscription. Jamais supprimé — la désactivation passe par `profiles.status`.

### `profiles`
**Champs :** `id` (FK `users`), `user_type` (`artisan` | `collaborator` | `client` | `syndic` | `admin`), `first_name`, `last_name`, `phone`, `city`, `postal_code`, `region`, `status` (`active` | `suspended`), `created_at`, `updated_at`
**Relations :** 1–1 avec `users`. 1–1 avec `artisans`, `clients` ou `syndics` selon `user_type`.
**Cycle de vie :** créé après confirmation de l'e-mail. `status` passe à `suspended` sur action administrateur (AC-50).

### `artisans`
**Champs :** `id` (FK `profiles`), `company_name`, `siret`, `bio`, `city`, `postal_code`, `latitude`, `longitude`, `service_radius_km`, `subscription_tier` (`t35` | `t80` | `t100`), `subscription_status` (`active` | `past_due` | `cancelled` | `expired`), `stripe_customer_id`, `stripe_subscription_id`, `subscription_current_period_end`, `rating_average`, `rating_count`, `created_at`, `updated_at`
**Relations :** 1–1 avec `profiles`. 1–N vers `artisan_skills`, `artisan_photos`, `offers`, `collaborators`, `availability_blocks`, `reviews`.
**Cycle de vie :** créé à l'inscription artisan. `latitude` et `longitude` géocodés depuis la ville et le code postal à l'enregistrement du profil, puis à chaque modification de l'adresse. `service_radius_km` contraint par le plafond de la formule (AC-10). `rating_average` et `rating_count` recalculés à chaque dépôt ou suppression d'avis — jamais calculés ailleurs (AC-31).

### `skills`
**Champs :** `id`, `name`, `slug`, `display_order`
**Cycle de vie :** table de référence, 19 lignes, alimentée à l'initialisation. Non modifiable par les utilisateurs.

**Valeurs :** Plomberie, Électricité, Maçonnerie, Peinture, Menuiserie, Carrelage, Couverture, Chauffage, Étanchéité, Ravalement de façade, Serrurerie, Vitrerie, Jardinage et paysagisme, Démolition, Nettoyage professionnel, Charpente, Isolation, Traitement et dératisation, Rénovation générale.

### `artisan_skills`
**Champs :** `artisan_id` (FK), `skill_id` (FK), `created_at`
**Clé primaire :** composite (`artisan_id`, `skill_id`)
**Cycle de vie :** nombre de lignes par artisan contraint par la formule — 1, 3 ou 10 (AC-08). Contrainte non rétroactive lors d'un rétrogradage (hypothèse documentée).

### `artisan_photos`
**Champs :** `id`, `artisan_id` (FK), `storage_path`, `display_order`, `created_at`
**Cycle de vie :** nombre limité à 3 en formule à 35 €, illimité au-delà (AC-09).

### `collaborators`
**Champs :** `id`, `artisan_id` (FK), `profile_id` (FK `profiles`, nullable jusqu'à acceptation), `invited_email`, `invitation_token`, `invitation_sent_at`, `accepted_at`, `status` (`invited` | `active` | `removed`), `created_at`
**Cycle de vie :** créé à l'invitation avec `profile_id` nul. À l'acceptation, un `profiles` de type `collaborator` est créé et rattaché. Nombre de lignes `active` limité à 2 ou 10 selon la formule (AC-40). Le passage à `removed` révoque immédiatement l'accès (AC-42).

### `availability_blocks`
**Champs :** `id`, `artisan_id` (FK), `start_date`, `end_date`, `note`, `created_at`
**Cycle de vie :** créé et supprimé librement par l'artisan ou un collaborateur. Toutes formules (AC-12).

### `clients`
**Champs :** `id` (FK `profiles`)

### `syndics`
**Champs :** `id` (FK `profiles`), `company_name`, `siret`

### `projects`
Demande de travaux publiée par un client ou un syndic.
**Champs :** `id`, `author_profile_id` (FK `profiles`), `skill_id` (FK), `secondary_skill_id` (FK `skills`, nullable), `title`, `description`, `budget_min`, `budget_max`, `city`, `postal_code`, `latitude`, `longitude`, `status` (`open` | `in_progress` | `completed` | `cancelled`), `selected_artisan_id` (FK `artisans`, nullable), `selected_at`, `completed_at`, `completed_by` (`artisan` | `auto`), `edited_at`, `zero_match_notified_at`, `created_at`, `updated_at`
**Relations :** 1–N vers `project_artisans`, `proposals`, `project_photos`, `conversations`. 0–1 vers `reviews`.
**Cycle de vie :** créé au statut `open`. Modifiable à tout moment par son auteur — chaque modification met `edited_at` à jour et déclenche une notification aux artisans ayant répondu (AC-20). Passe à `in_progress` à la sélection d'un artisan, ce qui interdit toute nouvelle proposition (AC-22). Passe à `completed` sur déclaration de l'artisan sélectionné, ou automatiquement 14 jours après `selected_at` (AC-24, AC-25). Passe à `cancelled` sur action de l'auteur, à tout moment (AC-21).

### `project_photos`
**Champs :** `id`, `project_id` (FK), `storage_path`, `display_order`, `created_at`

### `project_artisans`
Enregistre la diffusion d'une demande et l'issue de la mise en relation.
**Champs :** `project_id` (FK), `artisan_id` (FK), `matched_at`, `viewed_at`, `notified_at`, `status` (`matched` | `responded` | `selected` | `declined`)
**Clé primaire :** composite (`project_id`, `artisan_id`)
**Cycle de vie :** une ligne créée par artisan correspondant au moment de la publication. `status` passe à `responded` au dépôt d'une proposition, à `selected` pour l'artisan retenu, à `declined` pour les autres à la sélection. Le nombre de lignes alimente le compteur affiché au client (AC-18).

### `proposals`
Réponse d'un artisan à une demande. Distinct de `offers`.
**Champs :** `id`, `project_id` (FK), `artisan_id` (FK), `message`, `price_estimate`, `created_at`, `updated_at`
**Contrainte :** unique sur (`project_id`, `artisan_id`) — une seule proposition par artisan et par demande.
**Cycle de vie :** créé lorsqu'un artisan répond à une demande reçue (AC-19). Refusé si `projects.status` n'est pas `open` (AC-22).

### `offers`
Prestation publiée par un artisan, indépendante de toute demande. Distinct de `proposals`.
**Champs :** `id`, `artisan_id` (FK), `skill_id` (FK), `title`, `description`, `price_min`, `price_max`, `timeline_days`, `city`, `postal_code`, `status` (`active` | `paused`), `created_at`, `updated_at`
**Relations :** 1–N vers `offer_photos`, 1–N vers `conversations`.
**Cycle de vie :** nombre de lignes `active` limité à 1, 5 ou illimité selon la formule (AC-33). Masquées publiquement si l'abonnement de l'artisan n'est plus `active`, sans suppression (AC-36).

### `offer_photos`
**Champs :** `id`, `offer_id` (FK), `storage_path`, `display_order`, `created_at`
**Cycle de vie :** maximum 5 par prestation, toutes formules (AC-34).

### `conversations`
**Champs :** `id`, `artisan_id` (FK), `client_profile_id` (FK `profiles`), `project_id` (FK, nullable), `offer_id` (FK, nullable), `last_message_at`, `created_at`
**Contrainte :** exactement l'un de `project_id` ou `offer_id` est renseigné, l'autre est nul. Contrainte de contrôle au niveau base.
**Cycle de vie :** créée au premier message échangé sur une demande ou sur une prestation.

### `messages`
**Champs :** `id`, `conversation_id` (FK), `sender_profile_id` (FK `profiles`), `content`, `attachment_path`, `attachment_filename`, `attachment_size_bytes`, `read_at`, `created_at`
**Cycle de vie :** pièce jointe limitée à 10 Mo, types image et PDF uniquement (AC-38).

### `reviews`
**Champs :** `id`, `project_id` (FK, unique), `artisan_id` (FK), `client_profile_id` (FK `profiles`), `rating` (1 à 5), `comment`, `artisan_response`, `responded_at`, `created_at`
**Contrainte :** unique sur `project_id` — un seul avis par chantier (AC-29).
**Cycle de vie :** création autorisée uniquement si `projects.status` vaut `completed`, si `client_profile_id` correspond à `projects.author_profile_id`, et si `artisan_id` correspond à `projects.selected_artisan_id` (AC-27, AC-28). Non modifiable ni supprimable par les utilisateurs. `artisan_response` renseignée une seule fois par l'artisan concerné (AC-30). Toute création ou suppression déclenche le recalcul de `artisans.rating_average` et `artisans.rating_count`.

### `support_tickets`
**Champs :** `id`, `profile_id` (FK), `subject`, `body`, `status` (`open` | `closed`), `created_at`, `closed_at`

---

## 11. Règle de mise en relation

Règle unique, appliquée à la publication d'une demande et à aucun autre moment.

Un artisan reçoit une demande si et seulement si l'ensemble des conditions suivantes est vrai :

1. `artisans.subscription_status` vaut `active`
2. `profiles.status` de l'artisan vaut `active`
3. Il existe une ligne dans `artisan_skills` pour (`artisan_id`, `projects.skill_id`) **ou**, si `projects.secondary_skill_id` est renseigné, pour (`artisan_id`, `projects.secondary_skill_id`) — correspondance exacte sur l'un des deux métiers, sans table de proximité entre métiers
4. La distance orthodromique entre (`artisans.latitude`, `artisans.longitude`) et (`projects.latitude`, `projects.longitude`) est inférieure ou égale à `artisans.service_radius_km`

Aucune limite au nombre d'artisans retenus. La formule d'abonnement n'intervient pas dans cette règle (AC-14, AC-14b, AC-15).

**Métier secondaire.** Le client peut désigner un second métier au moment de la publication. Le choix appartient au client, qui connaît la nature exacte des travaux ; la plateforme ne maintient aucune table d'affinité entre métiers, dont la tenue supposerait un arbitrage métier sur chaque association.

**Calcul de distance :** formule de haversine sur les coordonnées stockées. Aucune extension géospatiale requise à cette échelle.

**Géocodage — granularité au code postal.** Les coordonnées de l'artisan et de la demande sont dérivées du **code postal**, et non de la commune. Les communes étendues — Marseille couvre 240 km² et compte seize codes postaux — produiraient une erreur de plusieurs kilomètres en bordure de rayon, dans les deux sens. Un code postal ne se résolvant pas empêche l'enregistrement, avec message explicite.

**Absence de correspondance.** Si aucun artisan ne satisfait les quatre conditions, le client en est informé immédiatement, `zero_match_notified_at` est horodaté, et la demande reste au statut `open`. À chaque inscription d'un nouvel artisan ou modification de son métier ou de son rayon, les demandes ouvertes sans destinataire sont réévaluées : celles désormais couvertes sont diffusées et leur auteur averti (AC-14c, AC-14d).

**Diffusion des alertes.** La création des lignes `project_artisans` est immédiate. L'envoi des e-mails est différé : un récapitulatif quotidien unique par artisan, quel que soit le nombre de demandes reçues dans la journée (AC-18c). L'affichage au tableau de bord reste immédiat.

**Compteurs visibles.** Le nombre de lignes `project_artisans` d'une demande est affiché au client (AC-18) et à chaque artisan destinataire, accompagné du nombre de propositions déjà déposées (AC-18b). L'artisan peut ainsi juger de l'opportunité de répondre.

---

## 12. Règle de classement des résultats

Appliquée à la recherche d'artisans et à la liste des prestations.

**Bandeau supérieur :** jusqu'à 4 artisans de formule `t100` correspondant aux critères, sélectionnés par rotation à chaque affichage. Identifié visuellement comme mise en avant. Ces artisans n'apparaissent pas dans la liste classée (AC-45, AC-46).

**Liste classée :**
- Positions 1 à 3 : artisans de formule `t80` correspondant aux critères, par rotation si plus de trois correspondent (AC-44)
- Positions suivantes : tous les autres artisans correspondants, classés par note moyenne décroissante puis par ancienneté d'inscription

---

## 13. Intégrations

| Système | Sens | Authentification | Comportement en cas d'échec |
|---|---|---|---|
| Stripe — abonnements | Sortant (création de session de paiement) et entrant (webhooks) | Clé secrète côté serveur ; signature vérifiée sur chaque webhook | Échec de création de session : message d'erreur, aucun abonnement créé. Webhook non reçu : réconciliation par tâche planifiée quotidienne comparant `subscription_status` local et état Stripe |
| Supabase Auth | Sortant | Clé de service côté serveur, clé anonyme côté client | Indisponibilité : connexion et inscription impossibles, message explicite. Aucune session existante interrompue |
| Supabase Storage | Sortant | Clé de service | Échec de chargement : message d'erreur, aucune ligne créée en base |
| Service d'envoi d'e-mails | Sortant | Clé d'API | Échec : mise en file d'attente et trois tentatives espacées. Échec définitif journalisé et remonté à l'administration |
| Service de géocodage | Sortant | Clé d'API | Échec : enregistrement du profil ou de la demande refusé avec message explicite. Sans coordonnées, la mise en relation est impossible |
| Sentry | Sortant | DSN | Indisponibilité sans effet sur l'application |

---

## 14. Exigences non fonctionnelles

| Domaine | Cible | Mesure |
|---|---|---|
| Performance — pages publiques | Rendu utile en moins de 2 s sur connexion mobile 4G | Mesure sur les pages liste d'artisans, liste de prestations et fiche artisan |
| Performance — mise en relation | La publication d'une demande aboutit en moins de 3 s, quel que soit le nombre d'artisans correspondants | Test avec 500 artisans en base dont 200 correspondants |
| Disponibilité | 99 % sur une base mensuelle, hors interruptions programmées | Sonde externe toutes les 5 minutes |
| Sécurité — mots de passe | Un export intégral de la base ne permet de retrouver aucun mot de passe utilisable | Revue de sécurité en phase 6 |
| Sécurité — cloisonnement | Un artisan authentifié ne peut accéder à aucune donnée d'un autre artisan, y compris par manipulation directe des identifiants dans les requêtes | Tests de contrôle d'accès sur chaque point d'entrée |
| Sécurité — coordonnées | Les coordonnées d'un client ne sont accessibles à un artisan qu'après sélection, y compris via l'API | Test dédié sur chaque point d'entrée exposant un profil |
| Sécurité — collaborateurs | Un collaborateur authentifié ne peut accéder à aucun point d'entrée de facturation ou de gestion d'abonnement | Tests de contrôle d'accès |
| Sécurité — paiement | Aucune donnée de carte bancaire ne transite par l'application ni n'est stockée | Revue d'architecture : redirection vers l'interface hébergée par Stripe |
| Accessibilité | Contraste et navigation au clavier conformes au niveau AA sur les parcours d'inscription, de publication de demande et de messagerie | Audit automatisé et vérification manuelle |
| Cohérence des valeurs affichées | La note moyenne d'un artisan est identique sur sa fiche, dans les résultats de recherche, sur ses prestations et dans l'administration | Tests transverses en phase 4 |

---

## 15. Contraintes

**Hébergement :** Vercel pour l'application, Supabase pour la base de données, l'authentification et le stockage. Comptes détenus par le client dès le premier jour.

**Conformité :** application soumise au RGPD. Les textes légaux sont fournis par le client. Aucune donnée de santé, aucune donnée bancaire stockée. Aucun flux financier entre client et artisan ne transite par la plateforme.

**Infrastructure client :** nom de domaine en `.fr` détenu par le client. Compte Stripe détenu par le client. Compte Google Analytics détenu par le client.

**Mainteneur après livraison :** le client. Ce point détermine le choix de la pile technique en phase 2 et impose une documentation de reprise complète en phase 7.

**Localisation :** interface, e-mails, messages d'erreur et pages légales en français. Devise en euros. Prix affichés TTC. Format de date `JJ/MM/AAAA`. Fuseau horaire Europe/Paris pour l'ensemble des horodatages affichés.

---

## 16. Sign-off

En signant, le client confirme que la Partie A décrit le produit à construire, que les exclusions du paragraphe 3 sont comprises et acceptées, et que les hypothèses du paragraphe 8 sont acceptées telles qu'énoncées.

Toute demande ne se rattachant pas à un critère d'acceptation de ce document constitue une modification de périmètre, évaluée et chiffrée avant réalisation.

**Nom et fonction :** ______________________________

**Signature :** ______________________________

**Date :** ______________
