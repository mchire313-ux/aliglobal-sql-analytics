# aliglobal-sql-analytics
SQL Server analytics database for FMCG case study
# AliGlobal S.A.C. — SQL Server Analytics Database

**Nota:** Este es un proyecto académico con datos sintéticos (ficticios). 
No representa datos reales de ninguna organización.

## Descripción

Base de datos relacional diseñada como caso de estudio para análisis comercial 
en empresas FMCG. Proyecto final del módulo **SQL Server for Analytics** 
(W|E Educación Ejecutiva).

**Calificación: 19.0/20**

## Estructura de Base de Datos

### Tablas (5 - Normalizadas 3NF)
- **Categorias**: 20 categorías de productos
- **Productos**: 35 SKUs con precios y costos
- **Clientes**: 35 clientes en diferentes canales (Mayorista, Supermercados, Tradicional)
- **Pedidos**: 150 transacciones (enero-agosto 2026)
- **Detalle_Pedidos**: Línea de detalle de cada pedido

## Queries Incluidas (20+)

### KPIs Analizados
- **AOV (Average Order Value)**: S/ 5,452
- **Ventas por Categoría**: Conservas de Pescado lidera 24%
- **Fill-Rate Logístico**: 61.3% (homogéneo entre canales)
- **Exposición Crediticia**: 28% de pedidos > 30 días

### Técnicas SQL Utilizadas
- ✓ **Window Functions**: RANK(), ROW_NUMBER() OVER PARTITION BY
- ✓ **JOINs Complejos**: 4 INNER JOINs cruzando 5 tablas
- ✓ **CTEs**: Common Table Expressions para subconsultas
- ✓ **GROUP BY / HAVING**: Agregaciones complejas
- ✓ **Stored Procedures**: Registrar_Cliente con validación RUC
- ✓ **Índices**: Optimización de consultas

## Recomendaciones de Negocio

1. **Gestión de Crédito**: Redefinir políticas en Supermercados (86% > 30 días)
2. **Logística**: Reforzar entregas en Lima y Tarapoto (fill-rate bajo)
3. **Márgenes**: Impulsar combos entre Conservas Pescado + Lavavajillas/Margarinas
4. **Automatización**: Procedure Registrar_Cliente evita duplicados

## Archivos

- `Proyecto_AliGlobal_Final.sql` - Scripts SQL completos
- `AliGlobal_Grupo_08.pptx` - Presentación ejecutiva
- `Grupo_08_-_Entregable_Final.docx` - Documentación detallada
- `README.md` - Este archivo

## Tecnologías

- SQL Server 2019+
- T-SQL
- Window Functions
- ETL Concepts

## Autor

**Matías Chire Sebastián**
- LinkedIn: linkedin.com/in/matias-chire-455b14300
- Diplomado en Inteligencia y Análisis de Datos (W|E Educación Ejecutiva)
- Certificado: B-621615 

## Licencia

Proyecto académico - Libre para consulta y aprendizaje.
