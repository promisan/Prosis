
<cfparam name="url.orgunit" default="">
<cfparam name="url.action" default="insert">

<cfif url.orgunit neq "">
	
	<cfif url.action eq "insert">
		
		<cfquery name="Insert" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO JournalOrgUnit
				
						(Journal,
						 OrgUnit,
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName)
						 
				VALUES	('#url.id1#',
	   				     '#url.orgunit#',
					     '#session.acc#',
					     '#session.last#',
					     '#session.first#')	
		</cfquery>			
	
	<cfelse>
	
		<cfquery name="Delete" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM JournalOrgUnit
			WHERE  Journal = '#url.id1#'
			AND    OrgUnit = '#url.orgunit#'		
		</cfquery>		
	
	</cfif>

</cfif>

<cfquery name="Org" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    O.Mission, 
		          O.MandateNo, 
				  O.OrgUnit, 
				  O.OrgUnitCode, O.OrgUnitName
		FROM      JournalOrgUnit JO INNER JOIN
	              Organization.dbo.Organization O ON JO.OrgUnit = O.OrgUnit
		WHERE     JO.Journal = '#url.id1#'	  
		ORDER BY  O.MandateNo
</cfquery>			
	
	<table width="100%" cellspacing="0" cellpadding="0" class="navigation_table">
			
			<tr class="labelmedium line">
				<td width="3%" align="center"></td>
				<td width="15%"><cf_tl id="Period"></td>
				<td width="10%" class="labelit"><cf_tl id="Code"></td>
				<td width="60%" class="labelit"><cf_tl id="Name"></td>			
			</tr>
						
			<cfoutput query="Org">	
		
				<tr class="line labelmedium navigation_row">
					<td style="padding-left:3px;width:30px" class="navigation_action">
						<cf_img icon="delete" 
						 onclick="_cf_loadingtexthtml='';ColdFusion.navigate('JournalCostCenterList.cfm?id1=#url.id1#&action=delete&orgunit=#orgunit#','myprocess')">
					</td>
					<td>#MandateNo#</td>
					<td>#OrgUnitCode#</td>
					<td>#OrgUnitName#</td>						
				</tr>
						
			</cfoutput>
		
	</table>	