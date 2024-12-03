PARAMETERS m_indir
m_indirlist = m_indir+"*.ps"
m_numofiles = ADIR(m_dirtocheck,m_indirlist)
IF m_numofiles = 0
	RETURN
ENDIF
FOR it = 1 TO m_numofiles
	m_filetocnv=m_indir+m_dirtocheck[it,1]
	=ps2pdf(m_filetocnv)
ENDFOR
