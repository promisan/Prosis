	<input type="hidden" name="class" id="class" value="1">
	
	<cfif tree eq "1">
	
	 <cfquery name="AccessList" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  R.Code, 
		        R.Description, 
				A.ClassParameter, 
				A.RecordStatus, 
				AccessLevel, 
				Number
		FROM    Ref_EntryClass R LEFT OUTER JOIN userQuery.dbo.#SESSION.acc#TreeAccess A
		   ON   R.Code = A.ClassParameter 
		<cfif Role.GrantAllTrees eq "0">
		AND     A.Mission = '#URL.Mission#'		
		</cfif>
		ORDER BY R.Code
		</cfquery>
	
	<cfelse>
	
  
		<cfquery name="AccessList" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT DISTINCT 
		         R.Code, 
				 R.Description,
		         A.ClassParameter, 
				 max(A.RecordStatus) as RecordStatus,
				 max(A.AccessLevel) as AccessLevel, 
				 count(*) as Number
		FROM     Ref_EntryClass R LEFT OUTER JOIN Organization.dbo.OrganizationAuthorization A
		  ON     R.Code = A.ClassParameter 
		  AND    A.AccessLevel < '8'
		  AND    (
		            (A.OrgUnit     = '#URL.ID2#') OR (A.OrgUnit is NULL and A.Mission = '#URL.Mission#') OR (A.OrgUnit is NULL and A.Mission is NULL)
				 )
		  AND    A.UserAccount = '#URL.ACC#' 
		  AND    A.Role        = '#URL.ID#'
		  
		WHERE    R.Code IN (SELECT EntryClass 
		                    FROM   Ref_ParameterMissionEntryClass 
							WHERE  Mission = '#url.mission#' 							
							AND    Operational = 1)
							
		GROUP BY R.Code, 
		         R.Description, 
				 A.ClassParameter
		ORDER BY R.Code		 
		</cfquery>
	
	</cfif>		
	
	<table width="100%" class="formpadding">
	<tr>
	<td height="20" class="labelmedium"><b>Procurement Entry Class</td>
	<cfinclude template="UserAccessSelectLabel.cfm">
	</tr>
	
	<tr><td colspan="<cfoutput>#No+2#</cfoutput>" class="linedotted"></td></tr>		
	
	<cfoutput query="AccessList">
	<input type="hidden" name="#ms#_classparameter_#CurrentRow#" id="#ms#_classparameter_#CurrentRow#" value="#Code#">
	<tr>
	  <td class="labelit" style="padding-left:5px">#Description# (#Code#)</td>
	   <cfset row = currentrow>		
	   <cfinclude template="UserAccessSelect.cfm">	 
	</tr>
	</cfoutput>
    </table>	
	
	<cfset class = AccessList.recordcount>