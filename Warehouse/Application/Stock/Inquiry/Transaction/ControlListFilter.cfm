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
<cfparam name="URL.ID2" default="SAT">

<!--- Search form --->
<table width="100%" cellspacing="0" cellpadding="0" style="padding-bottom:1px;padding:0px">

<tr><td>

<cfform method="POST" name="filterform" onsubmit="return false">

<table width="100%" border="0" cellspacing="0" cellpadding="0">

	<tr>
	
	<!--- select categories that have a record for this warehouse in any transaction --->
	
	<cfquery name="CategoryList" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
		FROM  Ref_Category R
		WHERE R.Category  IN (SELECT ItemCategory 
		                    FROM   ItemTransaction
							WHERE  Warehouse = '#url.warehouse#'
							AND    ItemCategory = R.Category)	
	</cfquery>
	
	<cfquery name="LocationList" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
		FROM  WarehouseLocation L
		WHERE Warehouse = '#URL.Warehouse#'
		AND   L.Location IN (SELECT Location
		                     FROM ItemTransaction
						     WHERE Warehouse = L.Warehouse
							 AND   Location = L.Location)	
	</cfquery>
	
	<cfquery name="OrgUnit" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT DISTINCT OrgUnitCode, OrgUnitName 
		FROM  ItemTransaction T
		WHERE Warehouse = '#URL.Warehouse#'
		AND   OrgUnit IN (SELECT OrgUnit FROM Organization.dbo.Organization WHERE OrgUnit = T.OrgUnit)
		ORDER BY OrgUnitCode, OrgUnitName
	</cfquery>
	
	<td>		
	
	<table width="99%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
		<tr><td height="4"></td></tr>
	
	    <TR>
		<TD><font face="Calibri" size="2"><i><cf_tl id="Transaction date">:</TD>
		<td colspan="1">	
		
			<table cellspacing="0" cellpadding="0">
				<tr><td>			
				 <cf_intelliCalendarDate9
					FieldName="datestart" 
					Default="#dateformat(now()-180,CLIENT.DateFormatShow)#"
					AllowBlank="True" class="regularxl enterastab">	
				</td>
				<td>-</td>
				<td>			
				<cf_intelliCalendarDate9
					FieldName="dateend" 
					Default="#dateformat(now(),CLIENT.DateFormatShow)#"
					AllowBlank="True" class="regularxl  enterastab">					
				</td>
				</tr>
			</table>	
			
		</TD>
						
		<cfinvoke component = "Service.Access"  
		   method           = "RoleAccess" 
		   Role             = "'WhsPick'"
		   Parameter        = "#url.systemfunctionid#"
		   Mission          = "#url.mission#"  	  
		   AccessLevel      = "2"
		   returnvariable   = "accesslevel">	
		
		<cfif accesslevel eq "GRANTED">
			  <cfset cl = "regular">		  
		<cfelse>		
			  <cfset cl = "hide">
		</cfif>
		
		<TR class="<cfoutput>#cl#</cfoutput>">
		
		<TD height="22" class="labelit"><cf_tl id="Transaction quantity">:</TD>
		<TD>
				<table cellspacing="0" cellpadding="0"><tr><td>	
			    <SELECT name="quantityoperator" id="quantityoperator" class="regularxl">
					<OPTION value="="><cf_tl id="is">
					<option value=">=" selected>>=				
				</SELECT>
				</td>
				<td style="padding-left:2px">
				<input type="text" name="quantity" id="quantity" value="" class="regularxl" style="padding-right:2px;padding-top:1px;font:10px;text-align: right;">
				</td></tr></table>	
				<td>
				<cf_tl id="and"> 	
				</td>
				
				<td>
				<table><tr><td>	
			    <SELECT name="quantityoperatorto" id="quantityoperatorto" class="regularxl">
					<OPTION value="="><cf_tl id="is">
					<OPTION value="<=" selected><=
				</SELECT>
				</td>
				<td style="padding-left:2px">
				<input type="text" name="quantityto" id="quantityto" value="" class="regularxl" style="padding-right:2px;padding-top:1px;font:10px;text-align: right;">
				</td>
				</tr></table>
			
			  </td>
		</tr>
		
		<!--- only if the mode 
		
		<TR class="<cfoutput>#cl#</cfoutput>">
		
		<TD height="22" class="labelit"><cf_tl id="Transaction amount">:</TD>
		<TD>
						
			    <SELECT name="amountoperator" id="amountoperator" style="height:21;font:10px;">
					<OPTION value="="><cf_tl id="is">
					<option value=">=" selected>>=				
				</SELECT>
				<input type="text" name="amount" id="amount" value="" style="height:19;padding-right:2px;padding-top:1px;font:10px;text-align: right;">
				<td>
				<cf_tl id="and"> 	
				</td>
				
				<td>
			    <SELECT name="amountoperatorto" id="amountoperatorto" style="height:21;font:10px;">
					<OPTION value="="><cf_tl id="is">
					<OPTION value="<=" selected><=
				</SELECT>
				<input type="text" name="amountto" id="amountto" value="" style="height:19;padding-right:2px;padding-top:1px;font:10px;text-align: right;">
			
			  </td>
		</tr>
		
		--->
		
				
		<TR>
		<TD height="22" class="labelit"><cf_tl id="Storage Location">:</TD>
				
			<td align="left" valign="top">
			
				<table cellspacing="0" cellpadding="0">
					<tr><td>			
					<select name="Location" id="Location" size="1" class="regularxl">
					    <option value="" selected>Any</option>
					    <cfoutput query="LocationList">
						<option value="#Location#">#Location# #Description# #StorageCode#</option>
						</cfoutput>
				    </select>
					</td></tr>
				</table>
				
			</td>	
					
			<TD height="20" class="labelit"><cf_tl id="Category">:</TD>
				
			<td align="left" valign="top">
			
				<table cellspacing="0" cellpadding="0">
					<tr><td>	
			    <select name="category" id="category" size="1" class="regularxl">
				<option value="" selected><cf_tl id="All"></option>
			    <cfoutput query="CategoryList">
					<option value="#Category#">#Description#</option>
				</cfoutput>
			    </select>			
					</td></tr>
				</table>
				
			</td>	
				
		</tr>
		
		<TR>
		
		<!--- 
		<TD height="22" class="labelit"><cf_tl id="OrgUnit">:</TD>
				
			<td align="left" valign="top">
			
				<table cellspacing="0" cellpadding="0">
					<tr><td>	
					<select name="OrgUnitCode" id="OrgUnitCode" size="1" style="font:10px;">
				    <option value="" selected><cf_tl id="Any"></option>
				    <cfoutput query="OrgUnit">
					<option value="#OrgUnitCode#">#OrgUnitName#</option>
					</cfoutput>
				    </select>
					</td></tr>
				</table>
				
			</td>	
			
			--->
						
			<TD style="height:30px" class="labelit"><cf_tl id="Show">:</TD>
			
			<td>
			<table><tr><td>
			<input type="radio" name="selection" value="Unit" checked>
			</td>
			<td style="padding-left:4px" class="labelit">Destination</td>
			<td style="padding-left:10px">
			<input type="radio" name="selection" value="Price">
			</td>
			<td style="padding-left:4px" class="labelit">Price</td>
			</tr>
			</table>
			</td>
			
			</td>
							
		</tr>	
		
		<tr><td height="3"></td></tr>
		
		<tr><td height="1" colspan="4" class="line"></td></tr>
			
	</TABLE>
	
	</td></tr>
	
	<cfoutput>
	
		<tr>
		<td align="center" style="padding-left:0px;padding-top:2px">
					
		<input type   = "button" 
		       name   = "Submit" 
			   id     = "Submit"
			   value  = "Prepare data" 
			   class  = "button10s" 
			   style  = "width:180px" 
			   onclick= "listfiltermain('#URL.Mission#','#URL.Warehouse#','#url.systemfunctionid#')">
	
		</td>
		</tr>
		
	</cfoutput>
	
	<tr><td height="2"></td></tr>

</table>

</cfform>

</td></tr>

</table>
