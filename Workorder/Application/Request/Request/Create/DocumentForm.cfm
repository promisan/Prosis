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
<cfparam name="url.mission"       default="OICT">
<cfparam name="url.drillid"       default="">
<cfparam name="url.requestid"     default="#url.drillid#">
<cfparam name="url.requestline"   default="1">
<cfparam name="url.workorderid"   default="">
<cfparam name="url.workorderline" default="">
<cfparam name="url.domain"        default="">
<cfparam name="url.status"        default="">
<cfparam name="url.accessmode"    default="view">

<!--- incorrect ajax link --->
<cfif url.workorderid eq "undefined">
    <cfset url.workorderid = "">
</cfif>

<cfquery name="ServiceItem" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   ServiceItem
	WHERE  Code IN (SELECT Code 
	                FROM   ServiceItemMission
	                WHERE  Mission = '#url.mission#')
	<cfif url.domain neq "">		
	AND    ServiceDomain = '#url.domain#'		
	</cfif>				
	AND    Operational = 1
</cfquery>

<cfquery name="Domain" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ServiceItemDomain
	WHERE  Code = '#url.domain#'			
</cfquery>

<cfif ServiceItem.recordcount eq "0" and url.requestid eq "">

	<table width="100%"><tr><td height="50" align="center" class="labelmedium">Sorry no service items can be requested for this service domain</b></td></tr></table>
	<cfabort>
	
</cfif>

<cfquery name="Request" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   Request
	<cfif url.requestid eq "">
	WHERE 1=0
	<cfelse>
	WHERE  Requestid = '#url.requestid#'
	</cfif>		
</cfquery>

<cfif Request.recordcount eq "0">
	 <cfset url.requestid = "">
</cfif>

<cfif url.requestid neq "">
	<cfset rowguid = url.requestid>	
<cfelse>
    <cf_assignid>	    
</cfif>  

<cfquery name="Parameter" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ParameterMission
	WHERE Mission = '#url.mission#'	
</cfquery>

<cfquery name="RequestLine" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT ValueFrom as Serviceitem
		FROM   RequestWorkorderDetail
		WHERE  Amendment = 'ServiceItem'
		<cfif url.requestid eq "">
		AND 1=0
		<cfelse>
		AND  Requestid   = '#url.requestid#'
		</cfif>		
</cfquery>

<cfif RequestLine.recordcount eq "0">

	<!--- this should not occur --->
	
	<cfquery name="RequestLine" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   RequestLine
		<cfif url.requestid eq "">
		WHERE 1=0
		<cfelse>
		WHERE  Requestid   = '#url.requestid#'
		AND    RequestLine = '#url.requestline#'
		</cfif>				
	</cfquery>

</cfif>

<cfif RequestLine.recordcount gte "1">
		
	<cfquery name="Check" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   ServiceItem
		WHERE  Code = '#RequestLine.ServiceItem#'	
	</cfquery>
	
	<cfset url.domain = check.servicedomain>

</cfif> 

<cfoutput>

<cfset accessmode = url.accessmode>

<cfif url.requestid eq "">
    <!--- new entry --->
  	<cfset accessmode = "Edit">	
<cfelseif request.actionstatus eq "0">	
    <!--- draft status --->
    <cfset accessmode = "Edit">
<cfelseif request.actionstatus eq "1">		
     <!--- in clearance status --->
     <cfset accessmode = "Edit">
<cfelseif request.actionstatus eq "2">	
     <!--- cleared and apllied --->	
     <cfset accessmode = "View">	 
<cfelseif request.actionstatus eq "3">
    <!--- completed, never allow for edit --->	 
	<cfset accessmode = "View">
</cfif>

<cfif accessmode eq "edit">
	<cfset ht = "22">
<cfelse>
    <cfset ht = "20">
</cfif>

<cfform method="POST" name="requestform">

<cfoutput>
    <!--- field for caputuring the selected workorderline --->
	<input type="hidden" name="workorderlineid" id="workorderlineid"  value="">		
	<input type="hidden" name="servicedomain"   id="servicedomain"    value="#url.domain#">			
</cfoutput>

<table width="95%" class="formpadding" cellspacing="0" cellpadding="0" align="center">

<!---
<tr><td colspan="4" style="padding-top:6px"><font face="Calibri" size="4">Requester Information</td></tr>
<tr><td colspan="4" class="line"></td></tr>
--->
<tr><td colspan="4" height="3"></td></tr>

<cfif Request.Reference neq "" or url.scope eq "BackOffice">

