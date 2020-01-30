
<cfquery name="Edition" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT DISTINCT R.*
		FROM   ProgramAllotment P, Ref_AllotmentEdition R
		WHERE  P.EditionId = R.EditionId
		AND    P.ProgramCode IN (SELECT ProgramCode
		                         FROM   Program 
								 WHERE  Mission = '#url.Mission#')
		AND    P.Period = '#url.period#'			
</cfquery>
 
<cfif edition.recordcount eq "0">

	<input type="hidden" name="EditionId_#url.ln#" value="">
	<font color="FF0000">Record a Program Allotment for <cfoutput>#URL.Period#</cfoutput> first.</font>

<cfelse>
	
	<cfoutput>	
	
		<table cellspacing="0" cellpadding="0"><tr><td>
						   
		<select name="EditionId_#url.ln#" class="regularxl" style="width:180px">
		   <cfloop query="Edition">
		   <option value="#EditionId#" <cfif url.prior eq editionid>selected</cfif>>#EditionId# : #Description# <cfif Period neq ""> #Period#</cfif></option>
		   </cfloop>
		</select>	
		
		</td>
		
		<td style="padding-left:2px">
		
		<cfparam name="url.prioralt" default="">
								   
		<select name="EditionIdAlternate_#url.ln#" class="regularxl" style="width:180px">
		   <option value="">n/a</option>
		   <cfloop query="Edition">
		   <option value="#EditionId#" <cfif url.prioralt eq editionid>selected</cfif>>#EditionId# : #Description# <cfif Period neq ""> #Period#</cfif></option>
		   </cfloop>
		</select>	
		
		</td></tr></table>
	
	</cfoutput> 

</cfif>  			