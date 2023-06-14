
<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_ParameterMission
	WHERE Mission = '#URL.Mission#'
</cfquery>

<cfparam name="URL.role" default="">
<cfparam name="URL.Period" default="#Parameter.DefaultPeriod#">


	  
<cfset Criteria = ''>

<cfquery name="Mandate" 
	datasource="AppsOrganization" 	
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   TOP 1 *
		FROM     Ref_Mandate
		WHERE    Mission = '#url.Mission#'
		ORDER BY MandateDefault DESC		
</cfquery> 

<cfset URL.role = "TimeKeeper">

<cfinvoke component = "Service.Access"  
   method           = "RoleAccess" 
   mission          = "#url.mission#" 
   role             = "'HROfficer','HRAssistant','Timekeeper'"  <!---   role             = "'Timekeeper','HROfficer'"  --->
   accesslevel      = "2"
   returnvariable   = "accessextended">	   
   
        	
   <table width="100%" class="formpadding">
		
	  <tr>
	  
        <td style="padding-left:10px;padding-top:10px"> 
										
		    <cf_tl id="#url.mission# Commission" var="1">
												
			<cf_UItree name="idtree" fontsize="20" bold="No" format="html" required="No">
			
 		     <cf_UItreeitem
			  bind="cfc:service.Tree.OrganizationTree.getNodesV2({cftreeitempath},{cftreeitemvalue},'#url.mission#','#mandate.mandateno#','CommissionListing.cfm','ATT','#lt_text#')">
								  
		    </cf_UItree>				
			
			</td>
			
		</tr>			
			
   </table>		