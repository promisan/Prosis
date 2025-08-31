<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfparam name="url.presentation" default="HTML">

<!--- validate status --->
<cfquery name="Requests" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM  	   RequestHeader H,
	           Request L	 
	WHERE      H.Mission          = L.Mission
	AND        H.Reference        = L.Reference
	AND        H.RequestHeaderId  = '#url.drillid#' 	
</cfquery>

<cfloop query="Requests">
   <cfif currentrow eq recordcount>
      <cf_setRequestStatus RequestId="#Requestid#">
   <cfelse>
	  <cf_setRequestStatus RequestId="#Requestid#" evaluateHeader="No">
   </cfif>	
</cfloop>	

<cfquery name="Header" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *, 
	         (SELECT ProgramName FROM Program.dbo.Program	WHERE ProgramCode = H.ProgramCode) as ProgramName,
			 (SELECT Description FROM Status S WHERE S.Status = H.ActionStatus AND Class = 'Header') as ActionStatusDescription,
			 (SELECT ListingGroup FROM Status S WHERE S.Status = H.ActionStatus AND Class = 'Header') as ListingGroup,
			 (SELECT Description FROM Ref_Category S WHERE S.Category = H.Category) as CategoryDescription,
			 (SELECT Description FROM Ref_ShipToMode S WHERE S.Code = H.RequestShipToMode) as ShipToModeDescription
	FROM     RequestHeader H
	WHERE    RequestHeaderid = '#url.drillid#'	
</cfquery>

<cfif Header.entityClass eq "">

	<cfquery name="set" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    UPDATE  RequestHeader
		SET     EntityClass     = W.EntityClass
		FROM    RequestHeader R, Ref_RequestWorkflow W
		WHERE   R.RequestType   = W.RequestType
		AND     R.RequestAction = W.RequestAction
		AND     R.RequestHeaderid = '#url.drillid#'
	</cfquery>
			
	<cfquery name="Header" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *,
		       (SELECT ProgramName FROM Program.dbo.Program	WHERE ProgramCode = H.ProgramCode) as ProgramName, 
			   (SELECT Description FROM Status S WHERE S.Status = H.ActionStatus AND Class = 'Header') as ActionStatusDescription,
			   (SELECT ListingGroup FROM Status S WHERE S.Status = H.ActionStatus AND Class = 'Header') as ListingGroup,
			   (SELECT Description FROM Ref_Category S WHERE S.Category = H.Category) as CategoryDescription,
			   (SELECT Description FROM Ref_ShipToMode S WHERE S.Code = H.RequestShipToMode) as ShipToModeDescription    
		FROM   RequestHeader H		
		WHERE  RequestHeaderid = '#url.drillid#'	
	</cfquery>
	
</cfif>	

<cfquery name="Org" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      Organization
	WHERE     OrgUnit = '#header.orgunit#'	
</cfquery>

<cfquery name="Parameter" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_ParameterMission
		WHERE  Mission = '#Header.Mission#'
</cfquery>

<!--- provision to print the request instead of opening it in the HTML mode --->

<cfinclude template="DocumentLinesViewScript.cfm">

<cfif url.presentation eq "PDF">

	 <cfif Parameter.RequisitionTemplateMultiple neq "">		  
		
		<cfoutput>						 
			<script>
				mail2multiple('print','#Header.Reference#','_top')
			</script>				    					   
		</cfoutput>
		
		<cfabort>
		
	</cfif>	

</cfif>

<cfquery name="Details" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT TOP 1 W.*
	FROM  	   RequestHeader H,
	           Request L,					  
			   Warehouse W		 
	WHERE      H.Mission          = L.Mission
	AND        H.Reference        = L.Reference
	AND        H.RequestHeaderId  = '#url.drillid#' 
	AND        L.ShipToWarehouse  = W.Warehouse	
	AND        L.RequestType != 'Pickticket' 
</cfquery>

 	<cf_tl id ="You entered an incorrect quantity" var = "1">

