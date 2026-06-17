# Trazabilidad — scaffold_cleanup

## Mapa R → verificación

Esta feature es de estructura/scaffolding. Las verificaciones son comprobaciones de existencia de archivos y ejecución de init.sh, no tests unitarios de código.

| Requirement | Verificación |
|------------|-------------|
| R1 — src/, tests/, specs/example_feature/ eliminados | `ls /home/pablo/Hermess-agent-GCP/src` → error (no existe). Confirmado via find. |
| R2 — Carpetas terraform/, scripts/, config/hermes/, config/litellm/, config/systemd/, skills/git-workflow/ creadas | `find . -type d` lista todas las carpetas. Confirmado. |
| R3 — feature_list.json con 10 features reales | init.sh paso 3: `[OK] feature_list.json válido (10 features)`. |
| R4 — specs/<feature>/ con requirements.md, design.md, tasks.md para las 10 features | `find specs/ -type f` lista 30 archivos (3 por feature × 10 features). Confirmado. |
| R5 — .gitignore reescrito con reglas Terraform/secretos/Python/OS | Contenido verificado visualmente en el archivo. |
| R6 — ./init.sh termina sin errores | Ejecutado: salida `[OK] Entorno listo. Puedes empezar a trabajar.` con exit code 0. |

## Notas

- La feature no tiene tests unitarios porque es 100% estructural (creación/eliminación de archivos).
- El criterio de done objetivo es `./init.sh` verde + estructura de archivos correcta.
- Todos los archivos stub en terraform/, scripts/, config/ tienen comentarios `# TODO: implementar en Feature N`.
