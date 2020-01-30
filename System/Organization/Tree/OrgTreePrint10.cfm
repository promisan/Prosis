<cfoutput>

<cfdocument
format = "pdf"
orientation  = "landscape"
marginBottom = "0.2"
marginLeft   = "0.2"
marginRight  = "0.2"
marginTop    = "0.2"
mimeType     = "image/jpeg"
scale        = "90">



	<cfinclude template="OrgTreePrintBody.cfm">

</cfdocument>

</cfoutput>

