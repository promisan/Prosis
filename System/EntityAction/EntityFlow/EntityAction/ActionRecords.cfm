
<cfinvoke component="Service.Presentation.Presentation"
    method="highlight"
    returnvariable="stylescroll"/>

<cfparam name="URL.search" default="">
<cfparam name="Box"        default="">

<cfset val = "">
<cfloop index="itm" list="#url.search#">
	<cfset val = itm>
</cfloop>
<cfset url.search = val>

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
    SELECT  DISTINCT E.*, 
	        R.ActionCode as Used
    FROM    Ref_EntityAction E LEFT OUTER JOIN Ref_EntityActionPublish R ON E.ActionCode = R.ActionCode
	WHERE   E.EntityCode = '#URL.EntityCode#'	   
	<cfif url.search neq "">
	AND     (E.ActionDescription LIKE '%#URL.search#%' OR E.ActionCode LIKE '%#URL.search#%') 
	</cfif>
	ORDER BY E.ListingOrder
</cfquery>


<cfquery name="Parent" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   DISTINCT Code
    FROM     Ref_EntityActionParent
	WHERE    Operational = 1
	AND      EntityCode = '#URL.EntityCode#'
	ORDER BY Code
</cfquery>

<cfquery name="Check" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT E.*
    FROM  Ref_EntityAction E
	WHERE E.EntityCode = '#URL.EntityCode#'
	AND   E.ActionType = 'Create' 
</cfquery>

<cfif Detail.recordcount eq "0">
   <cfparam name="URL.ID2" default="new">
<cfelse>
   <cfparam name="URL.ID2" default="">   
