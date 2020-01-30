 <input type="hidden" name="class" id="class" value="1">
  
 <cfif tree eq "1">
	
	 <cfquery name="AccessList" 
		datasource="#Role.ParameterDataSource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  #Role.ParameterFieldValue# as Code, 
		        #Role.ParameterFieldDisplay# as Display, 
				A.ClassParameter, 
				A.RecordStatus,
				AccessLevel, Number
		FROM    #Role.ParameterTable# R LEFT OUTER JOIN userQuery.dbo.#SESSION.acc#TreeAccess A
		  ON    R.#Role.ParameterFieldValue# = A.ClassParameter 
		<cfif Role.GrantAllTrees eq "0">
		AND     A.Mission = '#URL.Mission#'		
		</cfif>
	</cfquery>
	
 <cfelse>
   
   <cfquery name="AccessList" 
		datasource="#Role.ParameterDataSource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT DISTINCT 
		         #Role.ParameterFieldValue# as Code, 
		         #Role.ParameterFieldDisplay# as Display,
				 A.ClassParameter, 
				 max(A.RecordStatus) as RecordStatus,
				 max(A.AccessLevel) as AccessLevel, 
				 count(*) as Number
		FROM     #Role.ParameterTable# R LEFT OUTER JOIN Organization.dbo.OrganizationAuthorization A
		  ON     R.#Role.ParameterFieldValue# = A.ClassParameter 
		  AND    A.AccessLevel < '8'
		  AND   ((A.OrgUnit     = '#URL.ID2#') 
			OR  (A.OrgUnit is NULL and A.Mission = '#URL.Mission#')
			OR  (A.OrgUnit is NULL and A.Mission is NULL))
		  AND    A.UserAccount = '#URL.Acc#' 
		  AND    A.Role        = '#URL.ID#'
		GROUP BY R.#Role.ParameterFieldValue#,
		         R.#Role.ParameterFieldDisplay#,
				 A.ClassParameter
	</cfquery>
	
</cfif>	
    
	<table width="100%">
	<tr>
	<td height="20"><b></td>
	<td></td>
	<cfinclude template="UserAccessSelectLabel.cfm">
	</tr>	
	<tr><td colspan="<cfoutput>#No+3#</cfoutput>" bgcolor="silver" height="1"></td></tr>	
	<cfoutput query="AccessList">
	<input type="hidden" name="#ms#_classparameter_#CurrentRow#" id="#ms#_classparameter_#CurrentRow#" value="#Code#">
	<tr>
	  <td>&nbsp;#Code#</td>
	  <td>#Display#</td>
	  <cfset row = currentrow>		
	  <cfinclude template="UserAccessSelect.cfm">
	</tr>
	</cfoutput>
    </table>
	
	<cfset class = AccessList.recordcount>