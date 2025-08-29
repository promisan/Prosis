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
<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM Ref_ParameterMission
		WHERE Mission = '#URL.Mission#' 
</cfquery>

<cfparam name="URL.Period" default="#Parameter.DefaultPeriod#">

<table width="100%" height="100%" align="center" border="0" cellspacing="5" cellpadding="0" class="tree">

<tr><td valign="top">

	<cfform method="POST" name="receipt">

	    <table width="93%" cellspacing="0" cellpadding="0" class="formpadding" align="center">	
			  
		  <cfquery name="Period" 
		      datasource="AppsWorkOrder" 
	    	  username="#SESSION.login#" 
		      password="#SESSION.dbpw#">
		      SELECT  *
		      FROM    Workorder
		      WHERE   Mission = '#url.mission#'		  
	      </cfquery>	
		  
		  <cfif Period.recordcount eq "0">
		  
		 	 <tr><td align="center" class="labelit" height="90"><font color="FF0000">No workorders recorded<br>Function is not operational</font></td></tr>
		  
		  <cfelse>
	   	 
		  <!---
		  	 
		  <cfoutput>
		  		
			<tr>
		     <td height="20" style="padding-top:7px;padding-left:4px" class="labelmedium">
			 <a href="Shipment/WorkOrderListing.cfm?mode=shipment&systemfunctionid=#url.idmenu#&Status=Pending&Mission=#URL.Mission#" target="right">
			 <cf_tl id="Enter Shipment">
			 </a>
			 </td>
		    </tr>		
			 	  
		  <tr><td height="2"></td></tr>
		  
		  <tr><td class="line"></td></tr>
			
		  </cfoutput>
		  
		  --->
		  			
		  <tr><td valign="top" style="padding-top:10px">
		   
		   <cf_shipmentTreeData	
			    iconpath="#SESSION.root#/Tools/Treeview/Images" 
				mission = "#URL.Mission#"
				systemfunctionid="#url.idmenu#"
				destination = "ShipmentView/ShipmentListing.cfm">
				
		 </td></tr>	
		 
		  <tr><td class="line"></td></tr>	
		 
		 </cfif>
		 
		 </table>	
		 
	 </cfform>
	
	
  </td>
  </tr>		
	
</table> 	  


	