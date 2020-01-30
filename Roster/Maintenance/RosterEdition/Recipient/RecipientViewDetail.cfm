<cfparam name="URL.OrgUnit" default="">


<cfif URL.OrgUnit neq "">

	<cfquery name="Check" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT * 
	  FROM   Ref_SubmissionEditionOrganization
	  WHERE  SubmissionEdition = '#URL.SubmissionEdition#'
	  AND    OrgUnit = '#URL.OrgUnit#' 
	</cfquery>
	
	<cfif Check.recordcount eq "0">

		<cfquery name="qInsert" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_SubmissionEditionOrganization
		        (SubmissionEdition,OrgUnit,OfficerUserId,OfficerLastName,OfficerFirstName)
		VALUES(	
				'#URL.SubmissionEdition#',
				'#URL.OrgUnit#',
				'#SESSION.acc#',
				'#SESSION.last#',
				'#SESSION.first#') 
		</cfquery>
	
	</cfif>
	
</cfif>	

<cfquery name="qRecipients" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT    SEO.Operational,   
            O.*,
			
			(SELECT count(*) 
		     FROM   Organization.dbo.OrganizationAddress O, System.dbo.Ref_Address A
			 WHERE  O.AddressId = A.AddressId			 
		     AND    OrgUnit = SEO.OrgUnit
			 AND    A.eMailAddress <> '' and A.eMailAddress is not NULL) as Valid,
			
            (SELECT count(DISTINCT eMailAddress) 
		     FROM   Ref_SubmissionEditionPublishMail 
		     WHERE  SubmissionEdition = '#URL.SubmissionEdition#'
		     AND    OrgUnit           = SEO.OrgUnit
		     AND    ActionStatus = '1') as Sent
		  
  FROM     Ref_SubmissionEditionOrganization SEO INNER JOIN Organization.dbo.Organization O ON SEO.OrgUnit = O.OrgUnit
  
  WHERE    SubmissionEdition = '#URL.SubmissionEdition#'  
  AND	   O.OrgUnitClass = 'Substantive'
  
  ORDER BY OrgUnitNameShort
</cfquery>

<cfoutput>

<cfset TotalActive = 0>

<table width="100%" border="0">

<tr valign="top">
	
	<td style="padding:5px">
	
		<table width="100%" border="0" cellspacing="0" cellpadding="0" valign="top">
		
			<cfset vTotal = 4>
			<cfset row    = 0>
			
			<cfloop query="qRecipients">
			
				<cfset row = row+1>
			
				<cfif row eq 1>
					<tr height="20px" align="left" valign="center">
				</cfif>
				
				<cfif OrgUnitNameShort neq "">
					<cfset vOrgName = OrgUnitNameShort>
				<cfelse>	
					<cfset vOrgName = OrgUnitName>
				</cfif>
				
				<cfif operational eq 1>
					<cfset class="white">
					<cfset display="#vOrgName#">
					<cfset TotalActive = TotalActive + 1>
				<cfelse>
					<cfset class="f4f4f4">					
					<cfset display="<i>#vOrgName#</i>">					
				</cfif>
				
				<td width="1%" bgcolor="#class#" style="padding-left:5px;border-left:1px dotted silver">
				    
					<cfif valid gt "0">
						<cfif operational eq 1>
							<input type="checkbox" class="radiol" onclick="recipient(this.checked,'#URL.SubmissionEdition#','#OrgUnit#')" checked>
						<cfelse>
							<input type="checkbox" class="radiol" onclick="recipient(this.checked,'#URL.SubmissionEdition#','#OrgUnit#')">
						</cfif>
					</cfif>
				</td>	
					
				<td width="24%" bgcolor="#class#" class="labelmedium" style="padding-right:5px;padding-left:5px;border-right:1px dotted silver">
					<a href="##" onclick="getUnitAddress('#orgUnit#','#url.submissionedition#')">#display#</a>&nbsp;[#valid#<cfif sent gt "0"><font size="3" color="blue"><b>|#sent#</cfif>]	
				</td>
					
				<cfif row eq 4>
					</tr>		
					<cfset row = 0>		
				</cfif>	
				
			</cfloop>
		
		</table>
		
	</TD>
	
</tr>	
	
</table>

<script language="JavaScript">
	$('##lrecipients').html('<b>Recipients (#TotalActive#)</b>');
</script>

</cfoutput>