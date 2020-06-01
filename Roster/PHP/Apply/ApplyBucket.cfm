<cfparam name="URL.owner" default="">
<cfparam name="URL.edition" default="">
<cfparam name="URL.announcement" default="1">
<cfparam name="URL.DateRestricted" default="1">
<cfparam name="URL.Direct" default="0">
<cfparam name="URL.Verbose" default="1">
<cfparam name="URL.divResponse" default="result">
<cfparam name="url.AutomaticSubmission" default="Yes">
<cfparam name="url.FunctionId" default="">

<cfset enrolled=0>
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
			   ORG.OrganizationDescription,
			   (SELECT count(*) FROM ApplicantFunction WHERE FunctionId = FO.FunctionId and ApplicantNo = '#client.applicantNo#' AND Status = '0') as Candidacy <!--- kherrera (2014-11-10):  Added Status = '0' --->
	FROM       FunctionOrganization FO INNER JOIN
               FunctionTitle F ON FO.FunctionNo = F.FunctionNo INNER JOIN
               OccGroup O ON F.OccupationalGroup = O.OccupationalGroup INNER JOIN
               Ref_Organization ORG ON FO.OrganizationCode = ORG.OrganizationCode
	WHERE      
	<cfif URL.announcement eq 1>
		FO.Announcement = 1
	<cfelse>
		1 = 1
	</cfif>
	<cfif URL.DateRestricted eq 1>
		AND        FO.DateExpiration > GETDATE()-400
	</cfif>
	<cfif URL.owner neq "">
				AND FO.SubmissionEdition IN
				(
					SELECT SubmissionEdition
  					FROM Ref_SubmissionEdition
  					WHERE Owner='#URL.owner#'
  				)
	</cfif>	
	<cfif URL.edition neq "">
				AND FO.SubmissionEdition ='#URL.edition#'
	</cfif>	
	<cfif URL.Functionid neq "">
		AND FO.Functionid = '#url.FunctionId#'
	</cfif>		
	ORDER BY   FO.PostSpecific, O.Description 
</cfquery>	


<cfif URL.verbose eq 1>
<table width="97%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding navigation_table">

	<cfoutput query="Buckets" group="PostSpecific">
		<tr><td colspan="6" height="5"></td></tr>		
		<tr><td colspan="6" align="left" class="labellarge" style="padding-left:10px"><b><cfif PostSpecific eq "1">Post specific<cfelse>Generic</cfif></b></td></tr>		
		<cfoutput group="OccupationalGroup">
		<tr><td colspan="6" height="5"></td></tr>
		<tr><td colspan="6" style="padding-left:20px" class="labelmedium linedotted"><b>#OccupationalGroup#</b></td></tr>				
		<cfoutput>
		<tr class="navigation_row linedotted">
		   <td width="50"></td>
		   <td class="labelmedium" width="50%" style="align:left">
		   		<cfif candidacy eq "0">
		   				<a title="View Job offering" href="javascript:show('#functionid#','#functionid#')">
		   		</cfif>
		   		#FunctionDescription#</a></td>
		   <td class="labelmedium">#GradeDeployment#</td>
		   <td class="labelmedium">#OrganizationDescription#</td>
		   <td class="labelmedium">#ReferenceNo#</td>
		   <td></td>
		</tr>
			
		<tr>
		   <td></td><td colspan="5">
			   <cfif candidacy gte "1">
			  		 <cf_securediv id="c#functionid#" bind="url:#SESSION.root#/roster/PHP/Apply/Candidacy.cfm?functionid=#functionid#">
			   <cfelse>
					 <cfdiv id="c#functionid#">
			   </cfif>		   
		   </td>
		</tr>	

    	<tr><td colspan="6" class="hide" id="v#functionid#"></td></tr>
	    <tr><td colspan="6" height="200" class="hide" id="a#functionid#"></td></tr>

		</cfoutput>
		</cfoutput>

	</cfoutput>	
	
</table>
<cfelse>

	<cfoutput query="Buckets" group="PostSpecific">
		<cfif candidacy eq "0">
			<div id="a#functionid#" name="a#functionid#"></div>
			<cfif url.AutomaticSubmission eq "Yes">
		 		<script>
		 		ColdFusion.navigate("#SESSION.root#/Roster/PHP/Apply/ApplySubmit.cfm?id=#FunctionId#&verbose=#url.verbose#",'#url.divResponse#')
		 		</script>
			<cfelse>
				<cfquery name="isCancelled" 
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT *
						FROM ApplicantFunction 
						WHERE FunctionId = '#FunctionId#'
						and ApplicantNo = '#client.applicantNo#' 
						AND Status = '8'
				</cfquery>
				<cfif isCancelled.recordCount neq 0>
					<cfset enrolled=1>
				</cfif>
		 	</cfif>	
		 <cfelse>
			<cfset enrolled=1>
		 </cfif>
	</cfoutput>
</cfif>