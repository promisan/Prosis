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
datasource="#url.alias#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
<cfif systemmodule eq "Roster">
	
		SELECT Topic as Code, Parent as TopicClass, *
		FROM   Ref_Topic
		WHERE  Topic = '#URL.ID#'
	
	<cfelse>
	
	    SELECT    *
    	FROM      Ref_Topic	
		WHERE     Code = '#URL.ID#'
	
	</cfif>
</cfquery>

<cftry>
		
	<cfquery name="FieldNames" 
	datasource="#url.ds#">
    SELECT  TOP 1 * FROM #URL.ID2#
	 </cfquery>	
			
	<cfset lk = "1">
		
	<cfcatch>  <cfset lk = "0">  </cfcatch>
		
</cftry>

    <table width="100%" class="formpadding" align="left">
		
	<cfif lk eq "0">
			
		<tr><td class="regular">			
			<!--- <font color="red"><b>Alert:</b></font> Lookup table/view does not exist --->
			</td>
		</td>	
		
	<cfelse>
		  
	
		<tr><td>
		
		<table border="0" class="formpadding" cellspacing="0" cellpadding="0">
				
		<tr>
		
		   <td class="labelmedium" width="127"><cf_UIToolTip tooltip="Field that will be passed">
		   Key Value</cf_UIToolTip>
		   </td>		
		  
		   <td height="24">
		
		   <cfset v = "">		   	
		   <select name="listPK" id="listPK" style="width:70%" class="regularxl">
			  <cfoutput>
			  <cfloop index="col" list="#FieldNames.columnList#" delimiters=",">
			      <cfif v eq "">
				      <cfset v = col>
				  </cfif>
				  <option value="#col#" <cfif col eq get.ListPK>selected</cfif>>#col#</option> 
			  </cfloop>
			  </cfoutput>
		   </select>
		  	    		   
		   </td>
		   
		   </tr>
		 	   
		    <tr>
			   	<td class="labelmedium" width="120" height="24">Sorting</td>
			    <td>
				
				<cfset v = "">		   	
			    <select name="listOrder" id="listOrder" style="width:70%" class="regularxl">
			   	  <option value="" selected>--Same as Key Field--</option> 
				  <cfoutput>
				  <cfloop index="col" list="#FieldNames.columnList#" delimiters=",">
				      <cfif v eq "">
					      <cfset v = col>
					  </cfif>
					  <option value="#col#" <cfif col eq get.ListOrder>selected</cfif>>#col#</option> 
				  </cfloop>
				  </cfoutput>
			    </select>
			  
				</td>
			   </tr>
			   
			   <tr>
			  
			   <td class="labelmedium" width="120" height="24">Display:</td>
			   <td>
			   <cfset v = "">
			   <select name="listdisplay" id="listdisplay" style="width:70%" class="regularxl">
				  <cfoutput>
				  <cfloop index="col" list="#FieldNames.columnList#" delimiters=",">
				      <cfif v eq "">
					      <cfset #v# = #col#>
					  </cfif>
					  <option value="#col#" <cfif col eq get.ListDisplay>selected</cfif>>#col#</option> 
				  </cfloop>
				  </cfoutput>
			    </select>
									
				</td>			
				</tr>	
				
				<tr>
			   	<td class="labelmedium" width="120" height="24">Grouping:</td>
			    <td>
				
					<cfset v = "">		   	
				    <select name="listGroup" id="listGroup" style="width:70%" class="regularxl">
				   	  <option value="" selected>n/a</option> 
					  <cfoutput>
					  <cfloop index="col" list="#FieldNames.columnList#" delimiters=",">
					      <cfif v eq "">
						      <cfset v = col>
						  </cfif>
						  <option value="#col#" <cfif col eq get.ListGroup>selected</cfif>>#col#</option> 
					  </cfloop>
					  </cfoutput>
				    </select>			  
					
				</td>
			   </tr>
			   
			   <tr>
			   	<td class="labelmedium" width="120" height="24">Filter:</td>
			    <td>	
				<cfoutput>							
					<input type="text" class="regularxl" name="ListCondition" id="ListCondition" value="#get.ListCondition#" size="50" maxwidth="100">				  
				</cfoutput>
				</td>
			   </tr>						
										
			<tr><td height="1"></td></tr>		
				
		</table>
		</td></tr>		
		
	</cfif>
	
	</table>
	
	