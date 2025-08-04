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

<cfset client.warehouseselected = url.warehouse>

<input type="hidden" name="optionselect" id="optionselect">	

<cfquery name="Unit" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT *
      FROM  Warehouse
	  WHERE Warehouse = '#URL.Warehouse#'	 
</cfquery>

<!--- check if access to the shipping --->

<cfinvoke component = "Service.Access"  
   method           = "warehouseshipper" 
   mission          = "#unit.mission#" 
   warehouse        = "#url.warehouse#"
   returnvariable   = "access">	
  
 
<cfif access eq "EDIT" or access eq "ALL">
   
   <script>   
   	document.getElementById("optionmenu").className = "regular"      
   </script>
      
<cfelse>

   <script>   
   	document.getElementById("optionmenu").className = "hide"      
   </script>
     
</cfif>

<cfif Unit.MissionOrgUnitId eq "">

	<table width="100%" 
	       border="0" 
		   cellspacing="0" 			  
		   cellpadding="0" 
		   align="center">
	   <tr class="labelmedium">
	   <td align="center" style="padding-top:10px" height="40"><cf_tl id="Detected a Problem with the configuration"  class="Message"></font></td>
	   </tr>
	</table>	
	
	<cfset unit = "0">
	
<cfelse>
	
	<cfquery name="Org" 
	  datasource="AppsOrganization" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      SELECT *
	      FROM   Organization
		  WHERE  MissionOrgUnitId = '#Unit.MissionOrgUnitId#'	 
	</cfquery>
		
	<cfif Org.recordcount eq "0">
			
		<table width="100%" height="100%" 
		       border="0" 
			   cellspacing="0" 			  
			   cellpadding="0" 
			   align="center">
		   <tr  class="labelmedium"><td align="center" style="padding-top:10px" height="40">
		    
			<cf_tl id="Detected a Problem with the configuration"  class="Message">
			
			</td></tr>
		</table>	
		
		<cfset unit = "">
			
	<cfelse>
		
		<cfset unit = "">
					
		<cfloop query="Org">
		
		    <cfif unit eq "">
				<cfset unit = "'#orgunit#'">
			<cfelse>
				<cfset unit = "#unit#,'#orgunit#'">
			</cfif>	
		</cfloop>
	
	</cfif>

</cfif>

<cfif unit neq "" or getAdministrator("#url.mission#") eq "1">

<table width="100%" height="100%" class="tree" cellpadding="0" align="left">
	   
	<tr>
		<td align="left" valign="top">
	    <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
										   
			<tr>
				<td valign="top" style="padding-top:8px;">
				<table width="300" height="100%" border="0" cellspacing="0" cellpadding="0" align="right">
				
						<cfset module       = "'Warehouse'">
						<cfset selection    = "'Transaction'">
						<cfset menuclass    = "'General'">					
						<cfset role         = "'WhsPick'">						
						<cfset orgunit      = "#unit#">
								
						<tr><td height="1px">
						
						<!--- conditions for menu --->
						
							<cf_tl id="Stock" var="1">
						
							<cfset heading      = "#lt_text#">
							<cfset img          = "stock.png">		
							<cfset selection    = "'Stock'">									
							<!--- <cfset url.mission  = "#unit.mission#"> --->											
							<cfinclude template = "../../../../Tools/SubmenuLeft.cfm">	
																	
						</td></tr>											
						
						<tr><td height="1px">
						
							<cf_tl id="Issues and Transfers" var="1">
												
							<cfset heading      = "#lt_text#">
							<cfset img          = "issues.png">		
							<cfset selection    = "'StockTask'">																											
							<cfinclude template = "../../../../Tools/SubmenuLeft.cfm">	
																	
						</td></tr>
						
						<tr><td height="1px">
						
							<cf_tl id="Sales" var="1">
																			
							<cfset heading      = "#lt_text#">
							<cfset img          = "sale.png">		
							<cfset selection    = "'StockSale'">																											
							<cfinclude template = "../../../../Tools/SubmenuLeft.cfm">	
																	
						</td></tr>
						
						<tr><td height="1px">
						
							<cf_tl id="Management" var="1">
						
							<cfset heading      = "#lt_text#">
							<cfset img          = "management.png">		
							<cfset selection    = "'Location'">																												
							<cfinclude template = "../../../../Tools/SubmenuLeft.cfm">	
																	
						</td></tr>
						
						<!---												
						<tr><td height="1px" align="right">
						
							<cf_tl id="Inspection" var="1">
						
							<cfset heading      = "#lt_text#">
							<cfset img          = "locate3.gif">			
							<cfset selection    = "'Inspection'">			
							<cfinclude template = "../../../../Tools/SubmenuLeft.cfm">		
						
						</td></tr>
						
						
						<tr><td height="1px">
						
							<cf_tl id="Item Management" var="1">
						
							<cfset heading      = "#lt_text#">
							<cfset img          = "condition.gif">		
							<cfset selection    = "'Item'">																												
							<cfinclude template = "../../../../Tools/SubmenuLeft.cfm">	
																	
						</td></tr>
						
						--->
												
						<tr><td height="1px" align="right">
						
							<cf_tl id="Inquiry" var="1">
						
							<cfset heading      = "#lt_text#">
							<cfset img          = "inquiry.png">			
							<cfset selection    = "'Inquiry'">			
							<cfinclude template = "../../../../Tools/SubmenuLeft.cfm">		
						
						</td></tr>
						<tr><td>&nbsp;</td></tr>
					
				</table>
				</td>
			</tr>
			
		</table>
		</td>
	</tr>
	
</table>

</cfif>