<tr>
	<td class="labelmedium"><cf_UIToolTip tooltip="The externally assigned reference for this request"><cf_space spaces="40"><font color="808080">Reference:</cf_UIToolTip></td>
	
	<td height="#ht#" width="90%">
	
	 <table cellspacing="0" cellpadding="0">
		
	 <cfif accessmode eq "view">
	 
	    <tr>
		    <td height="17" class="labelmedium">
		    	<cfif Request.Reference eq "">N/A<cfelse>#Request.Reference#</cfif>		
			</td>
			
			<td id="statusbox" align="right" style="padding-left:4px" class="labelmedium">
		
		    <cfif Request.ActionStatus neq "">
			
				<cfquery name="Status" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT *
					FROM   Ref_EntityStatus
					WHERE  EntityCode  = 'wrkRequest'
					AND    EntityStatus = '#Request.ActionStatus#'
				</cfquery>
			
				<cfif     status.entitystatus eq "0"><font color="808080">
				<cfelseif status.entitystatus eq "9"><font color="FF0000">
				</cfif>
								
				<cfif status.statusdescription eq "">
					<font color="green"><cf_tl id="Draft"></font>
				<cfelse>
				    #Status.StatusDescription# on: #dateformat(request.created,CLIENT.DateFormatShow)# #timeformat(request.created,"HH:MM")#
				</cfif>
				
			</cfif>
			
	       </td>
		   
		 </tr>  
				
	 <cfelse>
	 	 
		 <cfif url.scope eq "BackOffice">
					  
		   <tr>
		 
		     <td height="17">
		  
			     <input type      = "text" 
				        class     = "regularxl" 
						name      = "Reference" 
						id        = "Reference" 
						value     = "#Request.Reference#" 
						size      = "20" 
						maxlength = "20">
			  
			 </td>
			 
			 <td id="statusbox" class="labelmedium" align="right" style="padding-left:10px">
		
				    <cfif Request.ActionStatus neq "">
					
						<cfquery name="Status" 
							datasource="AppsOrganization" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT *
								FROM   Ref_EntityStatus
								WHERE  EntityCode   = 'wrkRequest'
								AND    EntityStatus = '#Request.ActionStatus#'
						</cfquery>
					
						<cfif status.entitystatus eq "0">
						     <font color="808080">
						<cfelseif status.entitystatus eq "9">
						     <font color="FF0000">
						</cfif>
						
						<cfif status.statusdescription eq "">
						     <font color="green"><cf_tl id="Draft">
						<cfelse>
						     #Status.StatusDescription# ts: #dateformat(request.created,'DD/MM')# #timeformat(request.created,"HH:MM")#
						</cfif>
						
					</cfif>
					
			   </td>
			   
			 </tr>  
			 	 
	      </cfif>	 
		
	 </cfif>
	 	 
	</table>	 
	 	
	</td>
	
	<cfif url.scope eq "backoffice">	

		<td style="padding-right:6px;min-width:80px" class="labelmedium"><cf_UIToolTip tooltip="The date of the request"><cf_tl id="Date">:</cf_UIToolTip></td>
		<td height="#ht#" class="labelmedium">
		
		 <cfif accessmode eq "view">
			 	
			 #Dateformat(Request.RequestDate, CLIENT.DateFormatShow)#
		 
		 <cfelse>
		  
				 <cfif request.RequestDate eq "">
												
					  <cf_intelliCalendarDate9
						FieldName  = "RequestDate"
						Manual     = "True"	
						Class      = "regularxl"	
						ToolTip    = "Request Effective Date" 				
						Default    = "#Dateformat(now(), CLIENT.DateFormatShow)#"
						DateValidStart = "#Dateformat(now()-50, 'YYYYMMDD')#"				
						AllowBlank = "False">	
					
				 <cfelse>
				 
					  <cf_intelliCalendarDate9
						FieldName="RequestDate"
						Manual="True"	
						Class="regularxl"	
						ToolTip="Request Effective Date" 				
						Default="#Dateformat(Request.RequestDate, CLIENT.DateFormatShow)#"
						DateValidStart="#Dateformat(now()-50, 'YYYYMMDD')#"				
						AllowBlank="False">	
				 
				 </cfif>	
				
		 </cfif>	 
		 
		 </td>
	 
	 <cfelse>
	 
		 <!--- portal and it will take the default date --->
	
	 </cfif>	 
	
</tr>

</cfif>


