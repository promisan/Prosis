
<html>
<head>
	<title><cfoutput>Mail</cfoutput></title>
</head>
<body onLoad="window.focus()"></body>

<cfquery name="Object" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT     *
FROM       OrganizationObject
WHERE      ObjectId = '#URL.Objectid#'
</cfquery>

<!---

<cfdocument 
          format="PDF"
          pagetype="letter"
		  orientation="portrait"
          unit="cm"
          encryption="none"
		  margintop="0.4"
          marginbottom="0.4"
          marginright="0.4"
          marginleft="0.4"
          fontembed="Yes"
          scale="90"
          backgroundvisible="Yes">
		  
		  --->
		  		  
		  <!---
		  <cfdocumentitem type="header">
		  --->
		  <table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
		  <tr><td align="center"><cfoutput>#Object.ObjectReference#</cfoutput></td></tr>
		  <tr><td height="1" bgcolor="0080C0"></td></tr>
		  </table>	
		  
		  <!---	  		  
		  </cfdocumentitem>
		  --->

		  <cfset pdf = 1>
		  <cfinclude template="NoteBody.cfm">
		  
<!---		  

</cfdocument>

--->


<script>
window.print()
</script>

