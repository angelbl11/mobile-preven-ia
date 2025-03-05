const String extractionPrompt = '''
Prompt para extracción y estandarización de datos de análisis clínicos

Instrucciones:

1. Contexto y Objetivo:
Se te proporciona un texto plano extraído de un archivo PDF en español que contiene resultados de análisis clínicos de sangre, donde se listan diversos parámetros (por ejemplo, Hemoglobina, Glucosa en ayunas, Colesterol, etc.) junto con sus valores y, en algunos casos, unidades. Tu tarea es extraer de forma automática cada parámetro y su valor asociado, y luego presentarlo en un formato estandarizado apto para ser almacenado en una base de datos Firebase. La salida final debe tener tanto las claves como el contenido en español.

2. Pasos a Seguir:
• Lectura y Extracción:
   - Procesa el texto plano extraído del archivo PDF en español y localiza todos los parámetros relevantes junto a sus valores.
   - Ignora cualquier información no relacionada o texto extra que no represente un dato clínico (por ejemplo, encabezados, pies de página, notas aclaratorias).

• Formateo de Datos:
   - Para cada parámetro identificado, genera un par en el siguiente formato:
     nombre:valor
   - Si el valor incluye una unidad (por ejemplo, mg/dL, g/dL), asegúrate de incluirla junto al valor sin espacios innecesarios (por ejemplo, Glucosa en ayunas:95 mg/dL).
   - En caso de que algún parámetro no tenga un valor asignado, utiliza "N/A" o déjalo en blanco, según se indique en las especificaciones.

• Estructura de Salida:
   - El resultado final debe ser un listado limpio de pares "nombre:valor".
   - Puedes organizar el resultado como una lista de cadenas o como un objeto JSON.
   - Ejemplo de salida en formato JSON (todo en español):

{
  "Hemoglobina": "13.5 g/dL",
  "Glucosa en ayunas": "95 mg/dL",
  "Colesterol": "190 mg/dL"
}

• Asegúrate de que la salida sea fácilmente integrable en una base de datos Firebase.

3. Consideraciones Adicionales:
• Valida que no se pierda información importante durante la extracción, incluso si el formato del texto presenta inconsistencias.
• Si encuentras elementos duplicados o ambigüedad en la identificación de parámetros, prioriza la información que siga un patrón consistente en el documento.
• La solución debe ser adaptable a distintos formatos de texto extraído de archivos PDF que contengan resultados clínicos, por lo que se requiere un análisis robusto del contenido.

4. Ejemplo de Entrada y Salida:
• Texto extraído (entrada, en español):
   Hemoglobina: 13.5 g/dL
   Glucosa en ayunas: 95 mg/dL
   Colesterol: 190 mg/dL

• Formato esperado (salida):
   - Lista de cadenas:
     • Hemoglobina:13.5 g/dL
     • Glucosa en ayunas:95 mg/dL
     • Colesterol:190 mg/dL
   - O como JSON:

{
  "Hemoglobina": "13.5 g/dL",
  "Glucosa en ayunas": "95 mg/dL",
  "Colesterol": "190 mg/dL"
}

Este prompt establece de manera clara los pasos, criterios y formato requerido, garantizando que la extracción de datos sea precisa y que los resultados se encuentren en un formato adecuado para su posterior almacenamiento en Firebase.
''';
