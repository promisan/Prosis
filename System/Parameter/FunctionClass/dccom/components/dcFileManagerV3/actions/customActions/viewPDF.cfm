<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>Untitled</title>
</head>

<body>

<!---<cfoutput>#session.folder#\#fileName#</cfoutput> --->
<cfheader name="content-Disposition" value="inline; filename=#fileName#">
<cfcontent type="application/pdf"
           file="#session.folder#\#fileName#"
           deletefile="No">


</body>
</html>
