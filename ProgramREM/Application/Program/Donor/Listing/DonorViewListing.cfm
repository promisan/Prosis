
<cf_listingscript>

<!--- --------------------------------------------------------------- --->
<!--- 5/4/2013 provision to record pending periods for a contribution --->
<!--- --------------------------------------------------------------- --->

<cf_screentop html="No" jquery="Yes" scroll="Yes">

<cfparam name="url.mode"    default="Detail">
<cfset url.mission = url.id2>

	<cfquery name="EnbleContributionLinesForPeriod"
		    datasource="AppsProgram" 
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
			INSERT INTO ContributionLinePeriod
			
				     (ContributionLineId, 
					  Period,
					  OfficerUserId, 
					  OfficerLastName, 
					  OfficerFirstName)
					  
			SELECT     CL.ContributionLineId, 
			           P.Period,  
					   '#SESSION.acc#',
					   '#SESSION.last#',
					   '#SESSION.first#'
			FROM       Contribution C INNER JOIN
            	       ContributionLine CL ON C.ContributionId = CL.ContributionId INNER JOIN
                	   Organization.dbo.Ref_MissionPeriod MP ON C.Mission = MP.Mission INNER JOIN
                       Ref_Period P ON MP.Period = P.Period AND CL.DateEffective < P.DateExpiration AND (CL.DateExpiration IS NULL OR
	                   CL.DateExpiration > P.DateEffective)
			WHERE      C.Mission = '#url.mission#'
			
			AND      NOT EXISTS
	                          (SELECT  ContributionLineId
	                           FROM    ContributionLinePeriod
	                           WHERE   ContributionLineId = CL.ContributionLineId
							   AND     Period = p.Period)
	</cfquery>		
				
	<table cellpadding="0" cellspacing="0" border="0" align="center" width="100%" height="100%">
	
		<cfif url.mode eq "Summary">
			<tr class="line"><td style="padding-top:14px">
			<cfoutput>			
			<table>
			<tr>
			<td><input type="radio" class="radiol" name="Filter" id="Filter" value="Active" checked onclick="ColdFusion.navigate('DonorViewSummary.cfm?#cgi.Query_String#&filter='+this.value,'content')"></td>
			<td style="padding-left:4px" class="labelmedium"><cf_tl id="Active"></td>
			<td><input type="radio" class="radiol" name="Filter" id="Filter" value="Expired"  onclick="ColdFusion.navigate('DonorViewSummary.cfm?#cgi.Query_String#&filter='+this.value,'content')"></td>
			<td style="padding-left:4px" class="labelmedium"><cf_tl id="Expired"></td>
			<td><input type="radio" class="radiol" name="Filter" id="Filter" value="All"  onclick="ColdFusion.navigate('DonorViewSummary.cfm?#cgi.Query_String#&filter='+this.value,'content')"></td>
			<td style="padding-left:4px" class="labelmedium"><cf_tl id="All"></td>
			</tr>
			</table>
			</cfoutput>
			</td></tr>
		</cfif>
		<tr>
			<td width="98%" align="center" height="100%" valign="top" style="padding-left:18px;padding-right:18px" id="content">				
			<cfif url.mode eq "Summary">
				<cfinclude template="DonorViewSummary.cfm">		
			<cfelseif url.mode eq "Tranche">
				<cfinclude template="DonorViewTranche.cfm">			
			<cfelse>
				<cfinclude template="DonorViewContribution.cfm">					
			</cfif>	
			</td>
		</tr>
		
	</table>
	
	


