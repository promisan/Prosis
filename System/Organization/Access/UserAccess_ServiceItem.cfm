	<input type="hidden" name="class" id="class" value="1">
	
	<!--- check --->
	
	 <cfquery name="Check" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT Serviceitem 
			FROM   ServiceItemMission 
			WHERE  Mission = '#url.mission#' 
    </cfquery>			
	
	<cfif tree eq "1">
	
	 <cfquery name="AccessList" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  R.Code, 
		R.Description,
		        A.ClassParameter, 
				A.RecordStatus, 
				AccessLevel, Number
		FROM    ServiceItem R 
		        LEFT OUTER JOIN userQuery.dbo.#SESSION.acc#TreeAccess A  ON   R.Code = A.ClassParameter 				
		<cfif Role.GrantAllTrees eq "0">
		AND      A.Mission = '#URL.Mission#'		
		</cfif>
		WHERE    R.Operational = 1
		<cfif check.recordcount gte "1">		
		AND      R.Code IN (SELECT Serviceitem FROM ServiceItemMission WHERE Mission = '#url.mission#' and Operational = 1)
		</cfif>
		ORDER BY R.Code
		</cfquery>
	
	<cfelse>
  
		<cfquery name="AccessList" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT DISTINCT R.Code, R.Description,
		        A.ClassParameter, 
				max(A.AccessLevel) as AccessLevel, 
				max(A.RecordStatus) as RecordStatus,
				count(*) as Number
		FROM    ServiceItem R LEFT OUTER JOIN Organization.dbo.OrganizationAuthorization A
		   ON   R.Code = A.ClassParameter 
		  AND   A.AccessLevel < '8'
		  AND     ((A.OrgUnit     = '#URL.ID2#') 
			  OR (A.OrgUnit is NULL and A.Mission = '#URL.Mission#')
  			  OR (A.OrgUnit is NULL and A.Mission is NULL))
		  AND     A.UserAccount = '#URL.ACC#' 
		  AND     A.Role        = '#URL.ID#'
		 WHERE    R.Operational = 1
		 <cfif check.recordcount gte "1">		
		 AND      R.Code IN (SELECT Serviceitem FROM ServiceItemMission WHERE Mission = '#url.mission#' and Operational = 1)
		 </cfif>
	
		GROUP BY R.Code, A.ClassParameter, R.Description
		ORDER BY R.Code
		</cfquery>
	
	</cfif>		
	
	<table width="100%" class="navigation_table">
	<tr class="labelmedium line">
	<td height="20"><cf_tl id="Service Item"></td>
	<cfinclude template="UserAccessSelectLabel.cfm">
	</tr>		
	<cfoutput query="AccessList">
	<input type="hidden" name="#ms#_classparameter_#CurrentRow#" id="#ms#_classparameter_#CurrentRow#" value="#Code#">
	<tr style="height:22px;font-size:14px" class="navigation_row labelmedium">
	  <td style="height:22px">#Description# (#Code#)</td>
	  <cfset row = currentrow>		 
	  <cfinclude template="UserAccessSelect.cfm">	 
	</tr>
	</cfoutput>
    </table>
		
	<cfset class = #AccessList.recordcount#>