<script>
	
	function reqedit(id,qty) {	
	
		  if (parseFloat(qty) || qty == "0") {
		  
			   if (qty > "0" || qty == "0") {
			   	 ColdFusion.navigate('RequestEdit.cfm?id='+id+'&quantity='+qty,'amount_'+id)
			     } else {
				 alert("<cfoutput>#lt_text#</cfoutput> ("+qty+")")		 
				 }		  
		  
		  } else {
		  
		  	alert("<cfoutput>#lt_text#</cfoutput> ("+qty+")")		  
		  }
		      
	}
	
	function docancel(rid,aid) {
		ColdFusion.navigate('RequestEdit.cfm?id='+rid+'&action=cancel&ajaxid='+aid,'status_'+rid);	}

</script>

<cf_calendarscript>
<cf_dialogMaterial>
<cf_FileLibraryScript>
<cf_menuscript>
<cf_actionListingScript>
<cf_dialogmail>

<cfajaximport tags="cfdiv">

<!--- limit
 - the editing of the line after clearance
 - option to assign a line to a task order
 - associate a task order to a purchase order
 - show status of delivery 
--->

<cf_screentop height="100%" 
	  jQuery="Yes" 
	  html="Yes" 
	  line="no" 
	  label="Process Stock Request" 
	  scroll="vertical" 
	  systemmodule="Warehouse" 
	  functionclass="Window" 
	  functionName="Stockorder request" 
	  layout="webapp" 
	  menuAccess="Context">

