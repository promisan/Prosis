
<cfquery name="Batch"
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		SELECT *
		FROM WarehouseBatch
		WHERE BatchId = '#url.id#'
</cfquery>		

<cfform method="POST" name="order">

<table width="100%" class="formpadding formspacing">

<tr><td colspan="2">

if not exists do below

Option will only be shown for confirmed transactions
Show the customer and allow to open it <br>
Select customer address (this address will go to organization address) <br>
Target date : effective - expiration <br>
Allow to select the type of workorder : delivery and class for the modality <br>

- Transfer to shipper 
- Delivery internal
- Orgunit that performs : orgunitimplementer
- OrgUnit that triggers => warehouse orgunit

<br>

Record the boxes and a memo text

<br>

-> save will create customer, workorder, workorder line and action + workflow for the action which can be view and processed here.

if exists we show the order and action


</td></tr>

<!--- delivery base screen --->

<tr class="labelmedium2"><td><cf_tl id="Customer"></td><td>allow to open customer</td></tr>
<tr class="labelmedium2"><td><cf_tl id="Address"></td><td>select from list</td></tr>
<tr class="labelmedium2"><td><cf_tl id="Packaging"></td>
	
	<cfquery name="Package"
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
			SELECT    CollectionId, BatchNo, CollectionCode, CollectionName, OfficerUserId, OfficerLastName, OfficerFirstName, Created
			FROM      WarehouseBatchCollection
		    WHERE     BatchNo = '#batch.BatchNo#'
			ORDER BY  CollectionCode
	</cfquery>		

	<td><input type="text" name="Packaging" class="regularxxl" value="#package.CollectionName#" style="width:400px" maxlength="70"></td>
	
</tr>

<tr class="labelmedium2"><td><cf_tl id="Delivery mode"></td>

    <td>
	
	<cfquery name="DomainClass"
		datasource="appsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
	
			SELECT       DC.ServiceDomain, DC.Code, DC.Description, DC.ListingOrder, DC.ServiceType, DC.PointerRequest
			FROM         ServiceItem AS S INNER JOIN
			             Ref_ServiceItemDomain AS D ON S.ServiceDomain = D.Code INNER JOIN
			             Ref_ServiceItemDomainClass AS DC ON D.Code = DC.ServiceDomain
			WHERE        S.ServiceDomain = 'DEL' 
			AND          S.Operational = 1 
			AND          DC.Operational = 1 
			AND          S.Code IN  (SELECT   ServiceItem
			                         FROM     ServiceItemMission
			                         WHERE    Mission = '#batch.Mission#')
			ORDER BY     DC.ListingOrder
		
	 </cfquery>		
	
	 <select id="domainclass" name="domainclass" size="1" class="regularxxl">
		 <cfoutput query="DomainClass">
			<option value="#Code#">#Description#</option>
		</cfoutput>
	 </select>
	
	</td>
	
</tr>
<tr class="labelmedium2"><td><cf_tl id="Date"></td><td>

	      <cf_intelliCalendarDate9
				FieldName="DateEffective" 
				Manual="True"		
				class="regularxxl"					
				DateValidStart="#Dateformat(Batch.TransactionDate, 'YYYYMMDD')#"
				Default="#Dateformat(Batch.TransactionDate, client.dateformatshow)#"					
				AllowBlank="False">	

</td></tr>

<tr class="labelmedium2"><td><cf_tl id="Memo"></td><td>

	   <input type="text" name="Memo" maxlength="80" class="regularxxl" style="width:500px">

</td></tr>

<tr><td colspan="2" class="line"></td></tr>

<tr><td colspan="2" align="center"><input class="button10g" style="width:200px" type="button" name="Submit" value="Submit"></td></tr>

</table>

</cfform>

<cfset ajaxonload("doCalendar")>