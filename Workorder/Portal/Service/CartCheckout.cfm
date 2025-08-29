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
<cfoutput>

<cfform name="cartcheckout" id="cartcheckout">
		      				 
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
			
		<tr><td height="3" colspan="4"></td></tr>
		
		<tr class="hide"><td id="submitcart"></td></tr>
		
		<input type="hidden" name="mission" value="#url.mission#">
		
		<!--- 
		<tr><TD>&nbsp;<cf_tl id="Store">:</TD>
		<td>
		
			<cfquery name="WarehouseSelect" 
			datasource="AppsMaterials" 
			username="#CLIENT.login#" 
			password="#SESSION.dbpw#">
				SELECT * FROM Warehouse
				WHERE Mission = '#URL.Mission#'
			</cfquery>
					
			<select name="Warehouse">
			<cfloop query="WarehouseSelect">
			<option value="#Warehouse#" <cfif URL.Warehouse eq Warehouse>selected</cfif>>#WarehouseName#</option>
			</cfloop>
			</select>
		
		</td>
		</tr>
		
		--->
		
        <TR>
		<TD>&nbsp;<cf_tl id="Contact">:</TD>
		<TD>
		   <cfinput type="Text"
	       name="Contact"
	       value="#CLIENT.First# #CLIENT.Last#"
	       validate="noblanks"
	       required="Yes"
	       visible="Yes"
		   class="regular"
	       enabled="Yes"
		   message="Please enter you full name"
	       size="60"
	       maxlength="60">
		</TD>
		</tr>
		
		<tr>
		<TD>&nbsp;<cf_tl id="EMail">:</TD>
		<TD>
		
		   <cfinput type="Text"
		       name="eMailAddress"
		       value="#client.eMail#"
		       validate="email"
		       required="Yes"
			   message="Please enter you eMail address"
		       visible="Yes"
			   class="regular"
		       enabled="Yes"
		       size="60"
		       maxlength="50">
			   
		</TD>
		</tr>
		
		<tr>
		<TD>&nbsp;<cf_tl id="Contact Name">:</TD>
		<TD>
		   <input type="text" name="Address1" class="regular" value="" size="60" maxlength="60">
		</TD>
		</tr>
		
		<cfquery name="Verify" 
	    datasource="AppsOrganization" 
	    username="#CLIENT.login#" 
	    password="#SESSION.dbpw#">
	      SELECT *
	      FROM   Ref_Mandate
	   	  WHERE  Mission = '#URL.Mission#' 		 
		  ORDER BY MandateDefault DESC 
	    </cfquery>
	
        <cfquery name="orgunit" 
		datasource="AppsEmployee" 
		username="#CLIENT.login#" 
        password="#SESSION.dbpw#">
    	    SELECT 	O.OrgUnit, O.OrgUnitName
        	FROM 	PersonAssignment P, Organization.dbo.Organization O
    		WHERE	P.DateEffective <= getDate() 
			  AND   P.DateExpiration >= getDate()
			  AND   P.Incumbency > '0'
			  AND   P.AssignmentStatus < '8' <!--- planned and approved --->
              AND   P.AssignmentClass = 'Regular'
              AND   P.AssignmentType  = 'Actual'
         	  AND   P.OrgUnit = O.OrgUnit
    		  AND   P.PersonNo = '#CLIENT.PersonNo#'
        </cfquery>		
		
		<tr>
		<TD>&nbsp;<cf_tl id="Unit">:</TD>
		<TD>
		<table cellspacing="0" cellpadding="0">
		<tr>
		<td id="unitbox">
			<input type="text" class="regular" name="orgunitname1" value="#OrgUnit.OrgUnitName#" size="60" maxlength="60" readonly>
			<input type="hidden" name="orgunit1" value="#OrgUnit.OrgUnit#">		
		</td>
		<td>&nbsp;</td>
		<td>
		
		   <cfset link = "../../../../WorkOrder/Portal/Service/CartCheckoutUnit.cfm?mission=#url.mission#">			
									
					   <cf_selectlookup
					    class        = "Organization"
					    box          = "unitbox"
						modal        = "true"
						close        = "Yes"
						icon         = "contract.gif"
						style        = "height:18"
						title        = ""
						button       = "no"
						link         = "#link#"			
						dbtable      = ""
						des1         = "OrgUnit"
						filter1      = "Mission"
						filter1Value = "#URL.Mission#">
		
		</td>
		</tr></table>
			
		</TD>
		</tr>
		<tr>
		<TD>&nbsp;<cf_tl id="Remarks">:</TD>
		<TD>
		   <input type="text" name="Remarks" value="" class="regular" size="50" maxlength="60">
		</TD>
        </tr>
		<tr><td height="6"></td></tr>
       
	    <tr><td colspan="2">
	   
		   <cfinclude template="Cart.cfm">
	   
	    </td></tr>
	  
	 <tr>
	 
	 	<td height="35" colspan="2" align="center">
		
		<table><tr><td>

		 <button type="button" class="button3" style="width:60" onClick="undocheckout()">
		        <img src="#SESSION.Root#/Images/Cart/Back.png" alt="Back">	
		 </button>
		 </td>
		 
		 <td>
		 
		 <cf_tl id="Do you want to submit this cart" var="1">
		 	 
		 <button type="submit" class="button3" style="width:80" onClick="return doit('#lt_text#?')">
			 <img src="#SESSION.Root#/Images/Cart/Submit.png" alt="Continue">		
		 </button>
		 
		 </td></tr></table>
	 
	 	</td>
		
	<tr>

</table>

</cfform>

</cfoutput>

