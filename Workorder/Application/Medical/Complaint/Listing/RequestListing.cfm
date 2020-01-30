


<!---
trigger a listing script for the pending requests to be processes != 3 
--->

<cf_screentop jquery="yes" html="no">

<cf_ActionListingScript>

<script>
 function medicalopen(actionid) {
     ptoken.open('#session.root#/WorkOrder/Application/Medical/Encounter/DocumentView.cfm?drillid='+actionid,'_blank')
 }
</script>
	
<!--- listing of receipts will drill down to receipt dialog --->

 <cf_LanguageInput
		TableCode       = "Ref_ModuleControl" 
		Mode            = "get"
		Name            = "FunctionName"
		Key1Value       = "#url.idmenu#"				
		Label           = "Yes">			
			
<cfparam name="lt_content" default="Pending Requests">

<table width="100%" height="100%">
	
	<!--- control list data content --->
	
	<cfquery name="Param" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
		FROM   Ref_ParameterMission
		WHERE  Mission = '#url.Mission#'	
	</cfquery>
	
   <tr>

   <td colspan="1" height="100%" valign="top">
		<cfdiv id="divListingContainer" style="height:100%" bind="url:#session.root#/Workorder/Application/Medical/Complaint/Listing/RequestListingContent.cfm?mission=#url.mission#&SystemFunctionId=#url.systemfunctionid#">        	
	</td>	
	
   </tr>
   
<!---   
   		<tr class="labelmedium">
   			<td></td>
   			<td></td>
			<td><cf_tl id="Request Date"></td>
			<td><cf_tl id="Patient"></td>
			<td><cf_tl id="Type"></td>
			<td><cf_tl id="Reference"></td>
			<td><cf_tl id="Service"></td>
			<td><cf_tl id="Class"></td>		
		</tr>
   
	<cfquery name="Requests" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  R.RequestId, 
				R.RequestDate, 
				C.CustomerName, 
				R.ServiceDomain, 
				R.DomainReference, 
				RL.ServiceItem, 
				S.Description, 
				R.ServiceDomainClass, 
                X.Description AS DomainClass
		FROM   Request AS R INNER JOIN
               Customer AS C ON R.CustomerId = C.CustomerId INNER JOIN
               RequestLine AS RL ON R.RequestId = RL.RequestId INNER JOIN
               ServiceItem AS S ON RL.ServiceItem = S.Code INNER JOIN
               Ref_ServiceItemDomainClass AS X ON R.ServiceDomain = X.ServiceDomain AND R.ServiceDomainClass = X.Code
		WHERE   R.Mission = '#url.Mission#' 
		AND R.RequestId NOT IN
                          (SELECT     RequestId
                            FROM          RequestWorkOrder
                            WHERE      RequestId = R.RequestId)
        AND R.ActionStatus <> '9'
                         	
		</cfquery>	
				
		<cfoutput query="Requests">
		
		    <tr><td height="4"></td></tr>
	
			<tr bgcolor="f1f1f1" class="labelmedium line" style="height:27px;border-top:1px solid silver;bordr-bottom:1px solid silver">
				<td height="23" style="padding-left:4px">#currentrow#.</td>			
				
			<td style="cursor:pointer" 
			    onclick="workflowrequest('#requestid#','box_#requestid#')" align="center">
				
				<cf_space spaces="3">
				
				<!--- check for active workflow --->  
			    <cf_wfActive entitycode="WrkRequest" objectkeyvalue4="#requestid#">	
				
				<!--- check if workflow exists and if its status is pending
				      in case of pending we show the workflow  --->
				
				<cfif wfExist eq "1">
					
					<cfif wfstatus eq "open">
						<cfset cl = "hide">
						<cfset ex = "regular">
					<cfelse>	
						<cfset cl = "regular">
						<cfset ex = "hide">	
					</cfif>	
					
					<img id="exp#requestid#" 
						     class="#cl#" 
							 src="#SESSION.root#/Images/arrowright.gif" 
							 align="absmiddle" 
							 alt="Expand" 
							 height="9"
							 width="7"			
							 border="0"> 	
										 
					<img id="col#requestid#" 
						     class="#ex#" 
							 src="#SESSION.root#/Images/arrowdown.gif" 
							 align="absmiddle" 
							 height="10"
							 width="9"
							 alt="Hide" 			
							 border="0"> 
					
				 </cfif>	
						
			</td>				
				
			    <td style="padding-left:4px">#dateformat(Requests.RequestDate,client.dateformatshow)#</td>
			    <td>#Requests.CustomerName#</td>
				<td>#Requests.ServiceDomain#</td>
				<td>#Requests.DomainReference#</td>
				<td>#Requests.Description#</td>
				<td>#Requests.DomainClass#</td>								
			</tr>		
			
			<tr><td height="4"></td></tr>	
			
			
			<cfset url.embed = "yes">

						
			<tr id="box_#requestid#" class="#ex#">
				<td></td>
			  <td colspan="6" height="10" style="border-bottom:1px solid silver;padding-left:0px;padding-right:0px">	
			     <!--- access is controlled already --->
			     <cfset url.header = "No">			    
			     <cfset url.ajaxid = Requests.RequestId>
			     <cfinclude template="RequestListingContent.cfm">
			  </td>
			</tr>				
			<tr><td height="7"></td></tr>			
			
					
		</cfoutput>   
  

</table>		
		

--->
	
