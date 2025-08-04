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

<cfparam name="URL.transactionid" 	default="">
<cfparam name="URL.table" 			default="">
<cfparam name="URL.adate" 			default="">

<CF_DateConvert Value="#URL.adate#">
<cfset dte = dateValue>

<cfquery name="Get" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   A.*, I.ItemDescription, C.Category
		FROM     AssetItem A INNER JOIN Item I ON A.ItemNo = I.ItemNo 
			INNER JOIN Ref_Category C ON C.Category = I.Category  
		<cfif url.assetid eq "">
		WHERE 1=0
		<cfelse>
		WHERE    AssetId = '#url.AssetId#'		
		</cfif>
</cfquery>

<cfoutput>

<cfif get.recordcount gte "1">

	<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">
			
	<tr>
	    <td style="border:0px dotted silver;padding-left:2px" class="labelit" width="10%"><cf_space spaces="30"><cf_tl id="Make">:</td>
	    <td style="border:1px dotted silver;padding-left:2px" width="40%" class="labelit">#get.Make# </td>
		<td style="border:0px dotted silver;padding-left:2px" width="10%" class="labelit"><cf_space spaces="20"><cf_tl id="Model">:</td>
		<td style="border:1px dotted silver;padding-left:2px" width="40%" class="labelit"><cf_space spaces="60">#get.Model#</td>		
	</tr>
	
	<tr>
	
	    <cfif get.AssetDecalNo neq "">
		
			<td style="border:0px dotted silver;padding-left:2px" class="labelit"><cf_tl id="DecalNumber">:</font></td>
			<td style="border:1px dotted silver;padding-left:2px" class="labelit">#get.AssetDecalNo#</td>
		
			<script>
			 try { 
			 document.getElementById('assetselect').value = '#get.AssetDecalNo#'
			 } catch(e) {}	 
			</script>
			
			<cfif get.AssetBarcode neq "">
		
				<td style="border:0px dotted silver;padding-left:2px" class="labelit"><cf_tl id="BarCode">:</td>
				<td style="border:1px dotted silver;padding-left:2px" class="labelit">#get.AssetBarCode#</td>
		
		    <cfelse>
		
				<td style="border:0px dotted silver;padding-left:2px" style="padding-left:0px;padding-right:4px" class="labelit"><cf_tl id="SerialNo">:</font></td>
				<td style="border:1px dotted silver;padding-left:2px" class="labelit">#get.SerialNo#</td>
			
			</cfif>
				
		<cfelse>
		
			<cfif get.AssetBarcode neq "">
		
				<td style="border:0px dotted silver;padding-left:2px" class="labelit"><cf_tl id="BarCode">:</td>
				<td style="border:1px dotted silver;padding-left:2px" class="labelit">#get.AssetBarCode#</td>
		
		    <cfelse>
		
				<td style="border:0px dotted silver;padding-left:2px" class="labelit"><cf_tl id="SerialNo">:</font></td>
				<td style="border:1px dotted silver;padding-left:2px" class="labelit">#get.SerialNo#</td>
			
			</cfif>
			
			<cfif get.AssetBarcode neq "">
			
				<script>
				 try { 
				 document.getElementById('assetselect').value = '#get.AssetBarCode#'
				 } catch(e) {}	 
				</script>
			
			<cfelse>
			
				<script>
				 try { 
				 document.getElementById('assetselect').value = '#get.SerialNo#'
				 } catch(e) {}	 
				</script>			
			
			</cfif>
		
		</cfif>
		
	</tr>
	
	<tr><td style="border:0px dotted silver;padding-left:2px" class="labelit"><cf_tl id="Name">:</font></td>
	    <td style="border:1px dotted silver;padding-left:2px" class="labelit" colspan="3">#get.ItemDescription#</td>	
	</tr>
	
	<cfquery name="GetUnit" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  *
		FROM    Organization.dbo.Organization
		WHERE   OrgUnit IN (SELECT TOP 1 OrgUnit 
		                    FROM  AssetItemOrganization
							<cfif url.assetid eq "">
							WHERE   1=0
							<cfelse>
							WHERE   AssetId = '#url.AssetId#'	 	
							</cfif>
							ORDER BY DateEffective DESC)
							
	</cfquery>
	
	<tr><td style="border:0px dotted silver;padding-left:2px" class="labelit"><cf_tl id="Assigned Unit">:</font></td>
	    <td style="border:1px dotted silver;padding-left:2px" class="labelit" colspan="3"><cfif getUnit.recordcount eq "1">#getUnit.OrgUnitName#<cfelse>n/a/</cfif></td>	
	</tr>	
	
	<cfif url.transactionid neq "">
	
	<cfquery name="GetTransaction" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  *
		FROM    ItemTransaction
		WHERE   TransactionId = '#url.transactionid#' 
	</cfquery>
	
	<cfif getTransaction.recordcount eq "1">
	
		<cfset url.adate = dateformat(getTransaction.TransactionDate,client.dateformatshow)>
		
	</cfif>
	
	</cfif>

	<cfinclude template = "getAssetEvents.cfm">
	
	<cfinclude template = "getAssetActions.cfm">	
				
	</table>
	
</cfif>	
		
</cfoutput>


