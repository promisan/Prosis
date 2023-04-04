         	
	<cfif tree eq "1">
	
	 	<cfquery name="AccessList" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT R.Code, R.Description,
		        A.ClassParameter,
				A.RecordStatus, 
				'Manual' as Source,
				AccessLevel, Number
		FROM    Ref_ProgramClass R LEFT OUTER JOIN userQuery.dbo.#SESSION.acc#TreeAccess A
		  ON    R.Code = A.ClassParameter 
		<cfif Role.GrantAllTrees eq "0">
		AND     A.Mission = '#URL.Mission#'	
		</cfif>
		
		</cfquery>
	
	<cfelse>
		
	   <cfquery name="AccessList" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT DISTINCT R.Code, R.Description, 
		                A.ClassParameter, 						
						max(A.AccessLevel) as AccessLevel, 
						max(A.RecordStatus) as RecordStatus,
						count(*) as Number
		FROM      Program.dbo.Ref_ProgramClass R LEFT OUTER JOIN OrganizationAuthorization A
		  ON      R.Code = A.ClassParameter 
		  AND     A.AccessLevel < '8'
		  AND     ((A.OrgUnit     = '#URL.ID2#') 
		    OR (A.OrgUnit is NULL and A.Mission = '#URL.Mission#')
		    OR (A.OrgUnit is NULL and A.Mission is NULL)) 
		  AND     A.UserAccount = '#URL.ACC#' 
		  AND     A.Role = '#URL.ID#'		
		GROUP BY R.Code, R.Description, A.ClassParameter				
		</cfquery>
	
	
	</cfif>
		
	<table width="95%" class="formpadding" align="center" cellspacing="0" cellpadding="0">
		    
			<tr class="labelmedium line">
			<td height="20"><cf_tl id="Class"></td>
			<cfinclude template="UserAccessSelectLabel.cfm">
			</tr>	
							
		<cfoutput query="AccessList" group="Code">
			
			<cfif source eq "Manual">
			<cfset cl = "ffffff">
			<cfelse>
			<cfset cl = "ffffcf">
			</cfif>
			
			<input type="hidden" name="#ms#_classparameter_#CurrentRow#" id="#ms#_classparameter_#CurrentRow#" value="#Code#">
			<tr class="labelmedium line" bgcolor="#cl#">
			  <td style="padding-left:4px">#Description#</td>	
			  <cfset row = currentrow>		
			  <cfinclude template="UserAccessSelect.cfm">		 
			</tr>
						
	    </cfoutput>
	</table>
	
	<cfset class = AccessList.recordcount>