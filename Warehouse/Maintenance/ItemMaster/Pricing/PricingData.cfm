
<cfparam name="url.drillid" default="">

<cfif url.drillid neq "">

	<cf_screentop html="Yes" height="100%" label="Sales Pricing" layout="webapp" scroll="Yes" banner="gray" jquery="yes">
	
<cfelse>

	<cf_screentop html="No" layout="webapp" height="100%" label="Sales Pricing" scroll="Yes" jquery="yes">

</cfif>

<cf_calendarscript>

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

<cfoutput>

	<script>
		_cf_loadingtexthtml="";
		
		function applyform() {
	
			document.inputform.onsubmit() 
			if( _CF_error_messages.length == 0 ) {
             	ptoken.navigate('#SESSION.root#/Warehouse/Maintenance/ItemMaster/Pricing/PricingSubmit.cfm?mission=#url.mission#&id=#url.id#&drillid=#url.drillid#','process','','','POST','inputform')
			}   
		}


		function copyValues(w, m, s, c, type) {
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
				for(var i = 0; i < elem.length; i++) {
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

		function showPricingHistory(item, uom, priceschedule, warehouse, mission) {
			var vElement = 'detail_'+item+'_'+uom+'_'+priceschedule+'_'+warehouse+'_'+mission;
			var vURL = '#session.root#/warehouse/maintenance/itemmaster/pricing/pricingDetail.cfm';
			var vParams = '?itemno='+item+'&uom='+uom+'&priceschedule='+priceschedule+'&warehouse='+warehouse+'&mission='+mission;

			if ($('##'+vElement).html() != '') {
				$('##'+vElement).html('');
			} else {
				ptoken.navigate(vURL+vParams, vElement);
			}
		}
	</script>

</cfoutput>


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

<cf_divscroll id="process">		

<cfform method="POST" name="inputform" id="inputform" onsubmit="return false">
	
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
		
	<tr class="line"><td colspan="12">
	
		<table width="100%" class="formpadding">
		
			<TR class="labelmedium2 fixrow">
		    <td style="padding-left:5px;background-color:e6e6e6;padding-right:5px"><cf_tl id="Item">:</td>
		    <TD style="padding-left:5px">#item.ItemNo# #Category.Description#	
			<td style="padding-left:5px;background-color:e6e6e6;padding-right:5px"><cf_tl id="External"></td>
		    <TD style="padding-left:5px">#item.ItemNoExternal#			    
		    <td style="padding-left:5px;background-color:e6e6e6;padding-right:5px"><cf_tl id="Class"></td>
		    <TD style="padding-left:5px">#Cls.Description#
		    <TD style="padding-left:5px;background-color:e6e6e6;padding-right:5px"><cf_tl id="Code"></TD>
		    <TD style="padding-left:5px">#item.Classification#</TD>			
		    <TD style="padding-left:5px;background-color:e6e6e6;padding-right:5px"><cf_tl id="Description"></TD>
		    <TD style="padding-left:5px">#item.ItemDescription#</TD>
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
			<td colspan="12" height="50" style="font-size:28px"><cf_tl id="#URL.Mission#"></td>
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
			<td colspan="13" style="height:50px;font-size:25px">#getWarehouse.WarehouseName# (#Warehouse#)</td>
		</tr>	
			
	    <cfset w = warehouse>		
		
		<cfinclude template="PricingDataContent.cfm">
								
		<tr><td height="5"></td></tr>
		
	</cfoutput>
		
	<tr><td colspan="13" height="34" align="center">
	<input type="button" onclick="applyform()" class="button10g" style="width:250px;height:25px" name="Save" id="Save" value="Save">
	</td></tr>
	
</table>

</cfform>

</cf_divscroll>