</cfif>
	
	<table width="100%" cellspacing="0" cellpadding="0" align="center">
	
	<tr>
	
	 <td width="100" style="height:40;padding-left:8px" class="labelit"><cf_tl id="Locate"></td>
	 
	 <cfoutput>
	 
		 <td width="100">	
		 
		      <input type    = "text" 
				   name      = "find" 
				   id        = "find"
			       size      = "25"
				   value     = "#URL.search#"			   
				   onKeyUp   = "search(event)"
			       maxlength = "25"
				   style     = "padding-left:3px;width:100"
			       class     = "regularxl">
			   
		</td>
				
		<td height="20" style="padding-left: 5px;padding-right: 5px;">	   
				   
			    <img src="#SESSION.root#/Images/locate3.gif" 
					 alt         = "Search" 
					 name        = "locateme" 
					 id          = "locateme"
					 onMouseOver = "document.locate.src='#SESSION.root#/Images/button.jpg'" 
					 onMouseOut  = "document.locate.src='#SESSION.root#/Images/locate3.gif'"
					 style       = "cursor: pointer;" 					 
					 border      = "0" 
					 height      = "14" width="14"
					 align       = "absmiddle" 
					 onclick     = "searching('#url.entitycode#',find.value)">
			
		  </td> 
	  
	      <td width="90%"></td>
	  
	  </cfoutput>	   
		      
	</tr>
		      
	  <tr>
	    <td width="100%" colspan="4">
						
		<cfform action="ActionRecordsSubmit.cfm?Search=#url.search#&EntityCode=#URL.EntityCode#&ID2=#URL.ID2#&search=#url.search#" 
		    method="POST" 
			name="action">
		
	    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="navigation_table">
			
	    <TR class="line labelmedium">
		   
		   <td></td>
		   <td height="20" style="padding-left:5px"><cf_tl id="Code"></td>		  
		   <td width="50%"><cf_tl id="Description"></td>
		   <td width="40">S</td>
		   <td width="10%"><cf_tl id="Class"></td>
		   <td><cf_UIToolTip tooltip="Uses Tabbed form and presents the action dialog as modal dialog"><cf_tl id="Dialog"></cf_UIToolTip></td>
		   <td width="40" align="center"><cf_UIToolTip tooltip="Allow Object Owner to grant access to users for this step on the object level">Fly.</cf_UIToolTip></td>
		   <td width="40" align="center"><cf_UIToolTip tooltip="Enabled for embediding in new worflows">Op.</cf_UIToolTip></td>
		   <td align="right" style="padding-right:10px"  colspan="4">
	         
			 <cfoutput>			 
			 <cfif URL.ID2 neq "new">
			     <A href="javascript:#ajaxLink('ActionRecords.cfm?EntityCode=#URL.EntityCode#&search=#url.search#&ID2=new')#"><font color="0080FF">[add]</font></a>
			 </cfif>			
			 </cfoutput>
			 
		   </td>	
		   	  
	    </TR>	
				
		<cfif URL.ID2 eq "new">
				   				
			<TR bgcolor="f9f9f9" class="line" style="height:34px">
			
			<td width="2"></td>
			<td height="24"><cf_space spaces="24">
			  <table cellspacing="0" cellpadding="0"><tr><td class="labelit"><cfoutput>#Entity.EntityAcronym#</cfoutput></td>
				<td>-</td>
				<td>
				<cfinput type="Text" value="" name="ActionCode" 
				   message="You must enter a unique action code" required="Yes" size="1" maxlength="4" class="regularxl">
				</td></tr>
				</table> 
	        </td>
			
			<td style="padding-left:3px">
			  					
				<cf_LanguageInput
					TableCode       = "Ref_EntityAction" 
					Mode            = "Edit"
					Name            = "ActionDescription"
					Value           = ""
					Key1Value       = ""
					Type            = "Input"
					Required        = "Yes"
					Message         = "Please enter a description"
					MaxLength       = "80"
					Size            = "40"
					style           = "width:99%"
					Class           = "regularxl">					
					
			</td>
			
			<td style="padding-left:1px">
						
				   <cfinput type="text" 
			         name="ListingOrder" 
					 size="1" 					
					 maxlength="2" 
					 class="regularxl" 
					 style="text-align:center;width:25;width:99%" 
					 validate="integer" 
					 visible="Yes" 
					 enabled="Yes">
					 
			</td>
			
			<td style="padding-left:3px">
						 
				<select name="ActionType" id="ActionType" class="regularxl" style="width:99%">
				<cfif Check.recordcount eq "0" and Entity.EnableCreate eq "1">
				<option value="Create">Create</option>
				</cfif>
				<option value="Action" selected>Action</option>
				<option value="Decision">Decision</option>
				</select>
			</td>
			
			<td align="center" style="padding-left:3px">
				<select name="ProcessMode" id="ProcessMode" class="regularxl" style="width:99%">				
					<option value="0">Single Dialog</option>									
					<option value="2">Window</option>		
					<option value="3">Browser Tab</option>			
					<option value="1">Modal Dialog (deprecated, IE only)</option>
				</select>
				
			</td>
			
			<td align="center" style="padding-left:3px">
				<input type="checkbox" class="radiol" name="EnableAccessFly" id="EnableAccessFly" value="1" checked>
			</td>
			
			<td align="center" style="padding-left:3px">
				<input type="checkbox" class="radiol" name="Operational" id="Operational" value="1" checked>
			</td>
								   
			<td colspan="4" align="right" style="padding-left:3px;padding-right:4px">			
			   <input type="submit" style="width:50" value="Add" class="button10g">
		    </td>
			    
			</TR>	
			
			<cfif parent.recordcount gt "0">	
			
			<tr bgcolor="f9f9f9"><td></td>
			
			<td></td>
			<td colspan="9" height="24" class="labelmedium">
			
			    Parent:
			    <select name="ParentCode" id="ParentCode" class="regularxl">
			       <cfoutput query="Parent">
				   <option value="#Code#">#Code#</option>
				   </cfoutput>
				</select>
			</td>
			</tr>	
			
			</cfif>
																
		</cfif>	
				
		<cfoutput>
		
		<cfloop query="Detail">
						
		<cfset nm  = ActionCode>
		<cfset par = ParentCode>
		<cfset de  = ActionDescription>
		<cfset op  = Operational>
												
		<cfif URL.ID2 eq nm>
		
		    <input type="hidden" name="ActionCode" id="ActionCode" value="<cfoutput>#par#</cfoutput>">
												
			<tr class="line" style="height:30px">				  
			   
			   <td width="2"></td>
			   <td class="labelit" height="26" style="padding-left:5px">#nm#</td>			  
			   <td style="padding-left:3px">
			   
			   	<cf_LanguageInput
						TableCode       = "Ref_EntityAction" 
						Mode            = "Edit"
						Name            = "ActionDescription"
						Value           = "#de#"
						Key1Value       = "#nm#"
						Type            = "Input"
						Required        = "Yes"
						Message         = "Please enter a description"
						MaxLength       = "80"
						Size            = "40"
						style           = "width:99%"
						Class           = "regularxl">				

	           </td>
			   <td style="padding-left:3px">
			      <cfinput type="Text" value="#ListingOrder#" style="text-align:center;height:25;width:30" name="ListingOrder" validate="integer" required="No" visible="Yes" enabled="Yes" size="1" maxlength="2" class="regularxl">
			   </td>			   
			   <td style="padding-left:3px">
			    <cfif ActionType neq "Create">
				<select name="ActionType" id="ActionType" class="regularxl" tyle="width:99%">
				   <option value="Action" <cfif ActionType eq "Action">selected</cfif>>Action</option>
				   <option value="Decision" <cfif ActionType eq "Decision">selected</cfif>>Decision</option>
				</select>
				<cfelse>
				<select name="ActionType" id="ActionType" class="regularxl" tyle="width:99%">
				   <option value="Action" <cfif ActionType eq "Create">selected</cfif>>Create</option>
				</select>
				</cfif>
			   </td>
			   <td align="center" style="padding-left:3px">
			   	<select name="ProcessMode" id="ProcessMode" style="width:99%" class="regularxl">				
					<option value="0" <cfif "0" eq ProcessMode>selected</cfif>>Single Dialog</option>									
					<option value="2" <cfif "2" eq ProcessMode>selected</cfif>>Window</option>						
					<option value="3" <cfif "3" eq ProcessMode>selected</cfif>>Browser tab</option>					
					<option value="1" <cfif "1" eq ProcessMode>selected</cfif>>Modal Dialog (IE11 only)</option>
				</select>			  
			   </td>
			   <td align="center" style="padding-left:3px">
			   	<input type="checkbox" class="radiol" name="EnableAccessFly" id="EnableAccessFly" value="1" <cfif "1" eq EnableAccessFly>checked</cfif>>
			   </td>
			   <td class="regular" align="center" style="padding-left:3px">
			      <input type="checkbox" class="radiol" name="Operational" id="Operational" value="1" <cfif "1" eq op>checked</cfif>>
				</td>
			   <td colspan="4" align="right" style="padding-left:3px">
			   <input type="submit" style="width:50" value="Save" class="button10s">
			   </td>
		    </TR>	
			
			<cfif parent.recordcount gt "0">
			
			<tr><td></td>
			    <td class="labelit">Parent:</td>
			    <td>
			    <select name="ParentCode" id="ParentCode" class="regularxl">
			       <cfloop query="Parent">
				   <option value="#Code#" <cfif #Code# eq "#par#">selected</cfif>>#Code#</option>
				   </cfloop>
				</select>
			    </td>
			</tr>
			
			</cfif>
								
		<cfelse>		
					
			<TR class="navigation_row line labelmedium" style="height:22px" bgcolor="<cfif ActionType eq 'Create'>ffffdf</cfif>">		   
			   
			   <td width="2"></td>
			   <td style="padding-left:5px" height="20">#nm#</td>			  
			   <td style="padding-left:3px">#de#</td>
			   <td>#ListingOrder#</td>
			   <td><cfif ActionType eq "Create"><b><font color="6688aa"></cfif>#ActionType#</td>
			   <td>
				<cfif "0" eq ProcessMode>Window
				<cfelseif ProcessMode eq "2">Tabbed&nbsp;Window
				<cfelseif ProcessMode eq "3">Browser tab
				<cfelse>Tabbed&nbsp;Modal
				</cfif>
			   </td>
			   <td align="center"><cfif EnableAccessFly eq "0"><b>N</b><cfelse>Y</cfif></td>
			   <td align="center"><cfif op eq "0"><b>N</b><cfelse>Y</cfif></td>
			   <td align="center" style="padding-top:1px">				   	   
			     <cf_img icon="edit" navigation="Yes" onclick="#ajaxLink('ActionRecords.cfm?EntityCode=#URL.EntityCode#&ID2=#nm#&search=#url.search#')#">	   											 
			   </td>
			   <td align="center" style="padding-top:3px;padding-left:2px;padding-right:2px">
			
				    <cfif Used eq "">	
					
						<cf_img icon="delete" onclick="#ajaxLink('ActionRecordsPurge.cfm?EntityCode=#URL.EntityCode#&ID2=#nm#')#">	   									
															 
					</cfif> 				
			 
			  </td>
			  
			  <td align="center">
			   			   
				 <img src="#SESSION.root#/Images/workflow_manager.gif"
			     alt="Workflows"
			     id="i#currentrow#_min"
			     border="0"
				 height="12"
				 width="12"
				 align="absmiddle"
			     class="regular"
			     style="cursor:pointer"
			     onClick="detail('#currentrow#','#actioncode#')">
				 
				<img src="#SESSION.root#/Images/icon_collapse.gif"
			     alt="Hide"
			     id="i#currentrow#_max"
			     border="0"
				 height="12"
				 width="12"
				 align="absmiddle"
			     class="hide"
			     style="cursor:pointer"
			     onClick="detail('#currentrow#','#actioncode#')">
			   
			   </td>
			   
			    <td align="center" style="padding-right:4px">

				<cfset box = replace(actioncode,"-","","ALL")> 
				<cfdiv id="embed#box#">									
					<cfinclude template="ActionRecordsEmbed.cfm">
				</cfdiv>
					   
			   </td>
			   
		    </TR>	
		
		</cfif>
		
		<tr id="boxdetail#currentrow#" class="hide">
		   <td colspan="12" id="detail#currentrow#"></td>
	    </tr>
		
		<tr id="boxobject#box#" class="hide">
		   <td colspan="12" id="object#box#"></td>
	    </tr>
						
		</cfloop>
		
		</cfoutput>									
									
		</table>
				
		</cfform>	
		
		</td>
		</tr>
					
	</table>		
	
<cfset ajaxonload("doHighlight")>
