
<cfparam name="url.id" default="">
<cfparam name="url.drillid" default="">

<cfif url.drillid eq "">

   <cfinclude template="DocumentView.cfm">
   
<cfelse>   

<cfform name="formedit" style="width:100%;min-width:900" action="DocumentEditSubmit.cfm?observationid=#url.drillid#" method="POST">
	
	<table width="96%" align="center" class="formpadding">
	
	<cfoutput query="Observation">
	
	<tr><td class="hide" id="result" align="center" colspan="2"></td></tr>
		
	<cfif Observation.ActionStatus lte "1" or (getAdministrator("*") eq "1" and Observation.ActionStatus lte "2")>
		   <cfset edit = "1">
	<cfelse>
		   <cfset edit = "0">   
	</cfif>
		
	<cfif edit eq "1">	
		
		<tr class="line">
			<td colspan="3" align="center">		 
			  <table width="100%" class="formspacing">
			  <tr><td width="5%">
			  <input class="button10g" type="button" name="Cancel" id="Cancel" value="Delete" onClick="ColdFusion.navigate('DocumentEditCancel.cfm?id=#url.id#','result')">
			  </td>
			  <td width="5%">
		      <input class="button10g" type="button" name="Save"   id="Save"   value="Update"   onClick="updateTextArea();ColdFusion.navigate('DocumentEditSubmit.cfm?id=#url.id#','result','','','POST','formedit')">     		 
			  </td>
			  						  
			<cfif getAdministrator("*") eq "1" and ObservationClass eq "Inquiry"> 
			
			  <td width="5%"><input class="button10g" type="button" style="width:200px" name="Convert" id="Convert" value="Set as Amendment" onClick="convert('#url.id#')"></td>			
				
			</cfif>		  
			  
			  <td align="right" width="90%">
			  <table>
			  <td class="labelmedium" style="padding-left:10px;border-left:1px solid silver;padding-right:10px;border-right:1px solid silver;">#Observation.Source#</td>
			  <td align="right" class="labelmedium" style="padding-left:10px;padding-top:5px">
		        <cfdiv bind="url:getDocumentStatus.cfm?observationid=#Observation.ObservationId#" id="statusbox" class="labelmedium">	    	      
			  </td></tr>
			  </table>
			  </td>
			  </tr>
			  </table>
			</td>
		</tr>
			
	</cfif> 
	
	<tr class="labelmedium"><td height="18" style="padding-left:0px"><cf_tl id="Priority">:<cf_space spaces="40"></td>
	    <td height="25" colspan="2">
	    <table cellspacing="0" cellpadding="0" class="formspacing">
		<tr class="labelmedium">
	   
		<cfif edit eq "1">
		     <td style="background-color:##ff000080;padding:5px"><input type="radio" class="radiol" name="RequestPriority" id="RequestPriority" value="Low" <cfif "Low" eq RequestPriority>checked</cfif>></td><td style="padding-left:3px" class="labelmedium">L</td>
			 <td style="background-color:##FF800080;padding:5px"><input type="radio" class="radiol" name="RequestPriority" id="RequestPriority" value="Medium" <cfif "Medium" eq RequestPriority>checked</cfif>></td><td style="padding-left:3px" class="labelmedium">M</td>
			 <td style="background-color:##FFFF0080;padding:5px"><input type="radio" class="radiol" name="RequestPriority" id="RequestPriority" value="High" <cfif "High" eq RequestPriority>checked</cfif>></td><td style="padding-left:3px" class="labelmedium">H</td>
		<cfelse>
		 	 <td class="labelmedium"><b>#RequestPriority#</b></td>
		</cfif>	
		</td>
	    <td style="padding-left:20px"><cf_tl id="Frequency">:</td>
	    
		<cfif edit eq "1">
			 <td style="background-color:##ff000080;padding:5px"><input type="radio" class="radiol" name="ObservationFrequency" id="ObservationFrequency" value="Low" <cfif "Low" eq ObservationFrequency>checked</cfif>></td><td style="padding-left:3px" class="labelmedium">L</td>
			 <td style="background-color:##FF800080;padding:5px"><input type="radio" class="radiol" name="ObservationFrequency" id="ObservationFrequency" value="Medium" <cfif "Medium" eq ObservationFrequency>checked</cfif>></td><td style="padding-left:3px" class="labelmedium">M</td>
			 <td style="background-color:##FFFF0080;padding:5px"><input type="radio" class="radiol" name="ObservationFrequency" id="ObservationFrequency" value="High" <cfif "High" eq ObservationFrequency>checked</cfif>></td><td style="padding-left:3px" class="labelmedium">H</td>
		<cfelse>
		   <td  class="labelmedium"><b>#ObservationFrequency#</b></td>
		</cfif>	
		
	    <td style="padding-left:20px"><cf_tl id="Impact">:</td>
	    
		<cfif edit eq "1">
		     <td style="background-color:##ff000080;padding:5px"><input type="radio" class="radiol" name="ObservationImpact" id="ObservationImpact" value="Low" <cfif "Low" eq ObservationImpact>checked</cfif>></td><td style="padding-left:3px" class="labelmedium">L</td>
			 <td style="background-color:##FF800080;padding:5px"><input type="radio" class="radiol" name="ObservationImpact" id="ObservationImpact" value="Medium" <cfif "Medium" eq ObservationImpact>checked</cfif>></td><td style="padding-left:3px" class="labelmedium">M</td>
			 <td style="background-color:##FFFF0080;padding:5px"><input type="radio" class="radiol" name="ObservationImpact" id="ObservationImpact" value="High" <cfif "High" eq ObservationImpact>checked</cfif>></td><td style="padding-left:3px" class="labelmedium">H</td>
		<cfelse>
		 <td class="labelmedium"><b>#ObservationImpact#</b></td>
		</cfif>	
		
		</table>
	</td>	
	</tr>
	
	
	<tr><td height="20" style="width:10%" class="labelmedium"><cf_tl id="Request Title">:</td>
	    <td class="labelmedium">
		<cfif edit eq "1">
		<input type="Text"
		     name="RequestName" 	
			 id="RequestName"	 
			 value="#RequestName#"
			 size="80"
			 style="width:95%"
			 maxlength="80" 
			 class="regularxl">
		<cfelse>
			#RequestName#
		</cfif>	 
		 </td>
	</tr>
	
	<tr>
	
		<td class="labelmedium">
			<cfif ObservationClass eq "Inquiry">
				<cf_tl id="Server">:
			<cfelse>
				<cf_tl id="Owner">:
			</cfif>
		</td>
		
	    <td class="labelmedium">
		
		<cfif edit eq "1">
		
			<cfif ObservationClass eq "Inquiry">
			
				<cfquery name="Site" 
				datasource="AppsControl" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
		    		SELECT  *
					FROM    ParameterSite
					WHERE   Operational = 1
					ORDER   BY ListingOrder
				</cfquery>
			
				<select name="ApplicationServer" id="ApplicationServer" class="regularxl">
				    <cfloop query="Site">
						<option value="#ApplicationServer#" <cfif ApplicationServer eq Observation.ApplicationServer>selected</cfif>>#ServerDomain#</option>
					</cfloop>
		    	</select>	
										
			<cfelse>
			
					<cfquery name="getOwner" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT   *
						FROM     Ref_AuthorizationRoleOwner				
					</cfquery>
					
					<select name="Owner" id="Owner" class="regularxl">
					
						<cfloop query="getOwner">
					
							<cfinvoke component = "Service.Access"  
								method           = "ShowEntity" 
								entityCode       = "SysChange"				
								Owner            = "#getOwner.code#"
								returnvariable   = "access">
							
							<cfif Access eq "EDIT" or Access eq "ALL">	
								<option value="#Code#" <cfif Code eq Observation.Owner>selected</cfif> >#Code#</option>
							</cfif>
							
						</cfloop>		
					
					</select>
			
			</cfif>
		
		<cfelse>
			   <cfif ObservationClass eq "Inquiry">
					#Observation.ApplicationServer#
				<cfelse>
					#Observation.Owner#
				</cfif>
			
		</cfif>		
		
		</td>
		</tr>
				
		<tr>
		
			<td class="labelmedium">
				<cfif ObservationClass eq "Inquiry">
					<cf_tl id="Application">:
				<cfelse>
					<cf_tl id="Module">:
				</cfif>
			</td>
		
				<td>
			
					<table cellspacing="0" cellpadding="0">
					
					<tr>
					
					<cfif ObservationClass eq "Inquiry">
					
						<td class="labelmedium">
						
							<cfquery name="QApplication" 
							datasource="AppsSystem" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT  *
								FROM    Ref_Application
								WHERE   Usage != 'System'
								AND     Operational = 1
							</cfquery>
					
							<cfif QApplication.recordcount eq "0">
					
								<cfquery name="QApplication" 
									datasource="AppsSystem" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									    SELECT  *
										FROM    Ref_Application
										WHERE   Operational = 1
								</cfquery>
						
							</cfif>
												
							<cfif edit eq "1">
								
								<select name="Workgroup" id="Workgroup" class="regularxl">
								    <cfloop query="QApplication">
										<option value="#Code#" <cfif Code eq Object.EntityGroup>selected</cfif>>#Description#</option>
									</cfloop>
							    </select>
								
							<cfelse>
							
								#Object.EntityGroup#
								
							</cfif>		
							
						</td>
						
						<td>&nbsp;&nbsp;</td>
						<td style="padding-left:10px" class="labelmedium"><cf_tl id="Module">:</td>
						<td>&nbsp;</td>
						<td style="padding-left:15px;" class="labelmedium">
							<cfif edit eq "1">
								<cfdiv bind="url:getDocumentEntryModule.cfm?selected=#Observation.SystemModule#&application={Workgroup}" id="module_div">
							<cfelse>
								#Observation.SystemModule#
							</cfif>
						</td>
						
					<cfelse>
					
						<td class="labelmedium">		
						<cfquery name="Module" 
							datasource="AppsSystem" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT  *
								FROM    Ref_SystemModule
								WHERE   Operational = 1
								AND     MenuOrder < '90'
						</cfquery>
					
						<cfif edit eq "1">
							<select name="SystemModule" id="SystemModule" class="regularxl">
						    <cfloop query="Module">
							<option value="#SystemModule#" <cfif systemmodule eq Observation.systemmodule>selected</cfif>>#SystemModule#</option>
							</cfloop>
						    </select>
						<cfelse>
							#SystemModule#
						</cfif>		
						</td>
						
					</cfif>		
						
					</tr>
					</table>	
				
			</td>
		
			<td align="right" valign="top">	
	
			<!---
			<font color="808080">No:&nbsp;<font size="2" color="000000">#Observation.Reference#</font>
		
			--->
		</td>	
	</tr>
	
	<tr>
	<td class="labelmedium"><cf_tl id="Requester">:</td>
	<td>
	    <table>
		<tr>		
						
			<cfquery name="getUser" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT  *
					FROM    UserNames
					WHERE   Account = '#Observation.Requester#'								
			</cfquery>
						
			<td class="labelmedium">
			
			<input   name="requestername" 	
					 id="requestername"	 
					 value="#getUser.FirstName# #getUser.LastName#"
					 readonly
					 size="27"
					 maxlength="60" 
					 class="regularxl">
					 
			</td>
			
			<cfif edit eq "1">
		
			<td style="padding-right:3px">
				
					<cfset link = "getUser.cfm?id=user">
															
					<cf_selectlookup
						    box        = "requesterbox"							
							link       = "#link#"
							button     = "Yes"
							iconheight = "20"
							iconwidth  = "20"
							icon       = "search.png"
							close      = "Yes"
							class      = "user"
							des1       = "useraccount">						
				
			</td>
			
			</cfif>
			
			<td>		 
			
			<cfif user.PersonNo neq "">
				<cf_img icon="open" onclick="javascript:EditPerson('#User.PersonNo#')">
			</cfif>
			
			<cfif edit eq "1">
			
				<input type="hidden"
				     name="requester" 	
					 id="requester"	 
					 value="#Observation.Requester#"
					 size="27"
					 maxlength="50" 
					 class="regularxl">
			 
			 </cfif>
			
			</td>	
			<td id="requesterbox"></td>		
			
			
		</tr>
		</table>	
	</tr>	
	
	<tr><td class="labelmedium" style="width:100px"><cf_tl id="Contact Mail">:</td>
	    <td class="labelmedium">
		
		<table cellspacing="0" cellpadding="0"><tr><td class="labelmedium">
		
		<cfif edit eq "1">
			
		<input type="Text"
		     name="PersonMail" 	
			 id="email"	 
			 value="#Object.PersoneMail#"
			 size="27"
			 maxlength="50" 
			 class="regularxl">
			 
		<cfelse>
		
			<cfif Object.PersonEMail eq "">..<cfelse>#Object.PersonEMail#</cfif>
			
		</cfif>	 
				
		</td>
					
		
		</tr>
		</table>
		
		 </td>
		
	</tr>
	
	
	
	
	<cfif ObservationClass neq "Inquiry">
		
		<tr><td class="labelmedium"><cf_tl id="Work group">:</td>
		    <td class="labelmedium">
			<cfif edit eq "1">
				<cfdiv bind="url:getDocumentEntryGroup.cfm?selected=#Object.entitygroup#&entitycode=SysChange&owner={Owner}" id="workgrp"/>	
			<cfelse>
				#Object.EntityGroup#
			</cfif>	
			</td>
		</tr>
	
	</cfif>
	
	<tr>
	   
		<td colspan="3" width="90%" id="mod" style="padding-top:3px">
			
			<cfif edit eq "1">
				
			<cf_filelibraryN
					DocumentPath  = "Modification"
					SubDirectory  = "#observationid#" 
					Filter        = ""						
					LoadScript    = "1"		
					EmbedGraphic  = "no"
					Width         = "100%"
					Box           = "mod"
					Insert        = "yes"
					Remove        = "yes">	
					
			<cfelse>
			
				<cf_filelibraryN
					DocumentPath  = "Modification"
					SubDirectory  = "#observationid#" 
					Filter        = ""						
					LoadScript    = "1"		
					EmbedGraphic  = "no"
					Width         = "100%"
					Box           = "mod"
					Insert        = "no"
					Remove        = "no">			
			
			</cfif>		
		
		</td>
	</tr>
	  
	<tr class="hide">
	   <td colspan="3">
	
	   <cfset wflnk = "DocumentEditWorkflow.cfm">   
	  
	    <input type="hidden" name="workflowlink_#url.id#" id="workflowlink_#url.id#" value="#wflnk#"> 
		 	 	 
		<input type="hidden" 
		   name="workflowlinkprocess_<cfoutput>#url.id#</cfoutput>" 
		   id="workflowlinkprocess_<cfoutput>#url.id#</cfoutput>"
		   onclick="ColdFusion.navigate('getDocumentStatus.cfm?observationid=#url.id#','statusbox')">		
		 
		</td>
		
	</tr>  
		 
	</cfoutput>	 
			
	<cfif edit eq "1">
	
	     <tr><td colspan="3"><table style="width:100%">
	
	       <!---
		 <cf_ProcessActionTopic name="outline" 
		       mode="Expanded" 
			   line="No"
			   title="<font size='2' color='0080C01'>View/Hide Details"
			   click="maximize('outline')">
			   
			   --->
							   
			 <tr><td colspan="3" id="outline" name="outline" style="padding:1px; width:100%">		
			 			 		  			 
			  <cf_textarea name="ObservationOutLine"                 	          
		           height         = "120"   
				   width		  = "100%"
				   toolbar        = "Basic"					   
				   init           = "Yes"
				   resize         = "No"   
				   color          = "ffffff"><cfoutput>#ParagraphFormat(Observation.ObservationOutline)#</cfoutput></cf_textarea>  				  
				  
			 </td></tr>		
			 
			 </table></td></tr>
			 
	<cfelse>
	
		<cfoutput query="Observation">
	
			 <cf_ProcessActionTopic name="outline" 
		       title = "Observation"
			   line  = "No"
			   click = "maximize('outline')">	
			   					   
			 <tr>
			 	 <td id="outline" name="outline" height="20" colspan="3" class="hide" style="padding:4px;border: 1px dotted Silver;">		
				 <table><tr><td class="labelmedium">#ObservationOutline#</td></tr></table>
				</td>
			 </tr>
			 
		</cfoutput>	 
			 
	</cfif>		
	
	
	<tr>
		<td colspan="3" height="100%" id="<cfoutput>#url.id#</cfoutput>">	
		    <cfset url.ajaxid = url.id>		
			<cfinclude template="DocumentEditWorkflow.cfm">		
		</td>
	</tr>
			
	</table>
	
	</cfform>

</cfif>	
