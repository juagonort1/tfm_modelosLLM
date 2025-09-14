# tfm_modelosLLM
Repositorio del Trabajo Final de Máster Evaluación comparativa de modelos LLM para la generación de informes de ciber-riesgo. 
Este repositorio contiene los prompts usados, scripts de monitorización, e informes generados durante el desarrollo del trabajo.

## 📂 Estructura del repositorio
A continuación se presenta la estructura del repositorio tfm_modelosLLM
```text
tfm_modelosLLM/
├── ficheros_estadisticas/
│   ├── estadisticas_docker_desktop.ps1
│   ├── estadisticas_docker_model_so_anfitrion.ps1
│   ├── stats.sh
│   └── stats_cortex.sh
│
├── prompt_1/
│   ├── informes/
│   │   ├── CORTEX_llama_3b_prompt1.docx
│   │   ├── DD_Meta-Llama-3.1-8B-Instruct-Q4_K_M_prompt1.docx
│   │   ├── DD_mistral-7b-instruct-v0.2.Q4_K_M_prompt1.docx
│   │   ├── GPT_3.5_prompt1.docx
│   │   ├── GPT_4_prompt1.docx
│   │   ├── UBUNTU_mistral-7B-Q4_0_prompt1.docx
│   │   └── UBUNTU_qwen3-8B-Q4_K_0_prompt1.docx
│   └── PROMPT_1.docx
│
├── prompt_2/
│   ├── informes/
│   │   ├── CORTEX_llama_3B_prompt2.docx
│   │   ├── DD_Meta-Llama-3.1-8B-Instruct-Q4_K_M_prompt2.docx
│   │   ├── DD_mistral-7b-instruct-v0.2.Q4_K_M_prompt2.docx
│   │   ├── GPT_3.5_prompt2.docx
│   │   ├── GPT_4_prompt2.docx
│   │   ├── UBUNTU_mistral-7B-Q4_0_prompt2.docx
│   │   └── UBUNTU_qwen3-8B-Q4_K_M_prompt2.docx
│   └── PROMPT_2.docx
│
└── README.md
```

## 🔍 Descripción de carpetas


| 📂 Carpeta / Archivo                             | 📝 Descripción                                                                                 |
| ------------------------------------------------ | ----------------------------------------------------------------------------------------------- |
| **ficheros\_estadisticas/**                      | En esta carpeta encontramos los scripts usados para monitorizar el uso de recursos y obtener así las estadísticas                      |
| `estadisticas_docker_desktop.ps1`            | Mide temperatura CPU, temperatura GPU, uso CPU, uso GPU, memoria RAM usada y memoria GPU usada de los modelos desplegados haciendo uso de docker desktop todo esto en el SO anfitrión ya que . |                         

| ├── `estadisticas_docker_model_so_anfitrion.ps1` | Mide temperatura CPU, temperatura GPU, uso GPU y memoria GPU usada.                             |
| ├── `stats.sh`                                   | Mide uso de CPU y memoria de un contenedor Docker.                                              |
| └── `stats_cortex.sh`                            | Mide uso total de CPU del sistema Linux.                                                        |
| **prompt\_1/**                                   | 💡 Prompt base nº1 y resultados asociados.                                                      |
| ├── `PROMPT_1.docx`                              | 📄 Documento con el texto del prompt 1.                                                         |
| └── **informes/**                                | 📑 Informes generados por distintos modelos                                                     |
| **prompt\_2/**                                   | 💡 Prompt base nº2 y resultados asociados.                                                      |
| ├── `PROMPT_2.docx`                              | 📄 Documento con el texto del prompt 2.                                                         |
| └── **informes/**                                | 📑 Informes generados por distintos modelos aplicados al prompt 2.                              |
| **README.md**                                    | 📘 Documento principal que describe el proyecto.                                                |

