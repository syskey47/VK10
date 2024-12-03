LOCAL PDFCreator, ;
	Job, ;
	GUID

SET PRINTER TO NAME PDFCreator
PDFCreatorQueue = CREATEOBJECT('PDFCreator.JobQueue')
PDFCreatorQueue.Initialize()
REPORT FORM cuentas TO PRINTER NOCONSOLE
IF	PDFCreatorQueue.WaitForJob(10)
	Job = PDFCreatorQueue.NextJob
	Job.SetProfileByGuid('DefaultGuid')
	*!* Guid = Job.GetProfileSetting('Guid')
	Job.ConvertTo('c:\vk\prueba.pdf')
	IF	Job.IsFinished OR Job.IsSuccessful
		PRDCreatorQueue.ReleaseCom()
	ENDIF
ENDIF

