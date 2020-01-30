
<cfquery name="Entity" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_Entity
	WHERE EntityCode = '#URL.EntityCode#'
</cfquery>

<cfquery name="Detail" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT E.*
    FROM  Ref_EntityClass E
	WHERE E.EntityCode = '#URL.EntityCode#'
</cfquery>

<cfquery name="Owner" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_AuthorizationRoleOwner
</cfquery>

<cfif Entity.EntityParameter eq "PostType">
	
	<cfquery name="Parameter" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT PostType as Code
	    FROM  Ref_PostType
	</cfquery>

</cfif>

<cfif Detail.recordcount eq "0">
   <cfparam name="URL.ID2" default="new">
<cfelse>
   <cfparam name="URL.ID2" default="">   
</cfif>
	
<cfform action="ActionClassSubmit.cfm?EntityCode=#URL.EntityCode#&ID2=#URL.ID2#" method="POST" name="action">

	<table width="98%" align="right" class="navigation_table">
	    
	  <tr>
	    <td width="100%">
		
	    <table width="100%">
			
	    <TR class="line labelmedium">
		   
		   <td width="80"><cf_space spaces="34">Code</b>		   
		   <td width="45%">Description</td>
		   <td width="15%">Posttype</td>		  
		   <td width="8%" align="center">Embed</td>
		   <td width="8%" align="center">Active</td>
		   <td width="8%" align="center">Mail</td>
		   <td width="8%" align="center">Refresh</td>
		   <td width="20"></td>
		   <td style="width:30px" colspan="2" align="right">
		     <cfoutput>
			 <cfif URL.ID2 neq "new">
			     <A href="javascript:ptoken.navigate('ActionClass.cfm?EntityCode=#URL.EntityCode#&ID2=new','icls')">[add]</a>
			 </cfif>
			 </cfoutput>
		   </td>
		 		
	    </TR>	
							
		<cfoutput query="Detail">
								
		<cfset cd = EntityCode>
		<cfset nm = EntityClass>
		<cfset eb = EmbeddedFlow>
		<cfset de = EntityClassName>	
		<cfset re = RefreshInterval>	
		
		<cfset pm = EntityParameter>
		<cfset op = Operational>
		<cfset ml = EnableEMail>
												
		<cfif URL.ID2 eq nm and url.id2 neq "new">
						
		    <input type="hidden" name="EntityCode" id="EntityCode" value="<cfoutput>#cd#</cfoutput>">
												
			<TR class="line labelmedium">
			
			   <td style="padding-right:4px">#nm#</td>
			   				 
			   <td>
			   
			   		<cf_LanguageInput
						TableCode       = "Ref_EntityClass" 
						Mode            = "Edit"
						Name            = "EntityClassName"									
						Key1Value       = "#cd#"			
						Key2Value       = "#nm#"	
						Value           = "#de#"					
						Type            = "Input"
						Required        = "Yes"
						Message         = "Please enter a description"
						MaxLength       = "50"
						Size            = "30"
						Class           = "regularxl">	
										
			        </td>
			   <td>
			   
			   <cfif entity.entityParameter neq "">
			
				  <select name="EntityParameter" id="EntityParameter" class="regularxl">
				   <option value="" selected>All</option>
				   <cfloop query="Parameter">
				      <option value="#Code#" <cfif pm eq "#Code#">selected</cfif>>#Code#</option>
				   </cfloop>
				   </select>
				   
				<cfelse>
				
				n/a   
			   
			   	</cfif>
			</td>	
			 
			    <td align="center">
			      <input type="checkbox" class="radiol" name="EmbeddedFlow" id="EmbeddedFlow" value="1" <cfif "1" eq eb>checked</cfif>>
				</td>
			    <td align="center">
			      <input type="checkbox" class="radiol" name="ClassOperational" id="ClassOperational" value="1" <cfif "1" eq op>checked</cfif>>
				</td>
				<td align="center">
			      <input type="checkbox" class="radiol" name="EnableEMail" id="EnableEMail" value="1" <cfif "1" eq ml>checked</cfif>>
				</td>
				<td align="center">
				
				  <cfif entity.EnableRefresh eq "1">	
				
					  <select name="RefreshInterval" class="regularxl">
					   <option value="0"  <cfif re eq "0">selected</cfif>>No refresh</option>
					   <option value="5"  <cfif re eq "5">selected</cfif>>5 seconds</option>
					   <option value="10" <cfif re eq "10">selected</cfif>>10 seconds</option>
					   <option value="30" <cfif re eq "30">selected</cfif>>30 seconds</option>
					   <option value="60" <cfif re eq "60">selected</cfif>>60 seconds</option>
				      </select>	
				  
				  <cfelse>
				  
				  	  <input type="hidden" name="RefreshInterval"  value="0">
				  
				  </cfif>
			     
				</td>
			   <td align="right" style="padding-left:3px;padding-right:3px" colspan="2"><input type="submit" style="width:50px;height:25px" value="Save" class="button10g"></td>
		    </TR>	
					
		<cfelse>
		
			<cfset edit = "javascript:ColdFusion.navigate('ActionClass.cfm?EntityCode=#URL.EntityCode#&ID2=#nm#','icls')">
						
			<TR class="labelmedium navigation_row line">
			
			   <!---
			   <td onclick="#edit#"><cfif ow eq ""><font color="C0C0C0">All<cfelse>#ow#</cfif></td>
			   --->
			   <td style="padding-left:4px">
			     <a target="_blank" href="../ClassAction/FlowView.cfm?EntityCode=#cd#&EntityClass=#nm#">#nm#</a>
			   </td>
			   <td>#de#</td>
			   <td>#pm#</td>
			  			   			   
			   <td align="center"><cfif eb eq "0"><b><font color="FF0000">No</font></b><cfelse>Yes</cfif></td>
			   <td align="center"><cfif op eq "0"><b><font color="FF0000">No</font></b><cfelse>Yes</cfif></td>
			   <td align="center"><cfif ml eq "0"><b><font color="FF0000">No</font></b><cfelse>Yes</cfif></td>
			   <td align="center">
			   <cfif entity.EnableRefresh eq "1">	
			   		<cfif re eq "0">disabled<cfelse>#re# sec.</cfif>
				<cfelse>
					disabled
				</cfif>		   					   
			   </td>
			   <td align="right" style="padding-right:4px">			   
			      <cf_img icon="edit" navigation="Yes" onClick="javascript:ColdFusion.navigate('ActionClass.cfm?EntityCode=#URL.EntityCode#&ID2=#nm#','icls')">			 				 
			   </td>
			   
			   <td align="left" style="padding-left:2px;padding-top:2px;padding-right:3px">
			   
			   <cfquery name="Detail" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM   Ref_EntityClassPublish
					WHERE  EntityCode  = '#EntityCode#'
					AND    EntityClass = '#EntityClass#'
			   </cfquery>
				   
			    <cfif Detail.recordcount eq "0">
				
				   <cf_img icon="delete" onClick="javascript:ColdFusion.navigate('ActionClassPurge.cfm?EntityCode=#URL.EntityCode#&ID2=#nm#','icls')">
			 	   
				</cfif>
				
			  </td>
			  
			  <td></td>
			   
		    </TR>	
			
			<cfset cl = replaceNoCase(entityclass," ","")>
			
			<tr class="line" style="height:20px;">
			<td colspan="9">
			
				<table width="100%">
				
					<tr>
					
						<td style="width:30%;background-color:ffffcf">
						
							<table width="100%">
							
								<tr style="height:20px;" class="labelmedium navigation_row_child"><td style="min-width:60px;padding-right:3px;padding-left:15px">
						
								     <cfset link = "ActionClassOwner.cfm?entitycode=#entitycode#&entityclass=#entityclass#">		
									      						 
									   <cf_selectlookup
										    box          = "#cl#_owner"
											link         = "#link#"
											button       = "No"
											close        = "No"	
											title        = "Owner:"											
											class        = "owner"
											des1         = "Owner">		
								
								   </td><td style="width:100%" colspan="7" id = "#cl#_owner">
							   
									    <cfset url.entitycode  = entitycode>
										<cfset url.entityclass = entityclass>
										<cfinclude template="ActionClassOwner.cfm">
									
								   </td>
							    </tr>	
							
							</table>
						
						</td>
						
						<td style="width:70%'background-color:f1f1f1">
												
							<table width="100%">
							
								<tr style="height:20px;" class="labelmedium navigation_row_child">
									  <td style="min-width;60px;padding-right:3px;padding-left:15px">
									
									     <cfset link = "ActionClassMission.cfm?entitycode=#entitycode#&entityclass=#entityclass#">		
						
										   <cf_selectlookup
											    box          = "#cl#_entity"
												link         = "#link#"
												button       = "No"
												close        = "No"	
												title        = "Entity:"											
												class        = "mission"
												des1         = "mission"
												filter1      = "missionEntity"
												filter1Value = "#entitycode#">
											
											<!--- Filtered by Ref_EntityMission where the entityCode is the same --->	
									
									   </td>
									   <td colspan="7" style="width:100%" id="#cl#_entity">
									   			 
										    <cfset url.entitycode  = entitycode>
											<cfset url.entityclass = entityclass>					
											<cfinclude template="ActionClassMission.cfm">
													
									   </td>
								    </tr>
										
							</table>
						
						</td>
					</tr>
				</table>
			
			</td>
			</tr>
								
		</cfif>
				
		</cfoutput>
									
		<cfif URL.ID2 eq "new">
				
			<TR>
			
			<!---
			<td>
			   			   
			   <select name="EntityClassOwner" style="font:10px">
			   <option value="" selected>All</option>
			   <cfoutput query="Owner">
			   <option value="#Code#">#Code#</option>
			   </cfoutput>
			   </select>			   
			   
			</td>
			--->
			   
			<td>
			    <cfinput type="Text" value="" name="EntityClass" message="You must enter a code" required="Yes" size="6" maxlength="20" class="regularxl">
	        </td>
			
			<td>
			
			<cf_LanguageInput
						TableCode       = "Ref_EntityClass" 
						Mode            = "Edit"
						Name            = "EntityClassName"																			
						Type            = "Input"
						Required        = "Yes"
						Message         = "Please enter a description"
						MaxLength       = "40"
						Size            = "30"
						Class           = "regularxl">		
		
			</td>
			
			<td>
			
			   <cfif Entity.entityParameter neq "">
			
				  <select name="EntityParameter" id="EntityParameter" class="regularxl">
				   <option value="" selected>All</option>
				   <cfoutput query="Parameter">
				      <option value="#Code#">#Code#</option>
				   </cfoutput>
				   </select>
			   
			   	</cfif>
			
			</td>	
			   
			<td align="center">
				<input type="checkbox" class="radiol" name="EmbeddedFlow" id="EmbeddedFlow" value="1" checked>
			</td>   
			
			<td align="center">
				<input type="checkbox" class="radiol" name="ClassOperational" id="ClassOperational" value="1" checked>
			</td>
			
			<td align="center"><input class="radiol" type="checkbox" name="EnableEMail" id="EnableEMail" value="1" checked></td>
			
			<td align="center">
			
			    <cfif entity.EnableRefresh eq "1">	
					
			    <select name="RefreshInterval">
				   <option value="0" selected>No refresh</option>
				   <option value="5">5 seconds</option>
				   <option value="10">10 seconds</option>
				   <option value="30">30 seconds</option>
				   <option value="60">60 seconds</option>
			   </select>
			   
			   <cfelse>
			   
			   	<input type="hidden" name="RefreshInterval"  value="0">
			   			   
			   </cfif>
			  
				</td>
								   
			<td colspan="2" align="right" style="padding-left:3px;padding-right:4px"><input type="submit" value="Add" style="width:50px;height;25px" class="button10g"></td>
			    
			</TR>	
											
		</cfif>	
					
		</table>
		
		</td>
		</tr>
		
	</table>	
	
</cfform>

<cfset ajaxonload("doHighlight")>

