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
<!--- Query returning detail information for selected item --->

<cfquery name="Request" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Request
	WHERE  RequestId = '#URL.Id#'
</cfquery>

<cfquery name="Detail" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Item I, ItemUoM U
	WHERE I.ItemNo = U.ItemNo
	AND  I.ItemNo = '#Request.ItemNo#'
	AND  U.Uom    = '#Request.UoM#'
</cfquery>

<cfquery name="Parameter" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_ParameterMission
	WHERE  Mission   = '#Request.Mission#'
</cfquery>
	
 	<CFOUTPUT query="Detail">

	<table width="97%" border="0" cellspacing="0" cellpadding="0" style="border:1px dotted silver" align="center" bgcolor="white" class="formpadding">
	  <tr>
	    <td width="240" style="border:1px dotted silver" align="center">
		 <cfif FileExists("#SESSION.rootDocumentPath#Warehouse/Pictures/#ItemNo#.jpg")>
		 
		    <cftry>
		 	   
			   <cfimage 
					  action="RESIZE" 
					  source="#SESSION.rootDocument#Warehouse/Pictures/#ItemNo#.jpg" 
					  name="showimage" 
					  height="140" 
					  width="140">
					  
					  <cfimage 
					  action="WRITETOBROWSER" source="#showimage#">
					  
			   <cfcatch>
				   <b><img src="#SESSION.rootDocument#Warehouse/Pictures/#ItemNo#.jpg" alt="#ItemDescription#" border="0" align="absmiddle"></b>
			   </cfcatch>	
			   
		    </cftry>
					  
		 <cfelse>
		 
			  <b><img src="#SESSION.root#/images/image-not-found.gif" alt="#ItemDescription#" border="0" align="absmiddle"></b>
			  
		 </cfif>
		 
		</td>
		<td valign="top" style="padding-left:6px">
	    <table width="100%" valign="header" border="0" cellpadding="0" cellspacing="0" class="formpadding">
		
		    <tr>
	        <TD width="80" height="20" class="labelit"><font color="808080"><cf_tl id="Store">:</TD>
		    <TD width="80%" height="20" class="labelmedium">#Request.Warehouse#</TD>
	      </tr>			 
		  <tr>
	        <TD width="80" height="20" class="labelit"><font color="808080"><cf_tl id="Category">:</TD>
		    <TD height="20" class="labelmedium">#Category#</TD>
	      </tr>
		  
		  <cfif Parameter.PortalInterfaceMode neq "Internal">
			  <tr>
		        <TD height="20" class="labelit"><font color="808080"><cf_tl id="Classification">:</TD>
			    <TD height="16" class="labelmedium">#Classification#</TD>
		      </tr>
			  <tr>
		        <TD height="20" class="labelit"><font color="808080"><cf_tl id="Color">:</TD>
				<TD height="20" class="labelmedium"><cfif itemcolor neq "">#ItemColor#<cfelse>N/A</cfif></TD>
		      </tr>
		  </cfif>
				  		  
		  <cfquery name="OnHand" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT     *
			FROM  skStockOnHand
			WHERE ItemNo          = '#Request.ItemNo#'
			AND   TransactionUom  = '#Request.UoM#'
			AND   Mission         = '#Request.Mission#'
		  </cfquery>
		 		  
		  <tr>
	        <TD height="20" class="labelit"><font color="808080"><cf_tl id="Availability">:</TD>
			<cf_Precision number="#ItemPrecision#">
	        <TD height="20" class="labelmedium">
			
			<cfif OnHand.recordcount eq "0">
				<font color="FF0000">Not available</font>
			<cfelse>
			
					<table width="200">
					<cfoutput>
					<cfloop query = "OnHand">
					<tr><td class="labelit">#Warehouse#</td>
					    <td class="labelmedium">
						
						<cfif Parameter.PortalInterfaceMode neq "Internal">
						
							<cfif OnHand.OnHand gt "0">
						    On hand: #NumberFormat(OnHand.OnHand,"#pformat#")#					       
							<cfelse>
							<font color="800000">Not available</font>
						    </cfif>
							
						<cfelse>
						
							<cfif OnHand.OnHand gt "0">
						    <font color="green">Available</font>			       
							<cfelse>
							<font color="800000">Not available</font>
						    </cfif>							
							
						</cfif>
						</td>
					</tr>
					</cfloop>
					</cfoutput>
					
					</table>
					
			</cfif>
			</TD>
	      </tr>
		 		  
		  <tr>
		    <TD height="20" class="labelit"><font color="808080"><cf_tl id="RequestCategory">:</TD>
		    <TD height="20" class="labelmedium">#ItemClass#</TD>
	      </tr>
		 
		 <cfif ItemUoMDetails neq ""> 
		 <tr>
	        <TD height="20" class="labelit"><font color="808080"><cf_tl id="Details">:</TD>
		    <TD height="20" class="labelmedium">#ItemUoMDetails#</TD>
	      </tr>
		  </cfif>
		  		 
			<cfquery name="Special" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
				FROM ItemWarehouse
				WHERE ItemNo    = '#Request.ItemNo#'
				AND   Warehouse = '#Request.Warehouse#'
			</cfquery>
			
			<cfif special.shippingMemo neq "">
			<tr><td height="20" class="labelit">Shipping:</td>
			    <td class="labelmedium">#special.shippingMemo#.</td>
			</tr>	
			</cfif>
			
	      </table>
		  </td>    
	   </tr>
	</table>
	</cfoutput>
