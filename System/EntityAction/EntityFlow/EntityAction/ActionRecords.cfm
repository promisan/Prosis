<!--
    Copyright © 2025 Promisan

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

<cfparam name="URL.search"      default="">
<cfparam name="URL.entityclass" default="">
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

<cfquery name="EntityClass" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT  TOP 1 *
    FROM    Ref_EntityClassPublish
	WHERE   EntityCode = '#URL.EntityCode#' 
    AND     EntityClass = '#URL.EntityClass#'	
	ORDER BY ActionPublishNo DESC
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
	<cfif url.entityclass neq "">
	AND    E.ActionCode IN (SELECT ActionCode
				 		    FROM   Ref_EntityActionPublish 
						    WHERE  ActionPublishNo = '#entityClass.ActionPublishNo#')
				
	
	<!---
	AND    E.ActionCode IN (SELECT EAP.ActionCode
				 		    FROM   Ref_EntityActionPublish AS EAP INNER JOIN
	                               Ref_EntityClassPublish AS ECP ON EAP.ActionPublishNo = ECP.ActionPublishNo 
						    WHERE  ECP.EntityCode = '#URL.EntityCode#' 
						    AND    ECP.EntityClass = '#URL.EntityClass#')
							
							--->
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
	
	<table width="100%" align="center">
	
	<tr>
	
	 <td colspan="4">	
	 
	 <table><tr>
	 
	  <td width="100" style="height:35;padding-left:6px" class="labelit"><cf_tl id="Used in class"></td>
	  
	 <td>
	 
	 <cfquery name="Class" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT       ECP.EntityClass, R.EntityClassName
			FROM         Ref_EntityActionPublish AS EAP INNER JOIN
                         Ref_EntityClassPublish AS ECP ON EAP.ActionPublishNo = ECP.ActionPublishNo INNER JOIN
                         Ref_EntityClass AS R ON ECP.EntityCode = R.EntityCode AND ECP.EntityClass = R.EntityClass
			WHERE        EAP.ActionCode IN
                             (SELECT      ActionCode
                               FROM       Ref_EntityAction
                               WHERE      EntityCode = '#URL.EntityCode#')
			GROUP BY ECP.EntityClass, R.EntityClassName
		</cfquery>
					
		<cfoutput>
		<select name="entityclass" id="entityclass" class="regularxxl" onchange="searching('#url.entitycode#',document.getElementById('find').value,this.value)">
		
			<option value=""><cf_tl id="Any"></option>
			<cfloop query="Class">
			   <option value="#EntityClass#" <cfif entityclass eq url.entityclass>selected</cfif>>#EntityClassName#</option>
			</cfloop>
		
		</select>	
		</cfoutput>
		 	     			   
		</td>
	
	 <td style="height:35;padding-left:6px;padding-right:5px" class="labelit"><cf_tl id="Find"></td>
	 
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
			       class     = "regularxxl">
			   
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
				 onclick     = "searching('#url.entitycode#',document.getElementById('find').value,document.getElementById('entityclass').value)">
			
		  </td> 
	      	  
	  </cfoutput>	   
	  
	  </table>
	  
	  </td>
		      
	</tr>
		      
	  <tr>
	    <td width="100%" colspan="4">
						
		<cfform action="ActionRecordsSubmit.cfm?Search=#url.search#&EntityClass=#url.entityclass#&EntityCode=#URL.EntityCode#&ID2=#URL.ID2#&search=#url.search#" 
		    method="POST" 
			name="action">
		
	    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="navigation_table">
			
	    <TR class="line labelmedium2 fixrow fixlengthlist">
		   
		   <td></td>
		   <td height="20"><cf_tl id="Code"></td>		  
		   <td><cf_tl id="Description"></td>
		   <td>S</td>
		   <td><cf_tl id="Class"></td>
		   <td title="The presentation of the action in the browser"><cf_tl id="Window"></td>
		   <td align="center" title="Allow Object Owner to grant access to users for this step on the object level">Fly.</td>
		   <td align="center" title="Enabled for embediding in new worflows">Op.</td>
		   <td align="right" colspan="4">
	         
			 <cfoutput>			 
			 <cfif URL.ID2 neq "new">
			     <A href="javascript:ptoken.navigate('ActionRecords.cfm?EntityCode=#URL.EntityCode#&search=#url.search#&entityclass=#url.entityclass#&ID2=new','actionrecords')"><cf_tl id="add"></a>
			 </cfif>			
			 </cfoutput>
			 
		   </td>	
		   	  
	    </TR>	
				
		<cfif URL.ID2 eq "new">
				   				
			<TR bgcolor="f9f9f9" class="line" style="height:34px">
			
			<td width="2"></td>
			<td height="24"><cf_space spaces="24">
			  <table><tr><td class="labelit"><cfoutput>#Entity.EntityAcronym#</cfoutput></td>
				<td>-</td>
				<td>
				
				<cfinput type="Text" value="" name="ActionCode" 
				   message="You must enter a unique action code" 
				   required="Yes" 
				   maxlength="4" 
				   class="regularxl" 
				   onkeyUp="_cf_loadingtexthtml='';ptoken.navigate('getCodeCheck.cfm?entitycode=#url.entitycode#&value='+this.value,'codecheck')"
				   style="width:45px;background-color:ffffaf;text-align:center">
				   
				</td>
				
				<td id="codecheck" align="center" style="min-width:20px;"></td>
				
				</tr>
				</table> 
	        </td>
			
			<td style="padding-left:3px;border-left:1px solid silver">
			  					
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
					style           = "width:99%;border:0px;"
					Class           = "regularxl">					
					
			</td>
			
			<td style="padding-left:1px;border-left:1px solid silver;min-width:30px">
						
				   <cfinput type="text" 
			         name="ListingOrder" 
					 size="1" 					
					 maxlength="2" 
					 class="regularxl" 
					 style="text-align:center;width:25;width:99%;border:0px" 
					 validate="integer" 
					 visible="Yes" 
					 enabled="Yes">
					 
			</td>
			
			<td style="padding-left:3px;border-left:1px solid silver">
						 
				<select name="ActionType" id="ActionType" class="regularxl" style="width:95%;border:0px">
				<cfif Check.recordcount eq "0" and Entity.EnableCreate eq "1">
				<option value="Create">Create</option>
				</cfif>
				<option value="Action" selected>Action</option>
				<option value="Decision">Decision</option>
				</select>
			</td>
			
			<td align="center" style="padding-left:3px;border-left:1px solid silver">
				<select name="ProcessMode" id="ProcessMode" class="regularxl" style="width:99%;border:0px">				
					<option value="0">Single Dialog [legacy]</option>	
					<option value="1" selected>Modal Dialog (Kendo)</option>								
					<option value="2">Window</option>		
					<option value="3">Browser Tab</option>		
					<option value="4">Browser Tab with right panel</option>							
				</select>
				
			</td>
			
			<td align="center" style="padding-left:3px;border-left:1px solid silver">
				<input type="checkbox" class="radiol" name="EnableAccessFly" id="EnableAccessFly" value="1" checked>
			</td>
			
			<td align="center" style="padding-left:3px;border-left:1px solid silver">
				<input type="checkbox" class="radiol" name="Operational" id="Operational" value="1" checked>
			</td>
								   
			<td colspan="4" align="right" style="padding-left:3px;padding-right:4px;border-left:1px solid silver">			
			   <input type="submit" style="width:50" value="Add" class="button10g">
		    </td>
			    
			</TR>	
			
			<cfif parent.recordcount gt "0">	
			
			<tr><td></td><td style="padding-left:8px;height:30px;" class="labelmedium">Parent:</td>
			    <td colspan="9" height="24" class="labelmedium">
			    <select name="ParentCode" id="ParentCode" class="regularxl" style="border:0px">
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
												
			<tr class="line" class="labelmedium2" style="padding:0px;height:30px">				  
			   
			   <td width="2"></td>
			   <td height="26" style="padding-left:2px">#nm#</td>			  
			   <td style="padding-left:3px;border-left:1px solid silver">
			   
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
						style           = "width:99%;border:0px"
						Class           = "regularxl">				

	           </td>
			   <td style="padding-left:3px;border-left:1px solid silver">
			      <cfinput type="Text" value="#ListingOrder#" style="text-align:center;height:25;width:30;border:0px" name="ListingOrder" validate="integer" required="No" visible="Yes" enabled="Yes" size="1" maxlength="2" class="regularxl">
			   </td>			   
			   <td style="padding-left:3px;border-left:1px solid silver">
			   
			    <cfif ActionType neq "Create">
				<select name="ActionType" id="ActionType" class="regularxl" style="width:96%;border:0px">
				   <option value="Action" <cfif ActionType eq "Action">selected</cfif>>Action</option>
				   <option value="Decision" <cfif ActionType eq "Decision">selected</cfif>>Decision</option>
				</select>
				<cfelse>
				<select name="ActionType" id="ActionType" class="regularxl" style="width:96%;border:0px">
				   <option value="Action" <cfif ActionType eq "Create">selected</cfif>>Create</option>
				</select>
				</cfif>
			   </td>
			   <td align="center" style="padding-left:3px;border-left:1px solid silver">
			   	<select name="ProcessMode" id="ProcessMode" style="min-width:200px;border:0px" class="regularxl">				
					<option value="0" <cfif "0" eq ProcessMode>selected</cfif>>Single Dialog</option>									
					<option value="2" <cfif "2" eq ProcessMode>selected</cfif>>Window</option>						
					<option value="3" <cfif "3" eq ProcessMode>selected</cfif>>Browser tab</option>			
					<option value="4" <cfif "4" eq ProcessMode>selected</cfif>>Browser tab with right panel</option>				
					<option value="1" <cfif "1" eq ProcessMode>selected</cfif>>Modal Dialog (Kendo)</option>
				</select>			  
			   </td>
			   <td align="center" style="padding-left:3px;border-left:1px solid silver">
			   	<input type="checkbox" class="radiol" name="EnableAccessFly" id="EnableAccessFly" value="1" <cfif "1" eq EnableAccessFly>checked</cfif>>
			   </td>
			   <td align="center" style="padding-left:3px;border-left:1px solid silver">
			      <input type="checkbox" class="radiol" name="Operational" id="Operational" value="1" <cfif "1" eq op>checked</cfif>>
				</td>
			   <td colspan="4" align="right" style="padding-left:3px;border-left:1px solid silver">
			   <input type="submit" style="width:50" value="Save" class="button10g">
			   </td>
		    </TR>	
			
			<cfif parent.recordcount gt "0">
			
			<tr><td></td>
			    <td style="padding-left:8px;height;30px" class="labelmedium"><cf_tl id="Parent">:</td>
			    <td>
			    <select name="ParentCode" id="ParentCode" class="regularxl" style="border:0px">
			       <cfloop query="Parent">
				   <option value="#Code#" <cfif Code eq "#par#">selected</cfif>>#Code#</option>
				   </cfloop>
				</select>
			    </td>
			</tr>
			
			</cfif>
								
		<cfelse>		
					
			<TR class="navigation_row line labelmedium2 fixlengthlist" style="height:22px;padding:0px" bgcolor="<cfif ActionType eq 'Create'>ffffdf</cfif>">		   
			   
			   <td width="2"></td>
			   <td>#nm#</td>			  
			   <td style="padding-left:3px">#de#</td>
			   <td>#ListingOrder#</td>
			   <td><cfif ActionType eq "Create"><font color="6688aa"></cfif>#ActionType#</td>
			   <td>
				<cfif "0" eq ProcessMode>Window
				<cfelseif ProcessMode eq "2">Tabbed&nbsp;Window
				<cfelseif ProcessMode eq "3">Browser&nbsp;tab
				<cfelseif ProcessMode eq "4">Browser&nbsp;panel&nbsp;tab
				<cfelse>Modal&nbsp;(Kendo)
				</cfif>
			   </td>
			   <td align="center"><cfif EnableAccessFly eq "0"><b>N</b><cfelse>Y</cfif></td>
			   <td align="center"><cfif op eq "0"><b>N</b><cfelse>Y</cfif></td>
			   <td align="center" style="padding-top:1px">				   	   
			     <cf_img icon="edit" navigation="Yes" onclick="_cf_loadingtexthtml='';ptoken.navigate('ActionRecords.cfm?EntityCode=#URL.EntityCode#&ID2=#nm#&search=#url.search#&entityclass=#url.entityclass#','actionrecords')">	   											 
			   </td>
			   <td align="center" style="padding-left:2px;padding-right:2px">
			
				    <cfif Used eq "">	
					
						<cf_img icon="delete" onclick="_cf_loadingtexthtml='';	ptoken.navigate('ActionRecordsPurge.cfm?EntityCode=#URL.EntityCode#&ID2=#nm#','actionrecords')">	   									
															 
					</cfif> 				
			 
			  </td>
			  
			  <td align="center">
			  
			  	<table>
				<tr>
				<td>
			   			   
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
				 </tr>
				 </table>
			   
			   </td>
			   
			    <td align="center" style="padding-left:3px;padding-right:4px">

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
		
		<!---
		<tr id="boxobject#box#" class="hide">
		   <td colspan="12" id="object#box#"></td>
	    </tr>
		--->
						
		</cfloop>
		
		</cfoutput>									
									
		</table>
				
		</cfform>	
		
		</td>
		</tr>
					
	</table>		
	
<cfset ajaxonload("doHighlight")>
