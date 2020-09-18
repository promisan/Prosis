<cfparam name="URL.context" default="customerselectbox">
<cfoutput>
<cfif url.search eq "">

	<script>
		 document.getElementById("#URL.context#").className = "hide"
	</script> 

<cfelse>

	<script>
		 document.getElementById("#URL.context#").className = ""
	</script> 
	
</cfif>
</cfoutput>

<cfquery name="Parameter" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_ParameterMission
		WHERE  Mission = '#url.mission#'
</cfquery>

<cfquery name="Warehouse" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Warehouse
		WHERE  Warehouse = '#url.warehouse#'
</cfquery>

<cfquery name="Get" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     TOP 20 A.*			
		FROM       Customer A 	
		
		<cfif url.search neq "inmemory">				
		WHERE      (Reference LIKE '%#url.search#%' 
		                    OR CustomerName LIKE '%#url.search#%' 
							OR PhoneNumber LIKE '%#url.search#%' 
							OR eMailAddress LIKE '%#url.search#%')
		<cfelse>
		WHERE     CustomerId IN
                          (SELECT   CustomerId
                            FROM    vwCustomerRequest
							WHERE   Mission     = '#url.mission#'
							AND     Warehouse   = '#url.warehouse#'
							AND     ActionStatus ! = '9'
							AND     BatchNo is NULL
							<!--- not loaded from existing --->
							AND     BatchId is NULL)
		</cfif>
		AND        Mission = '#url.mission#'
		AND        Operational = 1
		<cfif Parameter.DefaultAddressType neq ''>
			AND    EXISTS
			(
				SELECT 'X'
				FROM   CustomerAddress CA
				WHERE  CA.CustomerId  = A.CustomerId
				AND    CA.AddressType = '#Parameter.DefaultAddressType#' 
				AND    EXISTS
				(
					SELECT 'X'
					FROM   System.dbo.Ref_Address RA
					WHERE  RA.AddressId = CA.AddressId
					AND    RA.Country = '#Warehouse.Country#'
				)
			)
		</cfif>
		ORDER BY   CustomerName 
</cfquery>

<table width="500" cellspacing="0" cellpadding="0" style="border:1px solid silver" bgcolor="white" id="tcustomer_search">

<input type="hidden" name="customerselectrow" id="customerselectrow" value="0">

<cfif get.recordcount eq "0">

	<tr><td height="50" align="center" class="labelmedium"><cf_tl id="No records found."> [<cf_tl id="Press enter to add">]</td></tr>
	
	  <script>
		document.getElementById('customeridselect').value='insert'
	</script>

</cfif>

<cfoutput query="get">

	<cfif currentrow eq "1">

	    <script>
			document.getElementById('customeridselect').value='#customerid#'
		</script>
	
	</cfif>

	<cfquery name="customerAddress" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		    SELECT  A.*
			FROM   CustomerAddress CA INNER JOIN
					System.dbo.Ref_Address A 
					ON CA.AddressId = A.AddressId
			WHERE  CustomerId = '#customerid#'
	</cfquery>
	
	<cfif customerAddress.recordcount eq 0>
		<cfset addressid = "00000000-0000-0000-0000-000000000000">
	<cfelse>
		<cfquery name="qCheck"
		datasource="AppsMaterials"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT AddressId 
			FROM   vwCustomerRequest
			WHERE CustomerId = '#customerid#'
		</cfquery> 							
		
		<cfif qCheck.recordCount eq 0>		
			<cfset addressid = customerAddress.AddressId>
		<cfelse>
			<cfset addressid = qCheck.AddressId>
		</cfif>	
				
	</cfif>	
	
	<tr><td id       = "customerline#currentrow#" 
	    name         = "customerline#currentrow#" 
		onclick      = "document.getElementById('#URL.context#').className='hide';ptoken.navigate('#SESSION.root#/warehouse/application/SalesOrder/POS/Sale/applyCustomer.cfm?warehouse=#url.warehouse#&customerid=#customerid#&addressid=#addressid#','customerbox');" 
	    class        = "regular" 
		style        = "cursor:pointer"
	    onmouseover  =  "if (this.className=='regular') { this.className='highlight2' }"
		onmouseout   =  "if (this.className=='highlight2') { this.className='regular' }">
						
		<input type="hidden" name="r_#currentrow#_customermeta" id="r_#currentrow#_customermeta" value="#get.Reference#">				
		<input type="hidden" name="r_#currentrow#_customerid"   id="r_#currentrow#_customerid"     value="#CustomerId#">
					
		<table width="100%" class="formpadding">
		     
        <tbody>
            <tr style='height:20px;padding: 5px;'>
                <td class="s0" style="width:50%;" dir="ltr"><p style="font-size: 15px;padding: 3px 0 0 10px;"><i class="fas fa-user-circle"></i> #get.CustomerName#</p></td>
                <td class="s0" style="width:50%;" style="width:50%;" dir="ltr"><p style="font-size: 13px;"><b>NIT:</b> #get.Reference#<p></td>
            </tr>
            <tr style='height:20px;'>
                <td class="s0" style="width:50%;" dir="ltr"><p style="font-size: 12px;padding:1px 0 4px 12px;color:##555555;"><i class="fas fa-envelope-square"></i> #get.eMailAddress#</p></td>
                <td class="s0" style="width:50%;" dir="ltr"><p style="font-size: 12px;padding:1px 0 4px 0;color:##555555;"><i class="fas fa-phone-square"></i> #get.PhoneNumber#</p></td>
            </tr>
            <cfif currentrow neq recordcount>
				<tr>
                    <td colspan="3" class="linedotted"></td>
                </tr>
			</cfif>
        </tbody>
         		
		</table>
	
	</td></tr>
			
</cfoutput>

</table>