<cfform method="POST" name="requestform">

	<table width="95%" cellspacing="0" cellpadding="0" align="center">
	
		<tr><td height="4"></td></tr>
	  		
		<cfoutput query="Header">	
				
		<tr><td width="17%" class="labelmedium"><cf_tl id="Request No">:</td>
				
		    <td colspan="1" width="25%">
						
			     <table cellspacing="0" cellpadding="0">
					   <tr>
					   <td class="labelmedium">#Reference#</a></td>
					   <td width="6"></td>
					   
					   <!--- not for the workflow mode --->			
					   
					    <cfif Parameter.RequisitionTemplateMultiple neq "">		  
					    <td>					   
						    <img src="#SESSION.root#/images/print_small5.gif" 
						    align="absmiddle" 
							style="cursor:pointer"
							alt="Print Request" 
							border="0" 
							onclick="mail2multiple('print','#Reference#')">
						</td>
						</cfif>
						
						</tr>
						
				 </table>
			
			</td>
			
			 <td width="100" class="labelmedium"><cf_tl id="eMail">:</td><td width="55%" class="labelmedium"><a href="javascript:email('#emailaddress#')"><font color="0080FF">#emailaddress#</a></td>
		</tr>	
				
		<tr>
			<td class="labelmedium"><cf_tl id="Usage">:</td>
			<td colspan="1" class="labelmedium"><cfif Category eq "">n/a<cfelse><font color="804040">#CategoryDescription#</cfif></font></td>		
			<td class="labelmedium"><cf_tl id="Project">:</td>
			<td colspan="1" class="labelmedium"><cfif ProgramName eq "">n/a<cfelse><font color="804040">#ProgramName#</cfif></font></td>		
		</tr>	
						
		<tr><td class="labelmedium"><cf_tl id="Contact">:</td><td class="labelmedium">#Contact#</td>
		    <td class="labelmedium"><cf_tl id="Ship by">:</td><td class="labelmedium"><cfif actionStatus lt "3"><cfif datedue lte now()><font color="FF0000"></cfif></cfif>#dateformat(datedue,CLIENT.DateFormatShow)#</b></td>
		</tr>
		<tr><td class="labelmedium"><cf_tl id="Request Type">:</td><td class="labelmedium">#RequestType#</td>
		    <td class="labelmedium"><cf_tl id="Facility">:</td><td class="labelmedium">#details.warehousename# #details.city#/#details.address# #Org.OrgUnitName#</td>
		</tr>		
		
		<tr>
			<td class="labelmedium"><cf_tl id="Shipping Mode">:</td>
			<td colspan="1">
			<table cellspacing="0" cellpadding="0">
			<tr>
			<td class="labelmedium" id="shiptomodename">#ShipToModeDescription#</td>
			<td class="labelmedium" style="padding-left:4px" id="shiptomode">
					
		        <!--- 
				
				<cfif actionstatus lt "3">		
			
				    <cfif RequestShipToMode eq "Deliver">
					
						<a href="javascript:ColdFusion.navigate('#SESSION.root#/warehouse/application/stockorder/request/create/setShipToMode.cfm?mission=#mission#&reference=#reference#&mode=Collect','shiptomode')">						
						<font color="808080">Set as [Collect]</font>
						</a>
						
					<cfelse>
					
						<a href="javascript:ColdFusion.navigate('#SESSION.root#/warehouse/application/stockorder/request/create/setShipToMode.cfm?mission=#mission#&reference=#reference#&mode=Deliver','shiptomode')">												
						<font color="808080">Set as [Deliver]</font>
						</a>
					
					</cfif>		
				
				</cfif>
				
				--->
				
			</td>
			</tr>
					
			</table>
			</td>	
							
			<td class="labelmedium"><cf_tl id="Status">:</td>			
			<cfif ActionStatus eq "9">
			<td class="labelmedium"><font color="FF0000">Cancelled</font></td>
			<cfelseif ActionStatus eq "5">
			<td class="labelmedium"><font color="green"><b>Completed</font></td>
			<cfelse>
			<td class="labelmedium">#ActionStatusDescription# <cfif ListingGroup neq "">#ListingGroup#</cfif></td>
			</cfif>	
			
		</tr>			
		
		<cfif remarks neq "">
		    <tr><td colspan="4" class="linedotted"></td></tr>
			<tr>
			<td class="labelmedium"><cf_tl id="Remarks">:</td>
			<td class="labelmedium" colspan="3"><font color="804040">#Remarks#</font></td>		
			</tr>
		</cfif>		
		
		<cfif address1 neq "">
			<tr>
			<td class="labelmedium"><cf_tl id="Instructions">:</td>
			<td class="labelmedium" colspan="3"><font color="804040">#Address1#</font></td>		
			</tr>
		</cfif>			
			
		</cfoutput>
		
		<tr><td colspan="4" class="linedotted"></td></tr>
							
		<tr><td colspan="4" id="requestlines" style="padding:0px">	
			<cfinclude template="DocumentLines.cfm">	
		</td></tr>
			
		
		<!--- workflow --->
					
		<cfif Header.entityClass neq "">
		
			<cfoutput>
			
			<input type="hidden" 
				name="workflowlink_#url.drillid#" 
				id="workflowlink_#url.drillid#"
				value="DocumentWorkflow.cfm">	
						
			<input type="hidden" 
			   name="workflowlinkprocess_#url.drillid#"
			   id="workflowlinkprocess_#url.drillid#" 
			   onclick="opener.document.getElementById('treerefresh').click();ColdFusion.navigate('DocumentLines.cfm?drillid=#url.drillid#','requestlines')">					
								
			<tr>
			<td id="#url.drillid#" colspan="4">	
			    <cfset url.ajaxid = url.drillid>			
				<cfinclude template="DocumentWorkflow.cfm">	
			</td>
			</tr>
			
			</cfoutput>	
			
		<cfelse>
		
		    <cfoutput>
		
			<tr>
			<td colspan="4" align="center">
			<font face="Verdana" size="2" color="FF0000"><cf_tl id="No workflow was defined for request type">: #Header.RequestType# <cf_tl id="and action">. <cf_tl id="Please contact your administrator to define a workflow"></font>
			</td>
			</tr>	
			
			</cfoutput>
		
		</cfif>
	
	</table>

</cfform>

<cf_screenbottom layout="webapp">