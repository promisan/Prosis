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

<cfparam name="url.access" default="edit">
<cfparam name="url.action" default="">
<cfparam name="url.selectunit" default="">

<cfquery name="Delete" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  DELETE FROM RequisitionLineUnit
	  WHERE OrgUnit NOT IN (SELECT OrgUnit 
	                        FROM Organization.dbo.Organization)	 
</cfquery>

<cfquery name="Line" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT * 
	  FROM   RequisitionLine
	  WHERE  RequisitionNo = '#URL.RequisitionNo#'
	</cfquery>
	

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT * FROM Ref_ParameterMission
	  WHERE Mission = '#Line.Mission#'	 
</cfquery>	
	
<cfif url.action eq "Insert">

	<cfquery name="Check" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT * 
	  FROM   RequisitionLineUnit
	  WHERE  RequisitionNo = '#url.RequisitionNo#'
	  AND    OrgUnit       = '#url.orgunit#'	
	</cfquery>
	
	<cfif Check.recordcount eq "0">
			
		<!--- copy from Master --->
		
		<cfquery name="Unit" 
          datasource="AppsPurchase" 
          username="#SESSION.login#" 
          password="#SESSION.dbpw#">
             INSERT INTO RequisitionLineUnit
             (RequisitionNo, OrgUnit)
	          VALUES(    
	          '#URL.RequisitionNo#',
	          '#URL.orgunit#') 
        </cfquery>
	
	</cfif>
		
<cfelseif url.action eq "delete">	

	<cfquery name="Employee" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  DELETE FROM RequisitionLineUnit
	  WHERE RequisitionNo = '#URL.RequisitionNo#'
	  AND   OrgUnit       = '#url.orgunit#'	
	</cfquery>
	
</cfif>

<cfquery name="Check" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT * 
	  FROM   RequisitionLineUnit
	  WHERE  RequisitionNo = '#URL.RequisitionNo#'
	</cfquery>
	
<cfif check.recordcount eq "0">

	<cfquery name="Unit" 
	   datasource="AppsPurchase" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	        INSERT INTO RequisitionLineUnit
	             (RequisitionNo, OrgUnit,RequestQuantity)
		    VALUES(    
		       '#URL.RequisitionNo#',
		       '#Line.orgunit#',
			   '#Line.RequestQuantity#') 
	</cfquery>

</cfif>	

<!--- user changed the unit in the top --->

<cfif url.selectunit neq "">

	<cfquery name="Clear" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  DELETE FROM RequisitionLineUnit
		  WHERE  RequisitionNo = '#URL.RequisitionNo#'		 
	</cfquery>
	
	<cfquery name="Unit" 
	   datasource="AppsPurchase" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	        INSERT INTO RequisitionLineUnit
	             (RequisitionNo, OrgUnit,RequestQuantity)
		    VALUES(    
		       '#URL.RequisitionNo#',
		       '#url.selectunit#',
			   '#Line.RequestQuantity#') 
	</cfquery>

</cfif>


<cfquery name="Listing" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   R.*, O.OrgUnitName AS OrgUnitName
    FROM     RequisitionLineUnit R INNER JOIN
             Organization.dbo.Organization O ON R.OrgUnit = O.OrgUnit
	WHERE    RequisitionNo = '#URL.RequisitionNo#'				  	
</cfquery>
	
    <table border="0" cellspacing="0" cellpadding="0" class="formpadding">			
	
	<!---
	<cfif listing.recordcount neq "0">
	    <tr>
		   <td width="20"></td>
	       <td>Unit </td>
		   <TD>Quantity</TD>	
		   <td></td>  
	   </TR>   
   </cfif>
   
   --->
   			   
   <cfoutput query="Listing">
   <tr>
   	  <td width="20" class="cellcontent">#currentrow#.</td>
      <td class="cellcontent">#OrgUnitName#</td>
	  <td class="cellcontent">&nbsp;&nbsp;</td>
	  <cfif access eq "edit">
	  <td>
	  <input type="text" style="text-align:right" class="regularxl" name="requestquantity_#orgunit#" id="requestquantity_#orgunit#"
	   onchange="ColdFusion.navigate('#SESSION.root#/procurement/application/requisition/beneficiary/UnitTotal.cfm?action=update&requisitionno=#requisitionNo#&orgunit=#orgunit#&quantity='+this.value,'totalbox')" value="#requestquantity#" size="8" maxlength="11" class="regular">
	  </td>
	  <cfelse>
	  <td class="cellcontent">#RequestQuantity#</td>
	  </cfif>
	  <td style="padding-left:3px">
	  <cfif access eq "edit">
		  <cf_img icon="delete" 
		     onclick="ColdFusion.navigate('#SESSION.root#/Procurement/application/requisition/beneficiary/UnitList.cfm?action=delete&box=#url.box#&orgunit=#orgunit#&requisitionno=#URL.requisitionno#','#url.box#')"> 	 
	  </cfif>	  
	  </td>
   </tr>         	  
          
   </CFOUTPUT>   
   
   <cfoutput>
   <tr><td id="totalbox" class="hide">
    
	  <cfinclude template="UnitTotal.cfm">
	
	</td></tr>

	<cfif Parameter.enableCurrency eq "1">
	   <cfset price = Line.RequestCurrencyprice>
	<cfelse>
	   <cfset price = Line.RequestCostPrice>
	</cfif>
	
	<cfif total.total neq "">
		<script language="JavaScript">
		  base2('#url.requisitionNo#','#price#','#Total.Total#');
		  tagging()	
		</script> 
	</cfif>	
		
	</cfoutput>	
   
   </table>
  