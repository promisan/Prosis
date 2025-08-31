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
<table width="100%" height="100%">

<!--- by default open the warehouse where this person is working / assigned --->

<cfquery name="Default" 
		 datasource="appsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
         SELECT   TOP (1) W.Warehouse
	     FROM     Employee.dbo.Person AS P INNER JOIN
                  Employee.dbo.PersonAssignment AS PA ON P.PersonNo = PA.PersonNo INNER JOIN
                  Organization.dbo.Organization AS O ON PA.OrgUnit = O.OrgUnit INNER JOIN
                  Materials.dbo.Warehouse AS W ON O.MissionOrgUnitId = W.MissionOrgUnitId INNER JOIN
                  System.dbo.UserNames AS U ON P.PersonNo = U.PersonNo
         WHERE    U.Account = '#session.acc#'
</cfquery>

<tr><td style="padding:5px">

	<table width="100%" height="100%">
	
		<tr class="labelmedium2">
		  <td style="padding-left:10px;font-size:15px"><cf_tl id="Store"></td>
		  <td id="storebox">
		  		  
			<select id="warehousequote" name="warehousequote" style="width:100%;background-color:f5f5f5" class="regularxxl" 
			   onchange="setquote(document.getElementById('requestno').value,'warehouse')">		
				<cfoutput query="Warehouse">
			     	<option value="#Warehouse#" <cfif warehouse eq default.warehouse>selected</cfif>>#WarehouseName#</option>
				</cfoutput>	
			</select>
		  
		  </td>
		</tr>
		
		<CFParam name="Attributes.height" default="660">
		<CFParam name="Attributes.width"  default="980">	
		<CFParam name="Attributes.Modal"  default="true">		
	
		<tr class="labelmedium2">
		  
		  <td style="height:40px" colspan="2" align="center">
		    <cfoutput>
		    <table style="width:100%" class="formspacing">
			<tr>
			<td style="width:50%">
		    
			<cf_tl id="Quotation" var="mQuotation">
		    <input type="button" name="Add" value="New #mQuotation#" style="width:100%;border:1px solid silver" class="button10g" onclick="addquote()">
			<input type="hidden" name="requestno" id="requestno" value="">
			
			</td>
			<cfset link   = "#SESSION.root#/warehouse/application/stockorder/Quote/QuoteAdd.cfm?mission=#url.mission#&">	 
			<cfset jvlink = "ProsisUI.createWindow('dialogquotebox','Quote','',{x:100,y:100,height:document.body.clientHeight-80,width:#Attributes.width#,modal:#attributes.modal#,center:true});ptoken.navigate('#SESSION.root#/Tools/SelectLookup/StockOrder/Quote.cfm?mission=#url.mission#&datasource=appsMaterials&close=Yes&class=Customer&box=boxquote&link=#link#&dbtable=&des1=requestno&filter1=mission&filter1value=#url.mission#&filter2=&filter2value=','dialogquotebox')">		
			
			<td style="width:50%" align="right"><input value="Find #mQuotation#" type="button" onclick="#jvlink#" class="button10g" style="width:100%;border:1px solid silver" class="button10g">
			</tr>
			</cfoutput>
			</table>
		  </td>
		</tr>
		
		<tr class="line"><td colspan="2" id="boxquote"></td></tr>		
				
		<tr><td colspan="2" valign="top" id="boxlines" 
		     style="padding-left:5px;padding-right:5px;height:100%;background-color:fafafa"></td></tr>		
			 
		<tr><td id="boxprocess"></td></tr>
		
		<tr id="boxaction" class="hide">
		<td colspan="2" align="center" style="height:40px;border-top:1px solid silver">
		
			<table class="formspacing" style="width:100%">
				<tr>
					<td><input type="button" class="button10g"  onclick="applyQuote('quote',document.getElementById('requestno').value)" style="width:100%" name="Quote"  value="Apply Quote"></td>
				</tr>
			</table>
				
		</td>
		</tr>
	
	</table>
	
</td></tr>
</table>	
