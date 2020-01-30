
<!--- 
1.	restore template content from prior
2.	disabled entry using action status = 9
3.	reload dialog screen
--->

<cfquery name="Find" 
datasource="AppsControl">
	SELECT *
	FROM   Ref_TemplateContent	
	WHERE TemplateId = '#URL.ID#'
</cfquery>	

<cfquery name="Prior" 
	datasource="AppsControl">
	<!--- right --->
	SELECT TOP 1 *
	FROM     Ref_TemplateContent	
	WHERE    FileName   = '#find.Filename#'
	AND      PathName   = '#find.PathName#'
	AND      ApplicationServer = '#find.ApplicationServer#'
	AND      TemplateStatus = '1'
	AND      VersionDate < '#dateformat(Find.VersionDate, client.dateSQL)#'
	ORDER BY TemplateModified DESC
</cfquery>	

<cfquery name="Deactivate" 
		datasource="AppsControl">
		UPDATE Ref_TemplateContent	
		SET    TemplateStatus = '9'
		WHERE  TemplateId = '#URL.ID#'
</cfquery>

<cfif find.PathName neq "[root]">
	 <cfset path = find.pathName>
<cfelse>
	 <cfset path = "">
</cfif>

<cffile action="WRITE" 
    file="#SESSION.rootPath#\#path#\#find.Filename#" 
	output="#Prior.TemplateContent#" 
	addnewline="Yes" 
	fixnewline="No">
	
<font color="FF0000">Restored</font>	



