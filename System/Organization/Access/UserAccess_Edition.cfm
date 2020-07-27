	<input type="hidden" name="class" id="class" value="1">
			
	<cfif tree eq "1">
		
		 <cfquery name="AccessList" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT  R.EditionId as Code, R.Period, R.Description, A.ClassParameter, A.RecordStatus, 
					AccessLevel, Number
			FROM    Ref_AllotmentEdition R LEFT OUTER JOIN userQuery.dbo.#SESSION.acc#TreeAccess A 
					ON Convert(VARCHAR(20),R.EditionId) = A.ClassParameter
					<cfif Role.GrantAllTrees eq "0">
					AND     A.Mission = '#URL.Mission#'		
					</cfif>
			WHERE   R.Mission = '#URL.Mission#'		
			ORDER BY R.Period
			</cfquery>		
		
	<cfelse>
        
		<cfquery name="AccessList" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT DISTINCT 
		        R.EditionId as Code, 
				R.Period,R.Description, 
		        A.ClassParameter, 
				MAX(A.RecordStatus) as RecordStatus,
				MAX(A.AccessLevel) as AccessLevel, 
				count(*) as Number
		FROM    Ref_AllotmentEdition R LEFT OUTER JOIN Organization.dbo.OrganizationAuthorization A
		  ON    Convert(VARCHAR(20),R.EditionId) = A.ClassParameter 
		  AND     A.AccessLevel < '8'
		  AND     (
		            (A.OrgUnit     = '#URL.ID2#') OR (A.OrgUnit is NULL and A.Mission = '#URL.Mission#') OR (A.OrgUnit is NULL and A.Mission is NULL)
				  )
		  AND     A.UserAccount = '#URL.ACC#' 
		  AND     A.Role        = '#URL.ID#'
		WHERE    R.Mission = '#URL.Mission#'	 
		GROUP BY R.Period, R.EditionId, A.ClassParameter,R.Description
		ORDER BY R.Period
		</cfquery>
	
	</cfif>	
	
	<table width="100%" class="formpadding">
	<tr  class="labelmedium line fixrow">
	<td height="20"><cf_tl id="Period"></td>
	<td height="20"><cf_tl id="Edition"></td>
	<cfinclude template="UserAccessSelectLabel.cfm">
	</tr>
	
	<cfset pr = "">
	
	<cfoutput query="AccessList" group="period">
	
	<cfoutput>
	<input type="hidden" name="#ms#_classparameter_#CurrentRow#" id="#ms#_classparameter_#CurrentRow#" value="#Code#">
	<tr class="line labelmedium">
	  <td style="padding-left:3px" height="20"><cfif pr neq period><cfif period neq "">#Period#<cfelse>(all)</cfif></cfif></td>
	  <td style="padding-left:3px" class="labelit">#Code# #Description#</td>
	  <cfset row = currentrow>		
	   <cfinclude template="UserAccessSelect.cfm">	 
	</tr>
	<cfset pr = period>
	</cfoutput>
	</cfoutput>
    </table>
		
	<cfset class = AccessList.recordcount>