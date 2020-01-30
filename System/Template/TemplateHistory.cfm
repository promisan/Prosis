
<cfquery name="Find" 
datasource="appsControl">
	SELECT *
	FROM   Ref_TemplateContent	
	WHERE TemplateId = '#URL.ID#'
</cfquery>	

<cfset srvnme  = "#Find.ApplicationServer#">
<cfset filedir = "#Find.PathName#">
<cfset filenme = "#Find.FileName#">

<cfoutput>

<table width="100%" cellspacing="0" cellpadding="0" class="formpadding"><tr>

<cfquery name="Template" 
	datasource="appsControl">
	SELECT *
	FROM   Ref_TemplateContent	
	WHERE  FileName          = '#filenme#'
	AND    PathName          = '#filedir#'
	AND    ApplicationServer = '#srvnme#'
	<!--- 
	AND    VersionDate != '#dateFormat(find.VersionDate,client.DateSQL)#'
	--->
	AND    TemplateStatus = '1'
	ORDER BY Created DESC 
</cfquery>
		
<cfif template.recordcount eq "0">
  <tr><td align="center"><b>No history found</td></tr>

<cfelse>  

<!---
<tr bgcolor="white">
    <td></td>
	<td>Modified on</td>
	<td>Officer</b></td>
	<td>Size</td>
	<td>Version Date</td>
</tr>
<tr><td height="1" bgcolor="silver" colspan="5"></td></tr>			
--->
		
<cfloop query="Template">

	<cfif dateformat(VersionDate,client.DateSQL) eq dateFormat(find.VersionDate,client.DateSQL)>
	<cfset color = "ffffcf">
	<cfelse>
	<cfset color = "white">
	</cfif>
	
	<tr bgcolor="#color#"><td width="20" align="center">
	<img src="#SESSION.root#/Images/pointer.gif" alt="" align="absmiddle" border="0">
	</td>
	<td>
	<cfif find(".cfr",filename)>
		#dateFormat(TemplateModified,CLIENT.DateFormatShow)# #timeFormat(TemplateModified,"HH:MM")#
	<cfelse>
		<a href="javascript:detail('#TemplateId#','prior')" title="Retrieve template details">
		  #dateFormat(TemplateModified,CLIENT.DateFormatShow)# #timeFormat(TemplateModified,"HH:MM")#
		</a>
	</cfif>
		
	</td>
	<td>#TemplateModifiedBy#</td>
	<td>#numberformat(TemplateSize/1024,"_._")# kb</td>
	<td>#dateFormat(VersionDate,CLIENT.DateFormatShow)#</td>
	</tr>
</cfloop>
	
</tr>

</cfif>

</cfoutput>

