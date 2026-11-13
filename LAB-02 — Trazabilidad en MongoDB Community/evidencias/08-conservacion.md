## LAB-02 — Trazabilidad en MongoDB Community
_Gestión de seguridad y desempeño de bases de datos_

**Camacho Castañeda Angélica María 4-1**

**Menciona tres formas en que la evidencia del perfilador o de la bitácora puede perderse sin que nadie la borre deliberadamente.**

* Reinicio del servidor. El nivel del perfilador vuelve a 0 y la memoria de getLog se vacía. 
* Sobrescritura por tamaño limitado. system.profile es una colección de tamaño fijo, y cuando se llena, las operaciones nuevas reemplazan a las más viejas. 
* Rotación o límite de la bitácora. El archivo mongod.log puede rotarse y eliminarse por política de retención, y getLog solo guarda las últimas líneas en memoria. 
**¿Por qué el tamaño de 1 MB de system.profile es un problema de conservación y no solo de espacio?**

Porque no es un límite que impida escribir, sino uno que borra en silencio lo más antiguo para hacer lugar a lo nuevo. No marca error ni avisa, así que el sistema parece funcionar normal mientras la evidencia desaparece. Con 1 MB hay espacio para muy pocas operaciones, y si hay mucha actividad o está el nivel 2, un incidente de hace unas horas ya puede haberse sobrescrito por haber hecho espacio para algo nuevo. El problema real es que la evidencia tiene una vida útil corta sin que nadie lo decida, y por eso hay que exportarla antes de perderla.

**¿Por qué getLog sirve para interpretar pero no para conservar?**
Sirve para interpretar porque devuelve los eventos recientes ya estructurados, y con bitacora() puedes filtrar por ctx, usuario o mensaje y correlacionar eventos. No sirve para conservar porque solo muestra lo que cabe en la memoria del servidor, no el historial completo ya que basta con un reinicio y lo vacía y los eventos viejos salen aunque el servidor siga encendido.