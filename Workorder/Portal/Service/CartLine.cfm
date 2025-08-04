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
	
<cfquery name="Detail" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Cart C INNER JOIN
            ServiceItemUnit S ON C.ServiceItem = S.ServiceItem AND C.ServiceItemUnit = S.Unit            
	WHERE   C.OfficerUserId = '#client.acc#' 
	AND     C.ActionStatus = '0' 
	AND     C.ServiceItem = '#url.ServiceItem#' 
</cfquery>

<cfquery name="ServiceUnits" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT U.Unit, U.UnitDescription
    FROM   ServiceItemUnit U INNER JOIN
           ServiceItemUnitMission M ON U.ServiceItem = M.ServiceItem AND U.Unit = M.ServiceItemUnit
	WHERE  U.ServiceItem = '#url.ServiceItem#'
	AND    M.Mission = '#URL.Mission#'
	AND    U.Operational = 1  
</cfquery>

<cfif Detail.recordcount eq "0">
   <cfparam name="URL.ID2" default="new">
<cfelse>
   <cfparam name="URL.ID2" default="">   
</cfif>
			
<table width="98%" class="formpadding formspacing">
			
	    <TR>
		   <td width="1" height="20"></td>
		   <td width="20%" class="labelmedium" height="20">Item</td>
		   <td width="20%" class="labelmedium" height="20">Reference</td>
		   <td class="labelmedium">Price</td>		  
		   <td width="8%"></td>
		   <td width="8%" align="right">
	    
		     <cfoutput>			 
			 <cfif URL.ID2 neq "new">
			     <A href="javascript:ColdFusion.navigate('../../../../WorkOrder/Portal/Service/CartLine.cfm?Mission=#url.mission#&ServiceItem=#url.ServiceItem#&ID2=new','detaillines')"><font color="0080FF">[add]</font></a>
			 </cfif>
			 </cfoutput>
			 
		   </td>
		  
	    </TR>	
		<tr><td colspan="6" height="1" class="line"></td></tr>		
									
		<cfoutput query="Detail">
				
			<cfset ow = Unit>
			<cfset de = UnitDescription>
			<cfset re = Reference>
			<cfset pr = Amount>
															
			<cfif URL.ID2 eq cartid>
					    												
				<TR>
				   <td></td>			
				   <td height="25">			     
				      <select name="ServiceItemUnit" class="regularxl">				  
					   <cfloop query="ServiceUnits">
					       <option value="#Unit#" <cfif ow eq Unit>selected</cfif>>#UnitDescription#</option>
					   </cfloop>				   
				      </select>					   
				   </td>
				   <td><input type="text" name="Reference" size="20" maxlength="20" value="#re#" class="regularxl"><td>
				   <td align="right" class="labelit">999.99</td>			   
				   <td colspan="2" align="right">
				   
				   <input type="submit" 
				          value="Update" 
						  class="button10s"						  
						  onclick="ColdFusion.navigate('../../../../WorkOrder/Portal/Service/CartLineSubmit.cfm?Mission=#url.mission#&ServiceItem=#ServiceItem#&ID2=#cartid#','detaillines','','','POST','formlines')">
						  
					 </td>
				   
			    </TR>	
						
			<cfelse>
			
				<cfset edit = "javascript:ColdFusion.navigate('../../../../WorkOrder/Portal/Service/CartLine.cfm?Mission=#url.mission#&ServiceItem=#ServiceItem#&ID2=#cartid#','detaillines')">
						
				<TR>
				    <td></td>
				    <td onclick="#edit#" class="labelmedium" height="20">#de#</td>			   
				    <td onclick="#edit#" class="labelmedium">#re#</td>
					<td align="right" class="labelmedium">#numberformat(pr,"___,__.__")#</td>
				    <td align="right" class="labelmedium" onclick="#edit#">
					      <cf_img icon="edit">						  
				    </td>
				    <td align="right">				   						   
				   	 	<cf_img icon="delete" script="ColdFusion.navigate('../../../../WorkOrder/Portal/Service/CartLinePurge.cfm?Mission=#url.mission#&ServiceItem=#ServiceItem#&ID2=#cartid#','detaillines')">											
				    </td>
				   
			    </TR>	
				
				<tr><td class="line" colspan="6"></td></tr>
			
			</cfif>
							
		</cfoutput>				
															
		<cfif URL.ID2 eq "new">
				
			<TR>
				
			<td></td>			
			<td height="25">		   
			 
			   <select name="ServiceItemUnit" class="regularxl">				  
				   <cfoutput query="ServiceUnits">
				       <option value="#Unit#">#UnitDescription#</option>
				   </cfoutput>				   
			    </select>			
								
			</td>
			
			<td><input type="text" name="Reference" size="20" maxlength="20" class="regularxl"></td>			
			<td class="labelit" align="right">999.99</td>							   
			<td colspan="2" align="right" style="padding-right:4px">
				
				<cfoutput>	    
			    <input type="button" 
				  value="Add" 		
				  style="width:80px;height:25px"		 
				  onclick="ColdFusion.navigate('../../../../WorkOrder/Portal/Service/CartLineSubmit.cfm?Mission=#url.mission#&ServiceItem=#ServiceItem#&ID2=new','detaillines','','','POST','formlines')"
				  class="button10s">
				 </cfoutput>	 
																
			</td>
			    
			</TR>	
		
		</cfif>		
									
  </table>