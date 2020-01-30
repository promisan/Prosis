         	
	<cfif tree eq "1">
	
	 	<cfquery name="AccessList" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT R.PostType, 
			        A.ClassParameter,
					A.RecordStatus, 
					'Manual' as Source,
					AccessLevel, Number
			FROM    Ref_PostType R LEFT OUTER JOIN userQuery.dbo.#SESSION.acc#TreeAccess A
			  ON    R.PostType = A.ClassParameter 
			<cfif Role.GrantAllTrees eq "0">
			AND     A.Mission = '#URL.Mission#'	
			</cfif>
			ORDER BY R.PostType	
		</cfquery>
	
	<cfelse>
		
	   <cfquery name="AccessList" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT DISTINCT R.PostType, 
			                A.ClassParameter, 						
							max(A.AccessLevel) as AccessLevel, 
							max(A.RecordStatus) as RecordStatus,
							count(*) as Number
			FROM      Employee.dbo.Ref_PostType R LEFT OUTER JOIN OrganizationAuthorization A
			  ON      R.PostType = A.ClassParameter 
			  AND     A.AccessLevel < '8'
			  AND     ((A.OrgUnit     = '#URL.ID2#') 
			    OR (A.OrgUnit is NULL and A.Mission = '#URL.Mission#')
			    OR (A.OrgUnit is NULL and A.Mission is NULL)) 
			  AND     A.UserAccount = '#URL.ACC#' 
			  AND     A.Role = '#URL.ID#'		
			GROUP BY R.PostType, A.ClassParameter		
			ORDER BY R.PostType		
		</cfquery>	
	
	</cfif>
		
	<table width="95%" align="center" cellspacing="0" cellpadding="0" class="formpadding">
		    
		<tr>
			<td height="25" class="labelmedium"><cf_tl id="Post type"></td>
			<cfinclude template="UserAccessSelectLabel.cfm">
		</tr>	
				
		<cfoutput query="AccessList" group="PostType">
			
			<cfif source eq "Manual" or source eq "">
			   <cfset cl = "ffffff">
			<cfelse>
			   <cfset cl = "ffffcf">
			</cfif>
			
			<input type="hidden" name="#ms#_classparameter_#CurrentRow#" id="#ms#_classparameter_#CurrentRow#" value="#PostType#">
			<tr bgcolor="#cl#" class="labelmedium linedotted">
			  <td style="padding-left:4px">#PostType#</td>	
			  <cfset row = currentrow>		
			  <cfinclude template="UserAccessSelect.cfm">		 
			</tr>	
			
	    </cfoutput>
				
	</table>
	<cfset class = AccessList.recordcount>