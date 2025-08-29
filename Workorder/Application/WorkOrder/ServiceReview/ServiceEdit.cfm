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
<cfparam name="url.workorderid"   default="8B6A925C-1018-0668-4397-7C889F59FE61">

<cfif url.workordereventid eq "">
  <cfset url.workordereventid = "00000000-0000-0000-0000-000000000000">
</cfif>

<cfquery name="workorder" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM   WorkOrder
  WHERE  WorkOrderId = '#URL.workorderId#'
</cfquery>

<cfquery name="Parameter" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_ParameterMission
	WHERE Mission = '#WorkOrder.Mission#'	
</cfquery>

<cfquery name="Mission" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_Mission
	WHERE Mission = '#WorkOrder.Mission#'	
</cfquery>

<cfquery name="Get" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM   WorkOrderEvent
  WHERE  WorkOrderEventId = '#URL.WorkOrderEventId#'
</cfquery>

<cfquery name="GetObject" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM   OrganizationObject
  WHERE  ObjectKeyValue4 = '#URL.WorkOrderEventId#'
</cfquery>
		
<cfquery name="WrkClass" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	SELECT   DISTINCT R.*
	FROM     Ref_EntityClassPublish P, Ref_EntityClass R
	WHERE    R.EntityCode  = 'WrkEvent'
	AND      P.EntityCode  = R.EntityCode
	AND      P.EntityClass = R.EntityClass
	
	AND     
         (
		 
          R.EntityClass IN (SELECT EntityClass 
                            FROM   Ref_EntityClassOwner 
						    WHERE  EntityCode = 'WrkEvent'
						    AND    EntityClass = R.EntityClass
						    AND    EntityClassOwner = '#Mission.MissionOwner#')
						   
		 OR
		
		  R.EntityClass NOT IN (SELECT EntityClass 
                                FROM   Ref_EntityClassOwner 
						        WHERE  EntityCode = 'WrkEvent'
						        AND    EntityClass = R.EntityClass)							   
		 )			
		
</cfquery>

<!--- Automatically generate the reference Number if is a new entry--->
<cfif get.recordcount eq "0">

	<cfquery name="GetReference" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT TOP 1 convert(int,right(eventreference,charindex('-',reverse(eventreference))-1)) as MaxRef
	  FROM   WorkOrderEvent
	  WHERE  WorkOrderId = '#URL.workorderId#'
	  AND EventReference LIKE '#workorder.ServiceItem#-#year(now())#-%'
	  ORDER BY EventReference DESC
	</cfquery>
	
	<cfif GetReference.recordcount eq "0">
		<cfset sReference = workorder.ServiceItem & "-" & year(now()) & "-001">
	<cfelse>
		<cfset sReference = workorder.ServiceItem & "-" & year(now()) & "-" & NumberFormat(GetReference.MaxRef + 1, "009")>
	</cfif>
<cfelse>
	<cfset sReference = Get.EventReference>
</cfif>

<cf_screentop label  = "Workorder Event" 
              title   = "Workorder Event"              
			  banner = "gray" 		
			  html="no"
			  close  = "parent.ColdFusion.Window.destroy('mydialog',true)"	
			  layout = "webapp">

<cfform action="ServiceEditSubmit.cfm?workorderid=#url.workorderid#&tabno=#url.tabno#" name="eventform" method="POST" target="process">

<table width="700" class="formpadding" align="center">

    <tr class="hide">
	   <td colspan="2"><iframe name="process" id="process" width="100%" height="100"></iframe></td>
	</tr>
	
    <tr><td height="4"></td></tr>

    <cfif get.recordcount eq "0">
			
		<cf_assignid>							
		<cfoutput>
		<input type="hidden" name="WorkOrderEventId" id="WorkOrderEventId" value="#rowguid#">
		</cfoutput>
		<cfset url.transactionid = rowguid>
				
	<cfelse>
	    <cfoutput>
		<input type="hidden" name="WorkOrderEventId" id="WorkOrderEventId" value="#url.workordereventid#">
		</cfoutput>
	
	</cfif>			
	
	<tr><td heifght="4"></td></tr>
	
	<tr>
	
		<td class="labelmedium"><cf_tl id="Event Reference">:</td>	 
	    <td>				   
	  		 <cfinput type="text" 
	         name="EventReference" 
			 size="1" 							 								
			 class="regularxxl" 
			 style="width:150" 
			 maxLength="20"
			 visible="Yes" 
			 value="#sReference#"
			 enabled="Yes">	
		 </td>		 
	</tr>	
	
	
	<cf_calendarscript>
	
	<tr>
	
	  <td class="labelmedium"><cf_tl id="Effective">:</td>			   
	   <td>			  				   
				   					   				
		    <cf_intelliCalendarDate9
			FieldName="DateEffective" 					
			Default="#Dateformat(get.EventDate, CLIENT.DateFormatShow)#"	
			class="regularxxl"	
			AllowBlank="False">	
				
	   </td>
	  </tr> 
	  

	  
	  <tr>
	
	  <td class="labelmedium"><cf_tl id="Approval flow">:</td>			   
	  <td class="labelmedium">			 
	  	  	  
		<cfif WrkClass.recordcount gte "1">
		
		    <select name="EntityClass" id="EntityClass" class="regularxxl">
			    <cfoutput query="WrkClass">
					<option value="#EntityClass#" <cfif getObject.EntityClass eq EntityClass>selected</cfif>>#EntityClassName#</option>
				</cfoutput>
		    </select>
			
		<cfelse>	
						
			<font color="FF0000"><cf_tl id="Workflow not configured"></font>	
				
		</cfif>	
		
		</td>
		
	</tr>		
				  
	<cfif WrkClass.recordcount gte "1">
		
	 <tr><td colspan="2" align="center" height="30">
	 	  <cfoutput>
		  	 <cf_tl id="Save" var="vSave">			 
		     <input type="submit" id="save" name="save" value="#vSave#" class="button10s" style="height:23;width:120px">
		 </cfoutput>
		 </td>
	 </tr>
	 
	 </cfif>
	  
</table>
	
</cfform>

<cf_screenbottom layout="webapp">