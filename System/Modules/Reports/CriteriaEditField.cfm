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
<cfquery name="Get" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ReportControlCriteria 
	WHERE  ControlId = '#URL.ID#'
	AND    CriteriaName = '#URL.ID1#'
</cfquery>

<cftry>
		
	<cfquery name="FieldNames" 
		datasource="#url.ds#">
    	SELECT  TOP 1 * FROM    #URL.ID2# 
	</cfquery>	
			
	<cfset lk = "1">
		
	<cfcatch>  <cfset lk = "0">  </cfcatch>
		
</cftry>

    <table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">
		
	<cfif lk eq "0">
	
		<tr><td height="6"></td></tr>
		<tr><td valign="middle" class="regular">			
			<font color="red"><b>Alert:</b></font> Lookup table/view does not exist
			</td>
		</td>	
		
	<cfelse>
	
		<tr><td>
		
		<table width="100%" border="0" class="formspacing">
				
		<tr>
		
		   <td width="120" class="labelit">
		   <cf_UIToolTip tooltip="Field that will be passed to the report preparation script">
		   <img src="<cfoutput>#SESSION.root#</cfoutput>/Images/key1.gif" alt="" border="0" align="absmiddle">
		   <cf_tl id="Key Field"></cf_UIToolTip></td>
		  
		   <td height="24" width="80%">
		
		   <cfset v = "">		   	
		   <select class="regularxl" name="lookupfieldvalue" id="lookupfieldvalue" style="width:70%" onchange="extended('<cfoutput>#url.id1#</cfoutput>',lookuptable.value,'0',lookupdatasource.value,this.value)">
		   	  <option value="">-- Select a Key field value --	
			  <cfoutput>
			  <cfloop index="col" list="#FieldNames.columnList#" delimiters=",">
			      <cfif v eq "">
				      <cfset v = col>
				  </cfif>
				  <option value="#col#" <cfif col eq get.LookupFieldValue>selected</cfif>>#col#</option> 
			  </cfloop>
			  </cfoutput>
		   </select>
		    
		   
		   </td>
		   
		   </tr>
		  
		   <cfif get.criteriatype neq "Text" and get.CriteriaType neq "TextList" and get.CriteriaType neq "Extended">
		   
			   <tr>
			   	<td width="120" class="labelit" height="24"><cf_tl id="Sorting"></td>
			    <td>
				
				<cfset v = "">		   	
			    <select name="lookupfieldsorting" id="lookupfieldsorting" style="width:70%" class="regularxl">
			   	  <option value="" selected>--Same as Key Field--</option> 
				  <cfoutput>
				  <cfloop index="col" list="#FieldNames.columnList#" delimiters=",">
				      <cfif v eq "">
					      <cfset v = col>
					  </cfif>
					  <option value="#col#" <cfif col eq get.LookupFieldSorting>selected</cfif>>#col#</option> 
				  </cfloop>
				  </cfoutput>
			    </select>
			  
				</td>
			   </tr>
			   
			   <tr>
			  
			   <td width="120" height="24" class="labelit">Display:</td>
			   <td>
			   <cfset v = "">
			   <select name="lookupfielddisplay" id="lookupfielddisplay" class="regularxl" style="width:70%">
				  <cfoutput>
				  <cfloop index="col" list="#FieldNames.columnList#" delimiters=",">
				      <cfif v eq "">
					      <cfset #v# = #col#>
					  </cfif>
					  <option value="#col#" <cfif col eq get.LookupFieldDisplay>selected</cfif>>#col#</option> 
				  </cfloop>
				  </cfoutput>
			    </select>
													
				</td>			
				</tr>	
						
				<tr>
				<td colspan="2">	
					
				<cfoutput>
				<input type="button" name="Check" class="button10g" id="Check" style="width:150px" value="Check Lookup" onClick="checklookup('#Get.criterianame#', lookupfieldvalue.value, lookupfielddisplay.value,lookupfieldsorting.value, '#URL.ID2#','#URL.ds#')">
				</cfoutput>	
				</td>
				
				</tr>
					
			<cfelse>
			
				<input type="hidden" name="lookupfieldsorting" id="lookupfieldsorting">
				<input type="hidden" name="lookupfielddisplay" id="lookupfielddisplay">
			
			</cfif>		
							
			<tr><td height="1"></td></tr>		
				
		</table>
		</td></tr>
		
	</cfif>
	</table>
	