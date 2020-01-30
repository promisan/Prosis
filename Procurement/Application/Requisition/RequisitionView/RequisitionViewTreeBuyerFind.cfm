

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


<table width="96%" cellspacing="0" cellpadding="0" align="right" class="formpadding">
	<cfoutput query="result">
	<tr>
	   <td class="labelit">#currentrow#.</td>
	   <td class="labelit"><a href="RequisitionViewBuyerOpen.cfm?ID=JOB&ID1=#JobNo#" target="right" title="#Description#"><font color="2894FF">#CaseNo# (#jobNo#)</a></td>
	</tr>
</cfoutput>
</table>