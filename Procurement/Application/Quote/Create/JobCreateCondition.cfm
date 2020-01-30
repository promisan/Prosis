
<cfoutput>

<cfquery name="Requisition" 
 datasource="AppsPurchase" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
   SELECT    *
   FROM      RequisitionLine L, Organization.dbo.Organization Org, ItemMaster I
   WHERE     L.ActionStatus = '2k' 
	AND      L.OrgUnit = Org.OrgUnit
	AND      L.ItemMaster = I.Code
	AND      (L.JobNo is NULL OR L.JobNo = '') 
	<cfif getAdministrator(url.mission) eq "1">
	
	   <!--- no filter --->
	   
	<cfelse>
		
	AND       (L.RequisitionNo IN (SELECT RequisitionNo
	                            FROM RequisitionLineActor							
								WHERE ActorUserId = '#SESSION.acc#')
				OR
				
			   I.EntryClass IN (
				 SELECT DISTINCT ClassParameter 
				 FROM   Organization.dbo.OrganizationAuthorization 
				 WHERE  Role           = 'ProcManager'
				 AND    UserAccount    = '#SESSION.acc#'
				 AND    (OrgUnit = L.OrgUnit or Mission = '#url.mission#')
				 AND    ClassParameter = I.EntryClass				
				 AND    AccessLevel IN ('1','2'))	
				
			)
    								
	</cfif>								
	AND       L.Period    = '#URL.Period#'	
	AND       Org.Mission = '#URL.Mission#'		 		
 </cfquery>
 	
 <cfif Requisition.recordcount gt "0">
		
	<tr>     
      <td class="labelmedium" style="font-size:16px;height:35px;padding-left:5px">
	  <a href="javascript: ProcBuyerJob('#URL.Mission#','#URL.Period#')"><cf_tl id="New Requests for your action">(#requisition.recordcount#)</a></td>
    </tr>
	
 <cfelse>
 	
   <tr>     
      <td colspan="2" align="center" style="height:25px" class="labelmedium"><font color="gray">No pending requests for #URL.Period#</td>
    </tr>
 		
	
 </cfif> 
 
</cfoutput>