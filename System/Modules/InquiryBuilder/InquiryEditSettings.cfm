
<cfoutput>

<table width="99%" class="formpadding formspacing" cellspacing="0" cellpadding="0" align="center">
			
	<tr id="detailfunction" class="#cl#">
		
		<cf_UIToolTip tooltip="Adds a filter section to the inquiry listing">
		<td class="labelmedium" height="24">Enable&nbsp;Filtering:</td>
		</cf_UIToolTip>
				
		<td class="labelmedium">
				
		  <select class="regularxl" name="FilterShow" id="FilterShow" style="font:10px">
			<option value="1" <cfif List.FilterShow eq "1">selected</cfif>>Yes</option>
			<option value="0" <cfif List.FilterShow eq "0">selected</cfif>>No</option>
		   </select>
		   
		</td>
			
	</tr>		
	
	<tr>
		  <td  height="24" class="labelmedium">Drilldown mode:</td>
			<td class="labelmedium">
			   <select name="DrillMode" id="DrillMode" class="regularxl" onchange="embedding(this.value)">
				<option value="None"         <cfif List.DrillMode eq "None">selected</cfif>>Not applicable</option>
				<option value="Default"      <cfif List.DrillMode eq "Default">selected</cfif>>Show All fields</option>
				<option value="Workflow"     <cfif List.DrillMode eq "Workflow">selected</cfif>>Workflow Object</option>
				<option value="Embed"        <cfif List.DrillMode eq "Embed">selected</cfif>>Embed</option>
				<option value="Tab"          <cfif List.DrillMode eq "Tab">selected</cfif>>Tab</option>
				<!---
				<option value="Dialog"       <cfif List.DrillMode eq "Dialog">selected</cfif>>Window Modal Dialog (IE and FF)</option>	
				--->
				<option value="DialogAjax"   <cfif List.DrillMode eq "DialogAjax">selected</cfif>>CFwindow</option>					
				<option value="Window"       <cfif List.DrillMode eq "Window">selected</cfif>>Window (single)</option>						
				<option value="SecureWindow" <cfif List.DrillMode eq "SecureWindow" or List.DrillMode eq "Window">selected</cfif>>Window (multiple)</option>		
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
		<td class="labelmedium" style="padding-left:10px" height="24">Template Edit/Inquiry:</td>
		<td>
		
		<table cellspacing="0" cellpadding="0">
		
		<tr>
			<td>
			
				<table style="border:1px solid silver" cellspacing="0" cellpadding="0">

					<tr><td>
						<cfinput type="text" 
						       name="drilltemplate" 
							   value="#list.DrillTemplate#" 
							   class="regularxl" 
							   style="padding-left:3px;border:0px"
							   size="100" 
							   maxlength="100"
						       onblur= "ColdFusion.navigate('#SESSION.root#/System/Modules/InquiryBuilder/TemplateValidation.cfm?template='+this.value,'dDrillTemplate')">
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
		<td style="padding-left:3px">
				  <cfdiv id="dDrillTemplate" 
					bind="url:#SESSION.root#/System/Modules/InquiryBuilder/TemplateValidation.cfm?template=#list.InsertTemplate#" />
		</td>
		</tr>
		</table>
		</td>
	
	</tr>
	
	<tr id="detailfunction" class="#cl#">
		
		<cf_UIToolTip tooltip="Record Insert Template">
			<td class="labelmedium" style="padding-left:10px" height="23">Template Insert:</td>
		</cf_UIToolTip>
		
		<td>
		<table cellspacing="0" cellpadding="0">
		<tr class="#cl#">
	
		<td>
		
			<cfinput type="text" 
			       name="InsertTemplate" 
				   value="#list.InsertTemplate#" 
				   class="regularxl" 
				   size="100" 
				   maxlength="150" 
				   onblur= "ColdFusion.navigate('#SESSION.root#/System/Modules/InquiryBuilder/TemplateValidation.cfm?template='+this.value,'dInsertTemplate')">
				   
		</td>
		<td style="padding-left:3px">
			
			   <cfdiv id="dInsertTemplate" 
				bind="url:#SESSION.root#/System/Modules/InquiryBuilder/TemplateValidation.cfm?template=#list.InsertTemplate#" />

		</td>
		
		</tr>
		</table>
		</td>
	
	</tr>		
	
	<cfset row = 0>
	
	<cfloop index="itm" list="#List.DrillArgument#" delimiters=";">
	   <cfset row = row+1>
	   <cfset val[row] = itm>	
	</cfloop>
	
	<tr name="template" id="template" class="#cls#">
		<td width="180" height="24" style="padding-left:10px" class="labelmedium">Dialog Arguments:</td>
		<td>
		<table border="0" cellspacing="0" cellpadding="0" width="400">
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
	
	<tr id="detailfunction" class="#cl#"  height="24">
		
	<td colspan="2">
	
		<table cellspacing="0" cellpadding="0">
		
		<tr>
		  <td style="height:30px" width="190"  class="labelmedium"><cf_UIToolTip tooltip="requires Key field">Enable Deletion on:</cf_UIToolTip></td>
		  <td>
	
	   	  <cf_securediv id="table" 
	       bind="url:#SESSION.root#/System/Modules/InquiryBuilder/SubTable.cfm?systemfunctionid=#url.systemfunctionid#&functionserialno=#url.functionserialno#&datasource={querydatasource}">
		   
		   </td>
		   
		   <td style="padding-left:20px;height:30px" class="labelmedium">Show Annotation:</td>
		   <td>
			   <cf_securediv id="annotation" 
			       bind="url:#SESSION.root#/System/Modules/InquiryBuilder/Annotation.cfm?systemfunctionid=#url.systemfunctionid#&functionserialno=#url.functionserialno#&datasource={querydatasource}">
		   </td>		   		   
	     		   
		   <td style="padding-left:20px;height:30px"  class="labelmedium">Show Excel Export:</td>
		   
		   <td style="padding-left:10px">
		   	
			<table cellspacing="0" cellpadding="0">
		   <tr>
		   <cfparam name="val[5]" default="false">
		   <td style="padding-left:4px"><input type="radio" name="ExcelExport" id="DrillExport" value="true" <cfif val[5] eq "true">checked</cfif>></td><td class="labelmedium" style="padding-left:4px">Yes</td>
		   <td style="padding-left:4px"><input type="radio" name="ExcelExport" id="ExcelExport" value="false" <cfif val[5] neq "true">checked</cfif>></td><td class="labelmedium" style="padding-left:4px">No</td>
		   </tr></table></td>
		 	   		   
	    </tr>				
		
	   </table>
		
	</td>
	</tr>	
	
</table>

</cfoutput>	