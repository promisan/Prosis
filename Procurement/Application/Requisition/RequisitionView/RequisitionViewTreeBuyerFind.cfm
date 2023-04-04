

 <cfquery name="Result" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT TOP 10 *
	  FROM Job
	  WHERE 1=1 <!--- ActionStatus = '0' --->
	  AND   Mission = '#URL.Mission#'
	  <cfif getAdministrator(url.mission) eq "1">
			<!--- no filtering --->
	  <cfelse>
	  AND  JobNo IN (SELECT JobNo FROM JobActor WHERE ActorUserId = '#SESSION.acc#')
	  </cfif>
	  AND (
	  JobNo LIKE '%#url.val#%'
	  OR 
	  CaseNo LIKE '%#url.val#%'
	   OR 
	  Description LIKE '%#url.val#%'
	  OR
	  JobNo IN (SELECT  JobNo 
	            FROM    RequisitionLineQuote 
				WHERE   OrgUnitVendor IN (SELECT OrgUnit
	                                      FROM Organization.dbo.Organization 
										  WHERE OrgUnitName LIKE '%#url.val#%'
										 )
				)						  
	  )	  
</cfquery>

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/> 

<table width="96%" align="right" class="formpadding">
	<cfoutput query="result">
	<tr class="labelmedium2 linedotted">
	   <td>#currentrow#.</td>
	   <td><a href="RequisitionViewBuyerOpen.cfm?ID=JOB&ID1=#JobNo#&mid=#mid#" target="right" title="#Description#">#CaseNo# (#jobNo#)</a></td>
	</tr>
</cfoutput>
</table>