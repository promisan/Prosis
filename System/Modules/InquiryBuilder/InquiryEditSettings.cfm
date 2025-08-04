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

<cfoutput>

<cfset row = 0>
	
<cfloop index="itm" list="#List.DrillArgument#" delimiters=";">
   <cfset row = row+1>
   <cfset val[row] = itm>	
</cfloop>

<table width="100%" class="formpadding" align="center">
<tr><td valign="top">

<table  align="center" style="width:100%;border:1px solid silver">
			
	<tr id="detailfunction" class="#cl#">			
								
		<td colspan="2">
		
			<table style="width:100%;border:0px solid silver">
			
			<tr class="labelmedium2 fixlengthlist line">
			
			<cf_UIToolTip tooltip="Adds a filter section to the inquiry listing">
				<td style="background-color:f1f1f1" height="24"><cf_tl id="Filter">:</td>
			</cf_UIToolTip>
			
			   <td>
			
			  <select class="regularxl" name="FilterShow" id="FilterShow" style="border:0px">
				<option value="1" <cfif List.FilterShow eq "1">selected</cfif>>Yes</option>
				<option value="0" <cfif List.FilterShow eq "0">selected</cfif>>No</option>
			   </select>
			   
			   </td>
				
					
			  <td style="border-left:1px solid silver;background-color:f1f1f1"><cf_UIToolTip tooltip="requires Key field">Delete:</cf_UIToolTip></td>
			  <td>
				
				   	  <cf_securediv id="table" 
					       bind="url:#SESSION.root#/System/Modules/InquiryBuilder/SubTable.cfm?systemfunctionid=#url.systemfunctionid#&functionserialno=#url.functionserialno#&datasource={querydatasource}">
						   
			   </td>
					   
			   <td style="border-left:1px solid silver;background-color:f1f1f1">Annotation:</td>
			   <td>
					   
					   <cf_securediv id="annotation" 
					       bind="url:#SESSION.root#/System/Modules/InquiryBuilder/Annotation.cfm?systemfunctionid=#url.systemfunctionid#&functionserialno=#url.functionserialno#&datasource={querydatasource}">
							   
			   </td>		   		   
				     		   
			   <td style="border-left:1px solid silver;background-color:f1f1f1">Excel:</td>
					   
			   <td>
					   	
					   <table cellspacing="0" cellpadding="0">
						   <tr class="labelmedium2">
						   <cfparam name="val[5]" default="false">
						   <td><input type="radio" name="ExcelExport" id="ExcelExport" value="true" <cfif val[5] eq "true">checked</cfif>></td><td style="padding-left:4px">Yes</td>
						   <td style="padding-left:4px"><input type="radio" name="ExcelExport" id="ExcelExport" value="false" <cfif val[5] neq "true">checked</cfif>></td><td style="padding-left:4px">No</td>
						   </tr>
					   </table>
					   
				</td>
					   
				</tr>
					   
				<tr class="labelmedium2 fixlengthlist line"> 
				
					   <td style="background-color:f1f1f1">Auto filter:</td>
					   
					   <td>
					   	
						   <table cellspacing="0" cellpadding="0">
						   <tr class="labelmedium2">
						   
						   <cfparam name="val[8]" default="auto">						  
						   <td style="padding-left:4px"><input type="radio" name="AutoFilter" id="AutoFilter" value="manual" <cfif val[8] eq "manual">checked</cfif>></td><td style="padding-left:4px">Manual</td>
						   <td style="padding-left:4px"><input type="radio" name="AutoFilter" id="AutoFilter" value="auto" <cfif val[8] eq "auto">checked</cfif>></td><td style="padding-left:4px">Auto</td>
						   </tr>
						   </table>
					   
					   </td>
					   
					   <td style="border-left:1px solid silver;background-color:f1f1f1">Disable cache:</td>
					   
					   <td>
					   	
						   <table cellspacing="0" cellpadding="0">
						   <tr class="labelmedium2">
						   <cfparam name="val[7]" default="false">
						   <td><input type="radio" name="CacheDisable" id="CacheDisable" value="true" <cfif val[7] eq "true">checked</cfif>></td><td style="padding-left:4px">Yes</td>
						   <td style="padding-left:4px"><input type="radio" name="CacheDisable" id="CacheDisable" value="false" <cfif val[7] neq "true">checked</cfif>></td><td style="padding-left:4px">No</td>
						   </tr>
						   </table>
					   
					   </td>
					  						   
					   <td style="border-left:1px solid silver;background-color:f1f1f1">Scroll:</td>
					   
					   <td>
					   	
						   <table cellspacing="0" cellpadding="0">
						   <tr class="labelmedium2">
						   
						   <cfparam name="val[6]" default="paging">						  
						   <td style="padding-left:4px"><input type="radio" name="Scrolling" id="Scrolling" value="paging" <cfif val[6] eq "paging">checked</cfif>></td><td style="padding-left:4px">Paging</td>
						   <td style="padding-left:4px"><input type="radio" name="Scrolling" id="Scrolling" value="auto" <cfif val[6] neq "paging">checked</cfif>></td><td style="padding-left:4px">Continuous</td>
						   </tr>
						   </table>
					   
					   </td>
								
			</tr>	
			
			</table>
				   
		</td>		
			
	</tr>	
	
	<!---	
	<tr class="labelmedium line"><td colspan="2" style="font-size:16px"><cf_tl id="Details"></td></tr>	
	--->
		
	<tr class="line fixlengthlist">
		  <td style="height:34px;padding-left:10px" class="labelmedium">Drilldown mode:</td>
			<td class="labelmedium">
			   <select name="DrillMode" id="DrillMode" class="regularxl" onchange="embedding(this.value)">
				<option value="None"         <cfif List.DrillMode eq "None">selected</cfif>>Not applicable</option>
				<option value="Default"      <cfif List.DrillMode eq "Default">selected</cfif>>Embed : Show All fields</option>
				<option value="Workflow"     <cfif List.DrillMode eq "Workflow">selected</cfif>>Embed : Workflow Object</option>
				<option value="Embed"        <cfif List.DrillMode eq "Embed">selected</cfif>>Embed : Template</option>
				<option value="Tab"          <cfif List.DrillMode eq "Tab">selected</cfif>>Tab : Template</option>
				<!---
				<option value="Dialog"       <cfif List.DrillMode eq "Dialog">selected</cfif>>Window Modal Dialog (IE and FF)</option>	
				--->
				<option value="DialogAjax"   <cfif List.DrillMode eq "DialogAjax">selected</cfif>>Kendo window : Template</option>		
				<!---			
				<option value="Window"       <cfif List.DrillMode eq "Window">selected</cfif>>Window (single)</option>						
				--->
				<option value="SecureWindow" <cfif List.DrillMode eq "SecureWindow" or List.DrillMode eq "Window">selected</cfif>>Window : Template</option>		
			   </select>
			</td>	
	</tr>		
			
	<cfif List.drillmode neq "">

		<cfif List.drillmode neq "None" or List.drillmode neq "Default">
		 	<cfset cls = "regular">
		<cfelse> 
			<cfset cls = "hide">
		</cfif>
		
	<cfelse>
	
		<cfset cls = "hide">
	
	</cfif>	
		
	<tr name="template" id="template" class="#cls#">
	
		<td class="labelmedium" style="padding-left:10px;height:34px">Template Edit/Inquiry:</td>
		<td>
		
		<table>
		
		<tr>
			<td style="padding-left:4px">
			
				<table style="border:1px solid silver" cellspacing="0" cellpadding="0">

					<tr><td>
						<cfinput type="text" 
						       name="drilltemplate" 
							   value="#list.DrillTemplate#" 
							   class="regularxl" 
							   style="padding-left:3px;border:0px"
							   size="100" 
							   maxlength="100"
						       onblur= "ptoken.navigate('#SESSION.root#/System/Modules/InquiryBuilder/TemplateValidation.cfm?template='+this.value,'dDrillTemplate')">
					</td>
					
					<td align="right" style="padding-top:1px;padding-bottom:1px">		
					 	   <img src="#SESSION.root#/Images/select6.jpg"
						     name="img5"
						     id="img5"
						     border="0"
							 style="height:25;width:25"
							 align="absmiddle"
						     style="cursor: pointer;"
						     onClick="selectdrilltemplate()"
						     onMouseOver="document.img5_src='#SESSION.root#/Images/select6b.jpg'"
						     onMouseOut="document.img5_src='#SESSION.root#/Images/select6.jpg'">	
					</td>
					</tr>
				</table>		 		
	
			</td>
		<td style="padding-left:4px">
				  <cf_securediv id="dDrillTemplate" 
					bind="url:#SESSION.root#/System/Modules/InquiryBuilder/TemplateValidation.cfm?template=#list.InsertTemplate#" />
		</td>
		</tr>
		</table>
		</td>
	
	</tr>
	
	<tr id="detailfunction" class="#cl#">
		
		<cf_UIToolTip tooltip="Record Insert Template">
			<td class="labelmedium" style="padding-left:10px;height:34px">Template Insert:</td>
		</cf_UIToolTip>
		
		<td style="padding-left:4px">
		<table cellspacing="0" cellpadding="0">
		<tr class="#cl#">
	
		<td>
		
			<cfinput type="text" 
			       name="InsertTemplate" 
				   value="#list.InsertTemplate#" 
				   class="regularxl" 
				   size="100" 
				   maxlength="150" 
				   onblur= "ptoken.navigate('#SESSION.root#/System/Modules/InquiryBuilder/TemplateValidation.cfm?template='+this.value,'dInsertTemplate')">
				   
		</td>
		<td style="padding-left:3px">
			
			   <cf_securediv id="dInsertTemplate" 
				bind="url:#SESSION.root#/System/Modules/InquiryBuilder/TemplateValidation.cfm?template=#list.InsertTemplate#">

		</td>
		
		</tr>
		</table>
		</td>
	
	</tr>		
	
	<tr name="template" id="template" class="#cls#">
		<td width="180" height="24" style="padding-left:10px" class="labelmedium">Dialog Arguments:</td>
		<td>
		<table border="0" cellspacing="0" cellpadding="0" width="400" style="height:34px">
		<tr>
		   <td class="labelmedium">Height:</td>
		   <cfparam name="val[1]" default="800">
		   <td style="padding-left:4px"><input type="text" class="regularxl" style="width:40;text-align:center" name="DrillArgumentHeight" id="DrillArgumentHeight" maxlength="4" value="#val[1]#"></td>
		   
		   <td style="padding-left:2px" class="labelmedium">Width:</td>
		   <cfparam name="val[2]" default="800">
		   <td style="padding-left:4px"><input type="text" class="regularxl" style="width:40;text-align:center" name="DrillArgumentWidth" id="DrillArgumentWidth" maxlength="4" value="#val[2]#"></td>
		  		     
		   <td style="padding-left:8px" class="labelmedium">Modal:</td>		   
		   <cfparam name="val[3]" default="false">
		   <td style="padding-left:5px"><input type="radio" name="DrillArgumentModal" id="DrillArgumentModal" value="true" <cfif val[3] eq "true">checked</cfif>></td><td class="labelmedium" style="padding-left:2px">Yes</td>
		   <td style="padding-left:5px"><input type="radio" name="DrillArgumentModal" id="DrillArgumentModal" value="false" <cfif val[3] neq "true">checked</cfif>></td><td class="labelmedium" style="padding-left:2px">No</td>
		  
		   <td style="padding-left:8px" class="labelmedium">Centered:</td>
		   <cfparam name="val[4]" default="false">
		   <td style="padding-left:5px"><input type="radio" name="DrillArgumentCenter" id="DrillArgumentCenter" value="true" <cfif val[4] eq "true">checked</cfif>></td><td class="labelmedium" style="padding-left:4px">Yes</td>
		   <td style="padding-left:5px"><input type="radio" name="DrillArgumentCenter" id="DrillArgumentCenter" value="false" <cfif val[4] neq "true">checked</cfif>></td><td class="labelmedium" style="padding-left:4px">No</td>
		  		   
		</tr>
		</table>		 		
		</td>
	
	</tr>	
			
</table>

</td>
</tr>
</table>

</cfoutput>	