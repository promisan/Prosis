<!---
<cfhttp url="http://www.w3.org/TR/REC-html32" method="get" resolveURL="true">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<cfdocument format="PDF" encryption="40-bit"
   ownerpassword="us3rpa$$w0rd" userpassword="us3rpa$$w0rd"
   permissions="AllowCopy" >
--->
<html><head>

<title>Print JJ</title>

<cfdocument 
			format="pdf" 
			margintop = "0.25"   
			marginbottom = "0.25"   
			marginleft = "0.25"   
			marginright = "0.25"
			scale=95 orientation="landscape">
<body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="1">
<title>Print JJ</title>
<cfoutput>
<link rel="stylesheet" type="text/css" href="#SESSION.root#/#client.style#">

</cfoutput>

<cfoutput >
<cfinclude template="claimviewdetails.cfm">
</cfoutput>

</cfdocument>
</head></html>
