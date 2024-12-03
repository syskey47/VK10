SELECT 0
USE ctb_documentos ORDER tag id
DELETE FOR idtipodoc = 3 AND fecha = {^2007.06.01}
GO top
SELECT 0
USE ctb_diario
SET RELATION TO iddocumento INTO ctb_documentos
DELETE FOR iddocumento # ctb_documentos.id
SET RELATION to
CLOSE TABLES all
RETURN
