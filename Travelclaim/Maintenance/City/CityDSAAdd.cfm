		
	<cfparam name="url.mode" default="Add">		
	<cfparam name="url.result" default="">
	<cfparam name="url.locationcode" default="">			
	
	<cfquery name="Loc" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     *
		FROM       Ref_CountryCity  
		WHERE      CountryCityId = '#URL.CountryCityId#'	
	</cfquery>	
	
	<cfif url.mode eq "Add">
	
		<cfquery name="DSA" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  *
			FROM    Ref_PayrollLocation
			WHERE   LocationCountry = '#Loc.LocationCountry#'
			AND     LocationCode NOT IN (SELECT LocationCode 
			                            FROM   Ref_CountryCityLocation 
										WHERE  CountryCityId = '#URL.CountryCityId#')
		</cfquery>	
	
	<cfelse>
	
		<cfquery name="DSA" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  *
			FROM    Ref_PayrollLocation
			WHERE   LocationCode = '#URL.LocationCode#'		
		</cfquery>	
	
	</cfif>
	
	<cfquery name="CityDSA" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  *
			FROM    Ref_CountryCityLocation
			WHERE   LocationCode  = '#URL.LocationCode#'		
			AND     CountryCityId = '#URL.CountryCityId#'
		</cfquery>	
	
	<cfif DSA.recordcount eq "0" and url.mode eq "Add">
	
	<table width="100%" bordercolor="silver" cellspacing="1" cellpadding="1" align="center">
		
			<tr><td align="center"><b><font color="FF0000">No other valid DSA codes found</b></td></tr>
					
		</table>
		
	<cfelse>
		
		<cfoutput>		
					
		<table bgcolor="ffffff" width="100%" cellspacing="1" cellpadding="1">	
		<tr><td colspan="6" bgcolor="silver" height="1"></td></tr>										
		<tr>
			<td width="100">DSA code:</td>
			<td><select name="#URL.CountryCityId#_#URL.LocationCode#_LocationCode">
				<cfloop query="DSA">
				   <option value="#LocationCode#" <cfif url.locationcode eq locationcode>selected</cfif>>#LocationCode# #Description#</option>
				</cfloop>
				</select>
			</td>	
			<td>Effective:</td>
			<td>
				<input type="Text"
			      name="#URL.CountryCityId#_#URL.LocationCode#_DateEffective"
			      value="#dateformat(cityDSA.dateeffective,CLIENT.DateFormatShow)#"
			      style="text-align: center"
			      size="10">
			</td>
			<td>Expiration:</td>
			<td>
				<input type="Text"
			      name="#URL.CountryCityId#_#URL.LocationCode#_DateExpiration"
			      value="#dateformat(cityDSA.dateExpiration,CLIENT.DateFormatShow)#"
			      style="text-align: center"
			      size="10">
			</td>
		</tr>
		
		<cfif url.result neq "">
		<tr>
			<td></td>
			<td>
			#url.result#			
			</td>
		</tr>
		
		</cfif>
		
		<tr>
			<td>Default</td>					  
			<td>
			<input type="radio" 
			        name="#URL.CountryCityId#_#URL.LocationCode#_LocationDefault" 
					value="0" 
					 <cfif cityDSA.locationDefault eq "0" or cityDSA.locationDefault eq "">checked</cfif>>No
			<input type="radio" 
			        name="#URL.CountryCityId#_#URL.LocationCode#_LocationDefault" 
					value="1" <cfif cityDSA.locationDefault eq "1">checked</cfif>>Yes
			</td>			
		</tr>
		<tr><td colspan="6" align="center">	
			<input type="button" value="Close" class="button10g" onclick="javascript:dsaHide('#URL.CountryCityId#','#URL.LocationCode#')">
			<input type="button" value="Save"  class="button10g" onclick="javascript:dsasave('#URL.CountryCityId#','#URL.LocationCode#')">
			</td>
		</tr>		
		</table>
		
		</cfoutput>		
		
	</cfif>	
			
				