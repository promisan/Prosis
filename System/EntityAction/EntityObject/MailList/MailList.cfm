<cfparam name="url.ActionCode" default="">
<cfparam name="url.EntityClass" default="">
<cfparam name="url.box" default="maillist">

<cfquery name="getModule" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT SystemModule 
	FROM   Ref_AuthorizationRole 
	WHERE  Role IN (SELECT Role FROM Ref_Entity WHERE  EntityCode = '#URL.EntityCode#' )
</cfquery>

<cfset module = getModule.SystemModule>	

<cfquery name="MissionList" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_Mission
	WHERE Mission IN (SELECT Mission 
	                  FROM   Ref_MissionModule 
	                  WHERE  SystemModule = '#module#'					 
					 )						 				
</cfquery>

<cfquery name="List" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_EntityDocumentRecipient
	WHERE DocumentId = '#URL.DocumentId#'
	<cfif url.entityClass neq "">
	AND EntityClass = '#url.entityClass#'
	</cfif>
	<cfif url.actioncode neq "">
	AND ActionCode = '#url.actionCode#'
	</cfif>
	ORDER BY Mission,eMailAddress
</cfquery>

<cfif List.recordcount eq "0">
   <cfparam name="URL.ID2" default="new">
<cfelse>
   <cfparam name="URL.ID2" default="">   
</cfif>

<cfif MissionList.recordcount gt "0" or module eq "System">

<table width="95%" cellspacing="0" cellpadding="0">
	 
	 	<tr>
	
	    <td width="100%" style="padding-top:4px">
	    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="navigation_table">
				
	    <TR height="18" class="labelit linedotted">
		   <td width="120" style="padding-left:5px">Entity</td>
		   <td width="180">EMail</td>
		   <td width="180">Name</td>
		   <td width="30" align="center">Active</td>
		   <td colspan="2" align="right" width="50">
	       <cfoutput>
			 <cfif URL.ID2 neq "new">
			     <A href="#ajaxLink('#SESSION.root#/system/entityAction/EntityObject/MailList/MailList.cfm?box=#url.box#&actioncode=#url.actioncode#&entitycode=#url.entityCode#&DocumentId=#URL.DocumentId#&ID2=new')#">
				 <font color="0080FF">[add]</font></a>
			 </cfif>
			 </cfoutput>&nbsp;
		   </td>		  
	    </TR>
						
		<cfoutput>
		
		<cfloop query="List">				
																							
			<cfif URL.ID2 eq recipientid>		
																
				<TR>
				   <td style="padding-left:5px">
				   <cfset mis = mission>
				   <select name="mission" id="mission" class="regularxl">
				       <cfif module eq "system">
					   <option value="" <cfif mission eq "">selected</cfif>>n/a</option>
					   </cfif>
					   <cfloop query="missionlist">
						   	<option value="#Mission#" <cfif mission eq mis>selected</cfif>>#Mission#</option>
					   </cfloop>				   
				   </select>
								   
				   </td>
				   <td>
				   	    <input type="Text" 
					   	value="#eMailAddress#" 
						name="emailaddress" 
						id="emailaddress"
						size="25" 
						maxlength="50" 
						class="regularxl">
				  
		           </td>
				   <td height="22">
				   
				   		<input type="Text"
					    name="recipientname"
						id="recipientname"
					    value="#RecipientName#"					   
					    size="30" 
						maxlength="50" 					     
					    class="regularxl">
				   			   
				     </td>
				  
				   <td align="center">
				      <input type="checkbox" class="radiol" name="oper" id="oper" value="1" <cfif "1" eq operational>checked</cfif>>
					</td>
				   <td colspan="2" align="right">
				   <input type = "submit" 
				     value     = "Save" 
					 onclick   = "ColdFusion.navigate('#SESSION.root#/system/entityAction/EntityObject/MailList/MailListSubmit.cfm?box=#url.box#&entityCode=#url.entityCode#&entityclass=#url.entityClass#&actioncode=#url.actioncode#&DocumentId=#URL.DocumentId#&id2=#url.id2#&mission='+mission.value+'&emailaddress='+emailaddress.value+'&recipientname='+recipientname.value+'&operational='+oper.checked,'#url.box#')"
				 	 class     = "button10g" 
					 style     = "width:50;height:25px"></td>
			    </TR>	
																			
			<cfelse>
										
				<TR class="labelit linedotted navigation_row" bgcolor="fcfcfc">
				   <td height="15" width="80" style="padding-left:6px"><cfif mission eq "">n/a<cfelse>#mission#</cfif></td>
				   <td width="120">#emailaddress#</td>
				   <td width="120">#recipientname#</td>
				   <td align="center"><cfif operational eq "0"><b>No</b><cfelse>Yes</cfif></td>
				   <td align="right" width="20">
				       <cf_img icon="edit" onclick="#ajaxLink('#SESSION.root#/system/entityAction/EntityObject/MailList/MailList.cfm?box=#url.box#&entityCode=#url.entityCode#&entityclass=#url.entityClass#&actioncode=#url.actioncode#&DocumentId=#URL.DocumentId#&ID2=#recipientid#')#">					
				   </td>
				   <td align="left" width="20" style="padding-left:5px">
				   	 <cf_img icon="delete" onclick="#ajaxLink('#SESSION.root#/system/entityAction/EntityObject/MailList/MailListPurge.cfm?box=#url.box#&entityCode=#url.entityCode#&entityclass=#url.entityClass#&actioncode=#url.actioncode#&DocumentId=#URL.DocumentId#&ID2=#recipientid#')#">														  
				    </td>
				 </TR>	
										
			</cfif>
						
		</cfloop>
		</cfoutput>
													
		<cfif URL.ID2 eq "new">
									
			<TR>
			<td height="28">
							
			     <select name="mission" id="mission" class="regularxl">
				 	   <cfif module eq "system">
					   <option value="" selected>n/a</option>
					   </cfif>
					   <cfoutput query="missionlist">
						   	<option value="#Mission#">#Mission#</option>
					   </cfoutput>				   
				 </select>
				 
	        </td>
						   
			    <td>
				
				   	<input type="Text" 
					   	name="emailaddress" 
						id="emailaddress"
						size="25" 
						maxlength="50" 
						class="regularxl">
						
				</td>								 
				<td>				
				   	<input type="Text"
					    name="recipientname"	
						id="recipientname"				    					   
					    size="30" 
						maxlength="50" 					     
					    class="regularxl">
				</td>
			
			<td align="center">
				<input type="checkbox" class="radiol" name="oper" id="oper" value="1" checked>
			</td>
								   
			<td colspan="2" align="right">
			<cfoutput>
				<input type = "button" 
				    onclick = "ColdFusion.navigate('#SESSION.root#/system/entityAction/EntityObject/MailList/MailListSubmit.cfm?box=#url.box#&entityCode=#url.entityCode#&entityclass=#url.entityClass#&actioncode=#url.actioncode#&DocumentId=#URL.DocumentId#&id2=#url.id2#&mission='+mission.value+'&emailaddress='+emailaddress.value+'&recipientname='+recipientname.value+'&operational='+oper.checked,'#url.box#')"
					value   = "Add" 
					class   = "button10s" 
					style   = "width:50;height:25px">
			
			</cfoutput>
			</td>			    
			</TR>	
				
											
		</cfif>								
		</table>		
		</td>
		</tr>	
								
</table>	

<cfelse>

	<cf_compression>

</cfif>

<cfset ajaxonload("doHighlight")>