<tr>
	<td height="#ht#" style="width:120" class="labelmedium">
	<cf_UIToolTip tooltip="The person who or on whose authority this request is submitted. This is not the same as the envisioned assigned service holder (user)"><font color="808080"><cf_tl id="Requester">:</cf_UIToolTip>
	<cf_space spaces="64">
	</td>
	
	<td style="padding:0px" height="#ht#">
					
		<cfset link = "getPerson.cfm?requestid=#url.requestid#&field=PersonNo">	
				
		<table cellspacing="0" cellpadding="0" width="96%">
			<tr>
			
			<cfif accessmode eq "Edit">
							
				<td>
					
				   <cf_selectlookup
					    box        = "employee"
						link       = "#link#"
						button     = "Yes"
						close      = "Yes"						
						icon       = "search.png"
						iconheight = "25"
						iconwidth  = "26"
						class      = "employee"
						des1       = "PersonNo">
						
				</td>	
											
				<td width="50%">
				
				<cfif url.requestid eq "">
					<cfdiv bind="url:#link#&PersonNo=#client.personno#"  id="employee"/>
				<cfelse>
					<cfdiv bind="url:#link#&PersonNo=#Request.personNo#" id="employee"/>
				</cfif>
				</td>
				
				
				<td width="50%"></td>
				
			<cfelse>
			
				<td style="border-right:0px solid gray" class="labelmedium">
				
					<cfquery name="Person" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT *
						FROM   Person
						WHERE  PersonNo = '#Request.personNo#'	
					</cfquery>					
					
					<a href="javascript:EditPerson('#Person.PersonNo#')">
					<font color="6688aa">#Person.FirstName#&nbsp;#Person.LastName#</font>
					</a>(#Request.eMailAddress#)
								
				</td>
							
			</cfif>			
			
			</tr>
		</table>
		
	</td>

	<cfif accessmode eq "Edit">

	<td width="30%" class="labelmedium" style="min-width:80px;padding-right:6px"><cf_tl id="eMail">:<font color="FF0000">*</font></td>
	<td class="labelmedium" height="#ht#" style="padding-right:35px">
		
		<cfif Request.eMailAddress eq "">
			<cfset mail = client.eMail>
		<cfelse>
		    <cfset mail = Request.eMailAddress>
		</cfif>
	
		<cfinput type="text" 
		  class="regularxl" 
		  validate="email" 
		  name="eMailAddress"  
		  required="Yes" 
		  value="#mail#" 
		  size="30" 
		  maxlength="40">
		
	</td>

	</cfif>

</tr>	

<!--- ----------------------------------------- --->
<!--- check if access is processor or requester --->
<!--- ----------------------------------------- --->

<cfinvoke component = "Service.Access"  
   method           = "WorkOrderProcessor" 
   mission          = "#url.mission#"  
   servicedomain    = "#url.domain#"
   returnvariable   = "access">   
   
<cfif access eq "NONE">

	<!--- user is a requester --->

	<tr>
		<td class="labelmedium" style="width:20%" height="#ht#"><font color="808080"><cf_tl id="Unit">:</td>
		<td height="#ht#" class="labelmedium">

			<cfif accessmode eq "Edit">
			
				<cfquery name="Org" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT *
						FROM   Organization
						WHERE Mission = '#Parameter.TreeCustomer#'
												
						<cfif getAdministrator(url.mission) eq "1">
	
						<!--- no filtering --->
						
						<cfelse>
						
						AND  OrgUnit IN (
					                SELECT OrgUnit 
					                FROM   Organization.dbo.Organization
									WHERE  Mission = '#Parameter.TreeCustomer#'
									AND    (
									        OrgUnit IN (
									                    SELECT OrgUnit
									                    FROM   Organization.dbo.OrganizationAuthorization
														WHERE  UserAccount = '#SESSION.acc#'
														AND    Mission     = '#parameter.treecustomer#'
														AND    Role = 'ServiceRequester'
													  )	
											OR
											
											Mission IN 	(
									                    SELECT DISTINCT Mission
									                    FROM   Organization.dbo.OrganizationAuthorization
														WHERE  UserAccount = '#SESSION.acc#'
														AND    Role        = 'ServiceRequester'
														AND    Mission     = '#parameter.treecustomer#'
														<!--- global access --->
														AND    (OrgUnit = '0' or OrgUnit is NULL)
													  )		  
					 		               )	
										   
								)		
											
						</cfif>		
								
					</cfquery>		
					
					<!--- change will trigger the service item to be resetted --->			
								
					<select name="orgunit" id="orgunit" class="regularxl">
					<cfloop query="org">
					<option value="#OrgUnit#" <cfif Request.orgunit eq orgunit>selected</cfif>>#OrgUnitName#</option>
					</cfloop>
					</select>
					
					</td>			
			
			<cfelse>
			
				<cfquery name="Org" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT *
						FROM   Organization
						WHERE  OrgUnit = '#Request.orgunit#'			
					</cfquery>				
					#Org.OrgUnitName# [#Org.OrgunitCode#]
					
					</td>			
			
			</cfif>

<cfelse>  

	<!--- access to all ---> 

	<tr>
		<td style="width:24%" class="labelmedium" height="#ht#"><font color="808080"><cf_tl id="Unit">:</td>
		<td colspan="3" height="#ht#" class="labelmedium">
											
			<cfset link = "getUnit.cfm?requestid=#url.requestid#">	
			
			<table cellspacing="0" cellpadding="0" width="96%">
				<tr>
				
				<cfif accessmode eq "Edit">
				
					<td width="20" style="padding-left:2px">					
										
					   <cf_selectlookup
						    box          = "unit"
							link         = "#link#"
							button       = "No"
							title        = ""
							close        = "Yes"		
							filter1      = "Mission"
							filter1value = "#Parameter.TreeCustomer#"	
							filter2      = "Workorder"		
							iconheight   = "25"
							iconwidth    = "26"										
							icon         = "search.png"
							class        = "organization"
							des1         = "OrgUnit">
							
					</td>	
					<td width="2"></td>
					<td width="99%" height="100%" style="padding-left:2px">
					<cfdiv bind="url:#link#" id="unit"/>									
					<input type="hidden" name="orgunit" id="orgunit" value="">		
										
					</td>	
				
				<cfelse>
				
					<cfquery name="Org" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT *
						FROM   Organization
						WHERE  OrgUnit = '#Request.orgunit#'			
					</cfquery>
				
					<td class="labelmedium">
					#Org.OrgUnitName# [#Org.OrgunitCode#]
					</td>
				
				</cfif>							
				
				</tr>
			</table>
			
		</td>
	</tr>	

</cfif>

<tr><td colspan="4" style="padding-top:6px" class="labellarge"><cf_tl id="Features and Devices"></td></tr>
<tr><td colspan="4" class="line"></td></tr>
<tr><td height="4"></td></tr>

<cfinclude template="DocumentFormRequestType.cfm">

<!--- container to load context form information --->

<tr>	
    <td colspan="4" style="padding-left:1px;padding-top:4px;padding-right:25px">
								
		<table width="100%" cellspacing="0" cellpadding="0" align="left" style="border:0px dotted silver">			
		<tr id="detail">	
	       <td id="contentdetail" align="left" style="border-top:1px dotted silver;padding:8px"></td>
		</tr>				
		</table>		
						
	</td>
	
</tr>

<tr class="hide"><td colspan="4" align="center" id="submitbox"></td></tr>   	

<cfif url.requestid eq "">
   <cfset url.requestid = rowguid>
</cfif>

<!--- field to capture the assigned requestid --->
<input type="hidden" name="requestid" value="#url.requestid#">

<tr><td colspan="4" style="padding-top:6px" class="labellarge"><cf_tl id="Submission"></td></tr>
<tr><td colspan="4" class="line"></td></tr>
<tr><td height="4"></td></tr>

<!--- ------------------------------------------------- --->
<!--- ------------- EFFECTIVE DATE -------------------- --->
<!--- ------------------------------------------------- --->

<tr>
	<td class="labelmedium" style="padding-top:3px;padding-left:4px"><cf_tl id="Effective">: <font color="FF0000">*</font></td>
	<td height="#ht#" style="z-index:10; position:relative;" colspan="3">
	
	<table cellspacing="0" cellpadding="0"><tr><td  class="labelmedium">
	
	<cfif accessmode eq "Edit">	
	
		 <cfif request.DateEffective eq "">
				
			  <cf_intelliCalendarDate9
				FieldName="dateeffective"
				Manual="True"	
				Class="regularxl"	
				ToolTip="Request Effective Date" 				
				Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
				DateValidStart="#Dateformat(now()-50, 'YYYYMMDD')#"				
				AllowBlank="False">	
			
		 <cfelse>
		 
			  <cf_intelliCalendarDate9
				FieldName="dateeffective"
				Manual="True"	
				Class="regularxl"	
				ToolTip="Request Effective Date" 				
				Default="#Dateformat(Request.DateEffective, CLIENT.DateFormatShow)#"
				DateValidStart="#Dateformat(now()-50, 'YYYYMMDD')#"				
				AllowBlank="False">	
		 
		 </cfif>	
	 
	 <cfelse>
	 
		 #Dateformat(Request.DateEffective, CLIENT.DateFormatShow)#
	 
	 </cfif>
	 
	 </td>
		 
	<!--- ------------------------------------------------- --->
	<!--- ------------- EXPIRATION DATE ------------------- --->
	<!--- ------------------------------------------------- --->
	 
	 <td class="labelmedium" style="padding-left:20px;padding-left:24px;padding-right:10px"><cf_tl id="Expected Expiration">:</td>
	 <td height="#ht#"  class="labelmedium" style="padding-left:4px">
	
		<cfif accessmode eq "Edit">	
		
		 <cfif request.DateExpiration eq "">
				
			  <cf_intelliCalendarDate9
					FieldName="dateexpiration"
					Manual="True"	
					Class="regularxl"	
					ToolTip="Service Expiration Date" 				
					Default=""
					DateValidStart="#Dateformat(now()-50, 'YYYYMMDD')#"				
					AllowBlank="True">	
			
		 <cfelse>
		 
			  <cf_intelliCalendarDate9
					FieldName="dateexpiration"
					Manual="True"	
					Class="regularxl"	
					ToolTip="Service Expiration Date" 				
					Default="#Dateformat(Request.DateExpiration, CLIENT.DateFormatShow)#"
					DateValidStart="#Dateformat(now()-50, 'YYYYMMDD')#"				
					AllowBlank="True">	
		 
		 </cfif>	
		 
		 <cfelse>
		 
		    <cfif Request.DateExpiration eq "">
		      undetermined
		    <cfelse>
			 #Dateformat(Request.DateExpiration, CLIENT.DateFormatShow)#
			</cfif>
		 
		 </cfif>
		
		</td>	 
	 
	   </tr></table>
	
	</td>
</tr>

<cfif accessmode eq "edit">
	
	<tr>
	   <td class="labelmedium" valign="top" style="padding-top:3px;padding-left:4px"><cf_tl id="Memo">:</td>
	   <td colspan="3" style="padding-right:35px">	  
	   <textarea name="memo" class="regular" totlength="450" style="padding:3px;font-size:14px;width:98%;height:45" onkeyup="return ismaxlength(this)">#Request.Memo#</textarea></td>
	</tr>

<cfelseif request.memo neq "">
		
	<tr>
	   <td class="labelmedium" valign="top" style="padding-top:3px;padding-left:4px"><cf_tl id="Memo">:</td>
	   <td  class="labelmedium" colspan="3" height="#ht#">#Request.Memo#</td>
	</tr>

</cfif>

<tr>
   <td class="labelmedium" style="padding-left:4px">Attachments:</td>
   <td colspan="3" height="#ht#" class="labelmedium" style="padding-right:10px;"> 
   	    
   	  <cf_filelibraryCheck  		    	
			DocumentPath="WrkRequest"
			SubDirectory="#rowguid#" 	
			Filter="">	
			
		<cfif accessmode eq "view" and files is 0>
		 <font color="808080">No attachments found</font>
		</cfif>		  
   
	   	<cfif accessmode eq "view">
			<cfset ed = "No">
		<cfelse>
			<cfset ed = "Yes">	
		</cfif>
	  
       <cf_filelibraryN  		    	
			DocumentPath="WrkRequest"
			SubDirectory="#rowguid#" 	
			Filter=""			
			loadscript="no"						
			Insert="#ed#"
			Remove="#ed#"
			reload="true">		
   
   </td>
</tr>

<tr><td colspan="4" class="line"></td></tr>

<tr><td height="4"></td></tr>		
<tr>						 
	 <td height="1" colspan="4" height="45" align="center" id="actionbox">	 	 	   
	 	<cfinclude template="DocumentAction.cfm">							  		
	 </td>		
</tr> 
	 
<tr><td height="4"></td></tr>   
</table>

</cfform>

<cfif request.requesttype eq "">
	
	<!--- a new request which we load upon opening --->	
		
	<script language="JavaScript">		     	   
	     loadrequesttype('#accessmode#');	   
	</script>
	
<cfelse>
	
	<cfquery name="WorkOrder" 
	   datasource="AppsWorkOrder" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		 SELECT W.WorkOrderLineId	
	     FROM   RequestWorkOrder R,
		        WorkOrderLine W
		 WHERE  Requestid       = '#url.requestid#'	     
		 AND    R.WorkorderId   = W.WorkOrderId
		 AND    R.WorkorderLine = W.WorkOrderLine
	</cfquery>	
	
	 <!--- if edit we already do have the values, just load the custom form --->	    
		
	 <script language="JavaScript">
    	 loadcustomform('#request.requestid#','#Request.RequestType#','#RequestLine.Serviceitem#','#accessmode#','#Workorder.workorderlineid#','#Request.RequestAction#')		 
	 </script>
	 	 
</cfif>

</cfoutput>
