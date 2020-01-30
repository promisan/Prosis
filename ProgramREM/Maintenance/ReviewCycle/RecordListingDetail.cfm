<cfparam name="url.fmission" default="">
<cfparam name="url.filter" default="active">

<cfquery name="SearchResult"
	datasource="appsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	R.*,
				ISNULL((SELECT COUNT(*) FROM Ref_ReviewCycleProfile WHERE CycleId = R.CycleId),0) as CountProfiles
		FROM 	Ref_ReviewCycle R
		WHERE	1=1
		<cfif url.fmission neq "">
			AND Mission = '#url.fmission#'
		</cfif>
		<cfif url.filter eq "active">
			AND	(DateExpiration >= '#dateformat(now(),'yyyy-mm-dd')#' OR DateExpiration IS NULL)
		</cfif>
		<cfif url.filter eq "expired">
			AND DateExpiration < '#dateformat(now(),'yyyy-mm-dd')#'
		</cfif>
		ORDER BY Mission ASC, Period, DateEffective DESC, DateExpiration DESC
</cfquery>

<table width="94%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding navigation_table">

<tr class="linedotted labelmedium">
    
	<TD align="left"></TD>
    <TD style="padding-left:14px" align="center" width="50px"><cf_tl id="Id"></TD>
	<TD align="left" style="padding-left:10px;"><cf_tl id="Period"></TD>
	<TD align="left"><cf_tl id="Description"></TD>
	<TD align="left"><cf_tl id="Effective"></TD>
	<TD align="left"><cf_tl id="Expiration"></TD>
	<TD align="left"><cf_tl id="Workflow Class"></TD>
	<TD align="center"><cf_tl id="Profiles"></TD>
	<TD align="center"><cf_tl id="Ope"></TD>
	
</TR>

<cfset vCols = 9>

<cfif SearchResult.recordCount eq 0>

	<tr><td height="25" class="labelit" colspan="<cfoutput>#vCols#</cfoutput>" align="center"><cf_tl id="No review cycles recorded"><cfif url.fmission neq ""><cf_tl id="for"><cfoutput>#url.fmission#</cfoutput></cfif></td></tr>
	<tr><td colspan="<cfoutput>#vCols#</cfoutput>" class="linedotted"></td></tr>
	
</cfif>

<cfoutput query="SearchResult" group="Mission">

	<tr><td colspan="#vCols#" class="labellarge" style="padding-bottom:1px;">#Mission#</td></tr>
			
		<cfoutput>
			    
		    <TR  class="labelmedium line navigation_row" bgcolor="" <cfif operational eq 0>style="font-style:italic; color:808080;"</cfif>> 
				
				<td align="center" style="padding-top:4px">
					<table cellspacing="0" cellpadding="0">
						<tr>
						    <td width="50%" style="padding-right:5px"><cf_img icon="edit" navigation="Yes" onclick="recordedit('#CycleId#');"></td>
							<td width="50%">
								<cfquery name="validate"
									datasource="appsProgram" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										SELECT 	*
										FROM 	ProgramPeriodReview
										WHERE	ReviewCycleId = '#CycleId#'								
								</cfquery>
								
								<cfif validate.recordCount eq 0>
									<cf_img icon="delete" onclick="recordpurge('#CycleId#','#url.fmission#');">
								</cfif>
							</td>
							
						</tr>
					</table>
				</td>
				<TD style="padding-left:5px" align="center">#CycleId#</TD>
				<TD style="padding-left:5px;">#Period#</TD>
				<TD>#Description#</TD>
				<TD>#Dateformat(DateEffective, "#CLIENT.DateFormatShow#")#</TD>
				<cfif DateExpiration neq "">
					<TD>
						#Dateformat(DateExpiration, "#CLIENT.DateFormatShow#")#
					</TD>
				<cfelse>
					<TD style="color:808080;">[Not defined]</TD>
				</cfif>	
				<td>#EntityClass#</td>
				<td align="center">#numberFormat(CountProfiles,",")#</td>
				<TD align="center">
					<cfif operational eq 1>
						Yes
					<cfelseif operational eq 0>
						<b>No</b>
					</cfif>
				</TD>
				
				
		    </TR>
	
		</cfoutput>
	
</cfoutput>

</table>

<cfset ajaxOnLoad("doHighlight")>