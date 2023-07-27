
<!--- get address --->

  <cfquery name="address"
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
			
			    SELECT    CA.AddressType, CA.DateEffective, CA.DateExpiration, A.AddressScope, A.Address, A.Address2, A.AddressCity, A.State, A.Country, A.AddressId
                FROM      CustomerAddress AS CA INNER JOIN
                          System.dbo.Ref_Address AS A ON CA.AddressId = A.AddressId
				WHERE     CA.CustomerId = '#url.CustomerId#' 		  
						
		</cfquery>		
		

<table>

<cfif address.recordcount eq "0">

    <tr><td><cf_tl id="No address found"></td></tr>

<cfelse>

	<tr><td>		
		
		<select name="AddressId" class="regularxxl">
		
			<cfoutput query="Address">
			    <option value="#addressid#">#AddressCity# #Address#</option>		
			</cfoutput>
		
		</select>
	
	</td></tr>

</cfif>

</table> 