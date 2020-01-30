<cf_compression>

<cfparam name="URL.ID" default="">

<cfif #URL.ID# neq "">

	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
	<html>
	<head>
		<title>PROSIS USE CASE</title>
	</head>
	
	<body leftmargin="2" topmargin="2" rightmargin="2" bottommargin="2">
	
	<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 
	
	<cfoutput>
	
	<cfset ClassId='#URL.ID#'>
	<cfquery name="QClassFunction" 
			datasource="AppsControl" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT     *
			FROM ClassFunction
			Where ClassFunctionId='#ClassId#'
	</cfquery>
	
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td><b>1. Use Case Name</b></td>
	</tr>
	
	<tr>
	<td>
	#QClassFunction.FunctionDescription#
	</td>
	</tr>
	
	<cfquery name="ListElement" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT C.*,E.ElementDescription
	    FROM ClassFunctionElement C, Ref_ClassElement E
		WHERE C.ClassFunctionId = '#QClassFunction.ClassFunctionId#' and E.ElementClass='UseCase' and
		C.ElementCode=E.ElementCode
		order by E.ListingOrder
	</cfquery>
	<cfset i=2>
	<cfloop query="ListElement">
			<tr>
			<td><br>&nbsp;&nbsp;&nbsp;<br></td>
			</tr>
			
			<tr>
			<td><b>#i#. #ListElement.ElementDescription#</b></td>
			</tr>
	
			<tr>
			<td>#ListElement.TextContent#</td>
			</tr>		
			<cfset #i#=#i#+1>
	</cfloop>
	
	
	<tr>
	<td><br><br>&nbsp;&nbsp;&nbsp;</td>
	</tr>
	<tr>
	<td><b>#i#. Associated Template(s)</b></td>
	</tr>
	
	<cfquery name="FileList" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM ClassFunctionTemplate
		WHERE ClassFunctionId = '#ClassId#'
		order by created
	</cfquery>
	
	<cfloop query="FileList">
	<tr>
	<td>
		<table>
			<tr>
			<td width="10%">#PathName#</td>
			</tr>
			<tr>
			<td width="10%">#FileName#</td>
			</tr>
			<tr>
			<td width="80%">#TemplateFunction#</td>
			</tr>
			<tr><td colspan="3"><br>&nbsp;&nbsp;&nbsp;<br></td></tr>
		</table>
	</td>
	</tr>
	</cfloop>
	
	
	</table>
	</cfoutput>
	
	
	
	</body>
	</html>

</cfif>