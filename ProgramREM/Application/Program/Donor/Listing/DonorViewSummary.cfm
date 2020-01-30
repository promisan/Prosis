
<!--- summary of the contributions --->

<!---
Graph total balance
Total amount - allocation = balance
Show total by Fund/Class
Contribution  Correction Prior year  Allocation  -> Balance

--->

<cfparam name="url.mode"    default="Detail">
<cfparam name="url.mission" default="#url.id2#">
<cfparam name="url.filter" default="active">
<cfinclude template="DonorViewPrepare.cfm">

<table width="99%" height="100%">

<tr>

<cfif url.filter eq "active">
	<td height="20" class="labellarge" style="padding;10px"><font color="008000">ACTIVE</font> (not expired) contribution tranches versus their allocated monies</b></td>
<cfelseif url.filter eq "expired">
	<td height="20" class="labellarge" style="padding;10px"><font color="red">EXPIRED</font> contribution tranches versus their allocated monies</b></td>
<cfelse>
    <td height="20" class="labellarge" style="padding;10px">Contribution tranches versus their allocated monies</b></td>
</cfif>
</tr>
	
<tr><td height="100%" style="padding-right:5px">
 
	
	<cfquery name="getDonor"
		datasource="AppsProgram" 
		username="#SESSION.login#"
		password="#SESSION.dbpw#">			
			SELECT Fund,ContributionClassName,OrgUnitName,
			       round(ISNULL(SUM(Contribution),0),0) as Contribution,
			       round(ISNULL(SUM(Correction),0),0) as Correction,
				   round(ISNULL(SUM(Alloted),0),0) as Allocated
			FROM   userQuery.dbo.#SESSION.acc#DonorStatus	
			WHERE  Contribution <> 0
			GROUP BY Fund,ContributionClassName,OrgUnitName
			ORDER BY Fund,ContributionClassName,OrgUnitName
	</cfquery>
	
	<cf_divscroll style="height:100%">
	
	<table width="99%" class="navigation_table">
	
	<tr class="labelmedium line">
	   <td colspan="2" style="padding-left:20px"><cf_tl id="Donor"></td>
	   <td align="right">Amount<br>A</td>
	   <td align="right">Correction<br>B</td>
	   <td align="right">Total<br>A+B</td>
	   <td align="right">Alloted<br>D</td>
	   <td align="right">Balance<br>A+B-D</td>
	</tr>
	
	<cfoutput query="getDonor" group="Fund">
		
		<cfoutput group="ContributionClassName">
		
			<cfquery name="getSummary"
				datasource="AppsProgram" 
				username="#SESSION.login#"
				password="#SESSION.dbpw#">			
				SELECT round(ISNULL(SUM(Contribution),0),0) as Contribution,
				       round(ISNULL(SUM(Correction),0),0) as Correction,
					   round(ISNULL(SUM(Alloted),0),0) as Allocated
				FROM   userQuery.dbo.#SESSION.acc#DonorStatus	
				WHERE  Contribution <> 0
				AND    Fund = '#Fund#' 
				AND    ContributionClassName = '#ContributionClassName#'			
			</cfquery>
			
			<cfif currentrow neq "1">
			
			<tr><td height="10"></td></tr>
			</cfif>
			
			<tr bgcolor="eaeaea" class="navigation_row labelmedium linedotted" style="border-top:1ps solid gray">
				<td style="height:40px;font-size:23px;padding-left:5px">#ContributionClassName#</td>
				<td>#Fund#</td>					
				<td align="right">#numberformat(getSummary.Contribution,',__')#</td>
				<td align="right">#numberformat(getSummary.Correction,',__')#</td>
				<td align="right">#numberformat(getSummary.Contribution+getSummary.Correction,',__')#</td>
				<td align="right">#numberformat(getSummary.Allocated,',__')#</td>
				<td align="right">#numberformat(getSummary.Contribution+getSummary.Correction-getSummary.Allocated,',__')#</td>		
			</tr>	
			
			<tr><td height="10"></td></tr>
			
			<cfoutput>
			
				<tr class="labelmedium line navigation_row">
			    <td style="padding-left:20px" colspan="2">#OrgUnitName#</td>
				<td align="right">#numberformat(Contribution,',__')#</td>
				<td align="right">#numberformat(Correction,',__')#</td>
				<td align="right">#numberformat(Contribution+Correction,',__')#</td>
				<td align="right">#numberformat(Allocated,',__')#</td>
				<td align="right">#numberformat(Contribution+Correction-Allocated,',__')#</td>	
				</tr>	
							
			</cfoutput>		
			
		</cfoutput>	
		
	</cfoutput>
	
	</table>
	
	</cf_divscroll>

</td></tr>
</table>

<cfset ajaxonload("doHighlight")>

