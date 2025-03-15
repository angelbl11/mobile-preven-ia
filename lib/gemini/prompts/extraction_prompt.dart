const String extractionPrompt = '''
Prompt para extracción y estandarización de datos de análisis clínicos

Instrucciones:

1. Contexto y Objetivo:
Se te proporciona un texto plano extraído de un archivo PDF en español que contiene resultados de análisis clínicos de sangre, donde se listan diversos parámetros (por ejemplo, Hemoglobina, Glucosa en ayunas, Colesterol, etc.) junto con sus valores y, en algunos casos, unidades. Tu tarea es extraer de forma automática cada parámetro y su valor asociado, **estandarizar el nombre del parámetro a una forma común y legible para un usuario**, y luego presentar todo en un formato estandarizado apto para ser almacenado en una base de datos Firebase. La salida final debe tener tanto las claves como el contenido en español.

2. Pasos a Seguir:
• Lectura y Extracción:
   - Procesa el texto plano extraído del archivo PDF en español y localiza todos los parámetros relevantes junto a sus valores.
   - Ignora cualquier información no relacionada o texto extra que no represente un dato clínico (por ejemplo, encabezados, pies de página, notas aclaratorias).

• Estandarización de Nombres:
   - Para cada parámetro extraído, compáralo con la siguiente tabla de estandarización. Si encuentras una coincidencia o una variación cercana, utiliza el nombre estandarizado correspondiente.
   - **Tabla de Estandarización de Parámetros:**
     | Nombre Encontrado en el Texto                | Nombre Estandarizado |
     |---------------------------------------------|-----------------------|
     | Hemoglobina                                 | Hemoglobina           |
     | Hb                                          | Hemoglobina           |
     | Glucosa en ayunas                           | Glucosa en ayunas     |
     | Glucosa Basal                               | Glucosa en ayunas     |
     | Colesterol Total                            | Colesterol Total      |
     | Colesterol                                    | Colesterol Total      |
     | HDL Colesterol                            | Colesterol HDL        |
     | C-HDL                                       | Colesterol HDL        |
     | LDL Colesterol                            | Colesterol LDL        |
     | C-LDL                                       | Colesterol LDL        |
     | **Colesterol de baja densidad (LDL)** | **Colesterol LDL** |
     | **Colesterol LDL Directo** | **Colesterol LDL** |
     | Triglicéridos                               | Triglicéridos         |
     | Triglicéridos (TG)                          | Triglicéridos         |
     | Ácido Úrico                                 | Ácido Úrico           |
     | Creatinina                                  | Creatinina            |
     | Urea                                        | Urea                  |
     | Bilirrubina Total                           | Bilirrubina Total     |
     | Bilirrubina Directa                         | Bilirrubina Directa   |
     | Bilirrubina Indirecta                       | Bilirrubina Indirecta |
     | TGO                                         | AST (Transaminasa)    |
     | AST (SGOT)                                  | AST (Transaminasa)    |
     | Transaminasa Glutámico Oxalacética          | AST (Transaminasa)    |
     | TGP                                         | ALT (Transaminasa)    |
     | ALT (SGPT)                                  | ALT (Transaminasa)    |
     | Transaminasa Glutámico Pirúvica            | ALT (Transaminasa)    |
     | Plaquetas                                   | Plaquetas             |
     | Recuento de Plaquetas                       | Plaquetas             |
     | Leucocitos                                  | Leucocitos            |
     | Glóbulos Blancos                            | Leucocitos            |
     | Hematocrito                                 | Hematocrito           |
     | Hto                                         | Hematocrito           |
     | VCM                                         | VCM                   |
     | HCM                                         | HCM                   |
     | CHCM                                        | CHCM                  |
     | Linfocitos                                  | Linfocitos            |
     | Monocitos                                   | Monocitos             |
     | Neutrófilos                                 | Neutrófilos           |
     | Eosinófilos                                 | Eosinófilos           |
     | Basófilos                                   | Basófilos             |
     | Sodio (Na)                                  | Sodio                 |
     | Potasio (K)                                 | Potasio               |
     | Cloro (Cl)                                  | Cloro                 |
     | Calcio Total (Ca)                           | Calcio Total          |
     | Fosforo (P)                                 | Fósforo               |
     | Proteínas Totales                           | Proteínas Totales     |
     | Albúmina                                    | Albúmina              |
     | Globulina                                   | Globulina             |
     | Relación Albúmina/Globulina                 | Relación A/G          |
     | Tiempo de Protrombina (TP)                  | Tiempo de Protrombina |
     | INR                                         | INR                   |
     | TTPA                                        | TTPA                  |
     | PCR                                         | PCR                   |
     | VSG                                         | VSG                   |
     | Hormona Estimulante de la Tiroides          | TSH                   |
     | TSH (Hormona Tirotropina)                   | TSH                   |
     | Tiroxina Libre (T4 Libre)                   | T4 Libre              |
     | Triyodotironina Libre (T3 Libre)             | T3 Libre              |
     | Anticuerpos Anti-Tiroideos                  | Anticuerpos Tiroideos |
     | Ácido Fólico                                | Ácido Fólico          |
     | Vitamina B12                                | Vitamina B12          |
     | Ferritina                                   | Ferritina             |
     | Transferrina                                | Transferrina          |
     | Índice de Saturación de Transferrina        | IST                   |
     | Glucosa Postprandial                        | Glucosa Postprandial  |
     | Hemoglobina Glicosilada (HbA1c)             | Hemoglobina Glicosilada |
     | HbA1c                                       | Hemoglobina Glicosilada |
     | Insulina                                    | Insulina              |
     | Péptido C                                   | Péptido C             |
     | Examen General de Orina                     | Examen General de Orina |
     | EGO                                         | Examen General de Orina |
     | Uroanálisis                                 | Examen General de Orina |

   - Si un parámetro no se encuentra exactamente en la tabla, **busca palabras clave importantes** como "LDL", "baja densidad", "VLDL", "alta densidad", "glucosa", "colesterol", etc., para intentar inferir el parámetro y asignarle el nombre estandarizado más apropiado. Si encuentras "LDL" o "baja densidad" junto con "colesterol", estandarízalo como "Colesterol LDL".

• Formateo de Datos:
   - Para cada parámetro identificado y estandarizado, genera un par en el siguiente formato:
     nombre_estandarizado:valor
   - Si el valor incluye una unidad (por ejemplo, mg/dL, g/dL), asegúrate de incluirla junto al valor sin espacios innecesarios (por ejemplo, `Glucosa en ayunas:95 mg/dL`).
   - En caso de que algún parámetro no tenga un valor asignado, utiliza "N/A".

• Estructura de Salida:
   - El resultado final debe ser un objeto JSON donde las claves sean los nombres estandarizados de los parámetros y los valores sean las lecturas con sus unidades.
   - Ejemplo de salida en formato JSON (todo en español):

{
  "Hemoglobina": "13.5 g/dL",
  "Glucosa en ayunas": "95 mg/dL",
  "Colesterol Total": "190 mg/dL",
  "Colesterol LDL": "110 mg/dL",
  "Colesterol HDL": "60 mg/dL",
  "Triglicéridos": "150 mg/dL"
  // ... otros parámetros estandarizados
}

• Asegúrate de que la salida sea fácilmente integrable en una base de datos Firebase.

3. Consideraciones Adicionales:
• Valida que no se pierda información importante durante la extracción, incluso si el formato del texto presenta inconsistencias.
• Si encuentras elementos duplicados o ambigüedad en la identificación de parámetros, prioriza la información que siga un patrón consistente en el documento. **En caso de ambigüedad en el nombre de un parámetro, intenta utilizar el contexto de otros parámetros cercanos para inferir el nombre correcto o utiliza el nombre más común según la tabla de estandarización.**
• La solución debe ser adaptable a distintos formatos de texto extraído de archivos PDF que contengan resultados clínicos, por lo que se requiere un análisis robusto del contenido. **Prioriza el uso de los nombres estandarizados de la tabla para la salida final.**
• **Intenta extraer la unidad de medida junto con el valor de cada parámetro. Si la unidad no está explícitamente mencionada junto al valor, pero hay una unidad común para ese parámetro en el contexto del documento, utilízala.** **Sé flexible en la búsqueda de nombres de parámetros, considerando variaciones en mayúsculas, minúsculas, espacios y el uso de abreviaturas comunes (siempre que no generen ambigüedad con otros parámetros).**

4. Ejemplo de Entrada y Salida:
• Texto extraído (entrada, en español):
   Hb: 13.5 g/dL
   Glucosa Basal: 95 mg/dL
   Colesterol Total: 190 mg/dL
   Colesterol de baja densidad (LDL): 110 mg/dL
   Colesterol LDL Directo: 115 mg/dL
   C-HDL: 60 mg/dL
   Triglicéridos (TG): 150 mg/dL

• Formato esperado (salida):

{
  "Hemoglobina": "13.5 g/dL",
  "Glucosa en ayunas": "95 mg/dL",
  "Colesterol Total": "190 mg/dL",
  "Colesterol LDL": "110 mg/dL",
  "Colesterol HDL": "60 mg/dL",
  "Triglicéridos": "150 mg/dL"
}

Este prompt ahora incluye las variaciones específicas de LDL que mencionaste y también proporciona una instrucción más general para la identificación de parámetros basada en palabras clave, lo que debería hacerlo más robusto. Si tienes alguna otra pregunta o necesitas más clarificaciones, no dudes en preguntar.
''';
