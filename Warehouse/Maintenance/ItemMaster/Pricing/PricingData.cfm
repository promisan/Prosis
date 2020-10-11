
<cfparam name="url.drillid" default="">

<cfif url.drillid neq "">

	<cf_screentop html="Yes" height="100%" label="Sales Pricing" layout="webapp" scroll="Yes" banner="gray">
	
<cfelse>

	<cf_screentop html="No" layout="webapp" height="100%" label="Sales Pricing" scroll="Yes">

</cfif>

<cf_calendarscript>

<script>
	function copyValues(w,m,s,c,type) {
		var message = '';
		var searchPrice = '';
		var searchTax = '';
		var searchDate = '';
		
		if (type == 1) {
			message = 'This action will replace all sale prices and taxes of the same price schedule and currency with the values of this line.';
			searchPrice = '_'+s+'_'+c+'_SalesPrice';
			searchTax = '_'+s+'_'+c+'_taxcode';
			searchDate = '_'+s+'_'+c+'_DateEffective';
		}
		
		if (type == 2) {
			message = 'This action will replace all sale prices and taxes of the same unit of measure, price schedule and currency with the values of this line.';
			searchPrice = '_'+m+'_'+s+'_'+c+'_SalesPrice';
			searchTax = '_'+m+'_'+s+'_'+c+'_taxcode';
			searchDate = '_'+m+'_'+s+'_'+c+'_DateEffective';
		}

		if (confirm(message+'\n\nDo you want to continue ?')) {
			var str = '';
	        var elem = document.getElementById('inputform').elements;
	        for(var i = 0; i < elem.length; i++)
	        {
				if (elem[i].type == 'text' && elem[i].name.indexOf(searchDate) != -1) {
					elem[i].value = document.getElementById(w+'_'+m+'_'+s+'_'+c+'_DateEffective').value;
				}
				if (elem[i].type == 'text' && elem[i].name.indexOf(searchPrice) != -1) {
					elem[i].value = document.getElementById(w+'_'+m+'_'+s+'_'+c+'_SalesPrice').value;
				}
				if (elem[i].type == 'select-one' && elem[i].name.indexOf(searchTax) != -1) {
					elem[i].value = document.getElementById(w+'_'+m+'_'+s+'_'+c+'_taxcode').value;
				}
	        }
		}
	}
</script>

<cfparam name="URL.Mission" default="">

<cfparam name="URL.drillid" default="">

<cfif url.drillid neq "">
	
	<cfquery name="get"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   ItemUoM
		WHERE  ItemUoMId = '#URL.drillid#'				
	</cfquery>	
	
	<cfset url.id = get.ItemNo>
	
<cfelse>
	
	<cfparam name="URL.ID" default="0001">	

</cfif>

<!--- diabled as the table ItemWarehouse is daily populated based on the item
warehouse transactiontable + pro-active settings 

<cfquery name="Warehouse"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT DISTINCT Warehouse
	FROM   ItemTransaction
	WHERE  Mission = '#URL.Mission#'
	AND    ItemNo  = '#URL.ID#'				
</cfquery>	

--->

<cfquery name="Item" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	Item
	WHERE 	ItemNo = '#URL.ID#'
</cfquery>

<cfquery name="Category" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	Ref_Category
	WHERE 	Category = '#Item.Category#'
</cfquery>

<cfquery name="ItemUoM"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   ItemUoM
	WHERE  ItemNo = '#URL.ID#'				
</cfquery>	

<cfquery name="Taxes"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_Tax
</cfquery>	

<cf_divscroll>		

<cfform method="POST" name="inputform" 
	id="inputform" 
	action="#SESSION.root#/Warehouse/Maintenance/ItemMaster/Pricing/PricingSubmit.cfm?mission=#url.mission#&id=#url.id#&drillid=#url.drillid#">
	
<table width="96%" align="center">
	  	  
	<cfquery name="Cls" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Ref_ItemClass
		WHERE 	Code = '#Item.ItemClass#'
	</cfquery>
	
	<cfoutput>
	
	<cfif url.drillid neq "">
	
	<tr><td colspan="12" height="2"></td></tr>
	
	<tr class="line"><td colspan="12">
	
		<table width="100%" class="formpadding">
		
			<TR class="labelmedium">
		    <td height="14"><cf_tl id="Item">:</td>
		    <TD style="font-size:16px">#item.ItemNo# #Category.Description#	
			<td height="14"><cf_tl id="External">:</td>
		    <TD style="font-size:16px">#item.ItemNoExternal#			    
		    <td height="14"><cf_tl id="Class">:</td>
		    <TD style="font-size:16px">#Cls.Description#
		    <TD height="14"><cf_tl id="Code">:</TD>
		    <TD style="font-size:16px">#item.Classification#</TD>			
		    <TD height="14"><cf_tl id="Description">:</TD>
		    <TD style="font-size:16px">#item.ItemDescription#</TD>
			</TR>	
		
		</table>
	
	</td></tr>
		
	</cfif>
		
	</cfoutput>
	
	<cfset rowcnt = 0>
	
	<cfquery name="Warehouse"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT DISTINCT Warehouse
		FROM   ItemWarehouse I
		WHERE  ItemNo  = '#URL.ID#'			
		
		AND    I.Warehouse IN (SELECT Warehouse 
		                       FROM   Warehouse 
					  		   WHERE  Mission = '#url.mission#'
							   AND    Warehouse = I.Warehouse 
							   AND    Operational = 1)	
							   
		AND	   I.Warehouse IN (SELECT Warehouse
			                   FROM   WarehouseCategoryPriceSchedule
					           WHERE  Category   = '#Item.Category#'
							   AND    Operational = 1)
			 
							 
	</cfquery>	
	
	<!--- pricing globally --->
	
	<tr class="line labelmedium">
			<td colspan="12" height="34" style="font-size:28px"><cf_tl id="#URL.Mission#"></td>
	</tr>	
					
	<cfset w = "">				
	<cfinclude template="PricingDataContent.cfm">
				
	<tr><td height="5"></td></tr>
		
	<!--- by store --->

	<cfoutput query="warehouse">	
					
		<cfquery name="getWarehouse"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM   Warehouse
			WHERE  Warehouse = '#Warehouse#'		
		</cfquery>	
				
		<tr class="line labelmedium">
			<td colspan="11" style="font-size:25px">#getWarehouse.WarehouseName# (#Warehouse#)</td>
		</tr>	
			
	    <cfset w = warehouse>		
		
		<cfinclude template="PricingDataContent.cfm">
								
		<tr><td height="5"></td></tr>
		
	</cfoutput>
		
	<tr><td colspan="12" height="34" align="center">
	<input type="submit" class="button10g" style="width:150" name="Save" id="Save" value="Save">
	</td></tr>
	
</table>

</cfform>

</cf_divscroll>
