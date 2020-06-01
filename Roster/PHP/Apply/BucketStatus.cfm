
<cfquery name="Buckets" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     FO.PostSpecific, 
	           F.FunctionDescription, 
			   O.Description AS OccupationalGroup, 
			   FO.FunctionId, 
			   FO.FunctionNo, 
			   FO.OrganizationCode, 
               FO.SubmissionEdition, 
			   FO.GradeDeployment, 
			   FO.DocumentNo, 
			   FO.ReferenceNo, 
			   ORG.OrganizationDescription
	FROM       FunctionOrganization FO INNER JOIN
               FunctionTitle F ON FO.FunctionNo = F.FunctionNo INNER JOIN
               OccGroup O ON F.OccupationalGroup = O.OccupationalGroup INNER JOIN
               Ref_Organization ORG ON FO.OrganizationCode = ORG.OrganizationCode
	WHERE      FO.Announcement = 1 	
	AND        FO.DateExpiration > GETDATE()-400
	AND        FO.FunctionId IN (SELECT FunctionId
	                             FROM   ApplicantFunction 
								 WHERE  ApplicantNo = '#client.applicantNo#')
	ORDER BY   FO.PostSpecific, O.Description 
</cfquery>	


<table width="97%" border="0" cellspacing="0" cellpadding="0">

<cfoutput query="Buckets" group="PostSpecific">

<tr><td colspan="6" height="5"></td></tr>
<tr><td colspan="6" height="1" bgcolor="silver"></td></tr>
<tr><td bgcolor="f4f4f4" colspan="6" align="left" height="25">
&nbsp;<b><cfif PostSpecific eq "1">Post specific<cfelse>Generic</cfif></b></td></tr>
<tr><td colspan="6" height="1" bgcolor="silver"></td></tr>

<cfoutput group="OccupationalGroup">

<tr><td colspan="6" height="5"></td></tr>
<tr><td colspan="6" align="left" height="25">&nbsp;<b>#OccupationalGroup#</b></td></tr>
<tr><td colspan="6" height="1" bgcolor="silver"></td></tr>

<cfoutput>

	<tr>
	   <td width="50" align="left"></td>
	   <td width="50%" align="left">#FunctionDescription#</td>
	   <td align="left">#GradeDeployment#</td>
	   <td align="left">#OrganizationDescription#</td>
	   <td align="left">#ReferenceNo#</td>
	   <td></td>
	</tr>
		
	<tr>
	   <td></td>
	   <td colspan="5">
	   	   	   
	  		 <cf_securediv id="c#functionid#" bind="url:#SESSION.root#/Roster/PHP/Apply/Candidacy.cfm?functionid=#functionid#">	   
	  	  	   
	   </td>
	</tr>
	<tr bgcolor="silver"><td colspan="6"></td></tr>


</cfoutput>

</cfoutput>

</cfoutput>	
</table>
