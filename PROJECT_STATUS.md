# État du projet (0.1.0)

## Écrit (code présent)
Toutes les sections du cahier des charges ont une première implémentation.

## NON vérifié
- Aucune compilation n'a été exécutée (environnement Linux sans Xcode/Swift). Des erreurs de compilation sont probables : le premier build GitHub Actions les révélera ; envoie-moi `build.log`.
- Aucun test exécuté. Aucune mesure mémoire/CPU/autonomie : le plafond de 100 Mo n'est PAS validé.
- À valider sur iPhone XR : PiP après fermeture de l'écran vidéo, reprise audio après interruption/changement de route, téléchargements en arrière-plan, relancement après fermeture de l'app.

## Écarts assumés
- Ajout de `PlaybackController.swift`, `MediaModels.swift`, `AppSettings.swift`, `Theme.swift` (non listés dans la structure indicative) pour garder les fichiers cohérents.
- JSON à la place de SQLite/SwiftData.
- Pas d'icône d'app pour le moment.
