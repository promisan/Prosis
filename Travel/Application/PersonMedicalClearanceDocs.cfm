<!---
	PersonMedicalClearanceDocs.htm
	
	List attachments to current person undergoing medical clearance.
	
	This page is inserted into bottom of PersonMedicalClearance.htm
	
	Calls:  ..Tools\Document\FileLibraryN.cfm
	
	Modification history:
	
--->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Medical Documents</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
<tr>
<td width="100%" align="center">

	 <cf_filelibraryN
    	DocumentURL="personnel"
		DocumentPath="personnel"
		SubDirectory="#CandAction.PersonNo#" 
		Filter="MS2"
		Insert="no"
		Remove="no"
		ShowSize="0"
		reload="no">	

</td>
</tr>
<tr><td height="1">&nbsp;</td></tr>
</table>
</body>
</html>
