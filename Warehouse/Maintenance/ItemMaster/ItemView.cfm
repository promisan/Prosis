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
<cfquery name="Item" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Item
	WHERE  ItemNo = '#URL.ID#' 
</cfquery>

<cfif Item.recordcount eq "0">

	<cfquery name="Item" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Item
	    WHERE  ItemNo = (SELECT ItemNo
						FROM   ItemUoM
						WHERE  ItemUoMId = '#URL.ID#' )
	</cfquery>
		
	<cfset url.id = Item.ItemNo>
	
</cfif>
 
<cfparam name="url.ID"       default="0000">
<cfparam name="url.Mission"  default="#Item.Mission#">
<cfparam name="url.idmenu"   default="">
<cfparam name="url.MID"      default="">

<cfif url.mission eq "">
	<cfset url.mission = item.Mission>
</cfif>

<cfinclude template="ItemViewScript.cfm">

<cf_dialogMaterial>
<cf_dialogProcurement>
<cf_annotationscript>
<cf_dialogOrganization>

<cf_calendarScript>
<cf_filelibraryscript>

<cfinclude template="ItemScript.cfm">

<cfajaximport tags="cfform">
	
<!--- variables that contain the selected menu function to be reloaded --->	
<input type="hidden" id="optionselect">	

<script language="JavaScript">

function toggleMenu(){

	t = document.getElementById('menuMaximized');
	if (t.className == 'show'){
		t.className = 'hide';
		t2 = document.getElementById('menuMinimized');
		t2.className = 'show';
	}else{
		t.className = 'show';
		t2 = document.getElementById('menuMinimized');
		t2.className = 'hide';
	}
}

</script>

<cfif url.mid eq "">

	<cfif url.idmenu eq "">
		<cfset vAccess = "No">
	<cfelse> 
		<cfset vAccess = "Yes">			
	</cfif>	

	<cf_screenTop border="0" 
      height="100%" 
	  label="#url.mission#: #Item.ItemDescription#" 
	  html="no"
	  layout="webapp"	
	  banner="gray"	     
	  band="No" 
	  line="no"
	  scroll="no" 
	  menuAccess="#vAccess#" 
	  jquery="Yes"
	  systemfunctionid="#url.idmenu#">
	  
<cfelse>

	<!--- we have an M which indicates the context --->

	<cf_screenTop border="0" 
      height="100%" 
	  label="#url.mission#: #Item.ItemDescription#" 
	  html="no"
	  layout="webapp"	
	  banner="gray"	   
	  band="No" 
	  line="no"
	  scroll="no" 
	  menuAccess="Context"
	  jquery="Yes" 
	  systemfunctionid="#url.idmenu#">

</cfif>	  

<cfif Item.recordcount eq "0">

	<table align="center"><tr><td align="center" style="padding-top:50px" class="labelmedium">Problem, item could not be located</td></tr></table>
	<cfabort>

</cfif>

<cf_layoutscript>

<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#" script="No">

	<cf_layoutArea position="header" name="theHeader">
		<cf_tl id="Stock Control" var="1">
		<cf_ViewTopMenu label="#Item.ItemDescription#" background="gray">
	</cf_layoutArea>

	<cf_layoutarea position="left" name="leftmenu" maxsize="300" size="230" collapsible="true" splitter="true">
			<cfinclude template="ItemViewMenu.cfm">		
	</cf_layoutarea>
	
	<cf_layoutarea  position="center" name="mainbox" overflow="auto">	
		
		<cf_divscroll>			
		<table width="100%" height="100%" class="formpadding">			    		
			<tr>				
				<td width="100%" valign="top" id="main">			
				   <cfinclude template="ItemViewHeader.cfm">					   			
				</td>
			</tr>
		</table>
		</cf_divscroll>
	   
	</cf_layoutarea>	
	
</cf_layout>		

<!---
   
<table width="100%" height="100%" cellspacing="0" cellpadding="0">

	<tr>
		<td height="100%" bgcolor="white">
			<table height="100%" width="100%" cellspacing="0" cellpadding="0">
			
			    <cfoutput>
								
				<tr>
				
					<td width="20" bgcolor="fafafa" height ="100%" align="left" id="menuMinimized" class="hide" valign="middle" style="border-bottom:1px solid silver;border-left:1px solid silver;border-top:1px solid silver;background-image:url('#SESSION.root#/Images/border.png'); background-repeat:repeat-y; background-position: top right; padding-left:7px; cursor:pointer;" onClick="javascript:toggleMenu()">
						<img src="#SESSION.root#/Images/collapse_right_menu.png">
					</td>
								
				   <td width="130" bgcolor="fafafa" height="100%" align="right" id="menuMaximized" class="show" valign="top" 
					   style="border-bottom:1px solid silver;border-left:1px solid silver;border-top:1px solid silver;background-image:url('#SESSION.root#/Images/border.png'); background-repeat:repeat-y; background-position: top right; padding-left:7px; padding-top:5px;">
					   
					   <table width="120">
					   
					   <tr style="cursor:pointer" onclick="toggleMenu()">
						   <td class="verdana"><cf_tl id="Options"></td>
						   <td align="right" style="padding-right:4px"><img src="#SESSION.root#/Images/collapse_left1.png"></td>						
					   </tr>
					   <tr><td height="6"></td></tr>
					   <tr><td colspan="2" class="line"></td></tr>
					   <tr><td height="3"></td></tr>
					   <tr><td colspan="2">
												
						<table width="100%" height="100%" cellspacing="0" cellpadding="0">
													
							<tr>			
								<td height="100%" id="tree" name="tree" valign="top">						  			
									<cfinclude template="ItemViewMenu.cfm">									
								</td>						
							</tr>						
						</table>	
						
					  </td>
					  </tr>
					  
					  </table>	
									
					  </td>							
									
					<td  align="center" id="main" 
					    name="main" valign="top" style="padding-top:6px; padding-bottom:6px; padding-left:10px; padding-right:10px">											  
						<cfinclude template="ItemViewHeader.cfm">										
					</td>		
				</tr>	
				
				</cfoutput>
				
			</table>			
		</td>
	</tr>			
</table>

--->

<cf_screenbottom layout="webdialog">  
	
