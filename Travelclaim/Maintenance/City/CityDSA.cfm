	
	<cfparam name="url.id" default="">
	<cfparam name="url.locationcode" default="">
				
	<cfquery name="Location" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     R.CountryCityId, 
	           R.LocationCode, 
			   R.DateEffective,
			   R.DateExpiration, 
			   L.Description, 
			   L.LocationCity, 
			   L.LocationCountry,
			   L.SeasonalRate,
			   L.HotelRate,
			   C.LocationCountry,
			   R.LocationDefault
	FROM       Ref_CountryCityLocation R,
               Ref_PayrollLocation L,
			   Ref_CountryCity C 
	WHERE      R.LocationCode  = L.LocationCode
	AND        R.CountryCityId = '#CountryCityId#'		   
	AND        C.CountryCityId = R.CountryCityId 
	</cfquery>		
			
	<cfif Location.recordcount eq "0">
	
		<table width="100%" bordercolor="silver" cellspacing="1" cellpadding="1" align="center">
		
			<tr><td align="center"><b><font color="FF0000">No DSA location associated</b></td></tr>			
			<tr>
			<td align="center" id="cityadd_<cfoutput>#CountryCityId#</cfoutput>_"></td>
			</tr>
		
		</table>
		
	<cfelse>
	
		<table width="100%" border="0"  bordercolor="e4e4e4" cellspacing="0" cellpadding="1" align="center">		
					
		<tr>
		    <td></td>
			<td colspan="6" align="center" id="cityadd_<cfoutput>#CountryCityId#</cfoutput>_">
			<cfif url.id eq CountryCityId>
			    <cfset url.countrycityid = countrycityid>				
				<cfinclude template="CityDSAAdd.cfm">
			</cfif>
			</td>
		</tr>
		
		<cfoutput query="Location">
		
		<cfif LocationDefault eq "1">
			<cfset color = "EFEFEF">		
		<cfelse>
			<cfset color = "FFFFFF">
		</cfif>
		<tr bgcolor="#color#">
		
		<td width="20" align="center" bgcolor="white">		
		<td width="60">#LocationCity#</td>
		<td width="30%">#Description#</td>
		<td width="150">
		<cfif dateeffective neq "" or dateexpiration neq "">
		#DateFormat(DateEffective, CLIENT.DateFormatShow)# - #DateFormat(DateExpiration, CLIENT.DateFormatShow)#
		<cfelse>
		 All dates
		</cfif>
				
		<td width="20%">
		
			<table border="0" cellspacing="1" cellpadding="1">
			<tr>
			   
				<cfif HotelRate eq "0">	
				<td class="top3n" style="border: 1px solid Gray;">
				<font size="1" color="C0C0C0">
				<a href="javascript:dsaEdit('#CountryCityId#','#LocationCode#','Hotel','1')">Set Hotel</a>
				</b>
				<cfelse>
				<td>
					<img src="#CLIENT.VirtualDir#/Images/claim/bed.gif" 
			          	border="0" 
						onclick="dsaEdit('#CountryCityId#','#LocationCode#','Hotel','0')"
						alt="Click to reverse"
						align="absmiddle"
						style="cursor: hand;">
				
				</cfif>
				</td>
							
				<cfif SeasonalRate eq "0">				
				<td class="top3n" style="border: 1px solid Gray;">
				<font size="1">
				<a href="javascript:dsaEdit('#CountryCityId#','#LocationCode#','Season','1')">Set Seasonal</a>
				</b>
				<cfelse>
				<td>
					<img src="#CLIENT.VirtualDir#/Images/claim/holiday.gif" 
			        	border="0" 
						onclick="dsaEdit('#CountryCityId#','#LocationCode#','Season','0')"
						alt="Click to reverse"
						align="absmiddle"
						style="cursor: hand;">
				
				</cfif>
				</td>
			</tr>
			</table>
		
		</td>
		<td width="2"></td>
		
		<td align="right" width="15%">
			 <table>
				<tr>
					<td>
						<cf_img icon="edit" onclick="dsaNew('#CountryCityId#','#LocationCode#','edit')">
					</td>
					<td>
						 <cfif LocationDefault eq "0" or DateEffective neq "">						
						 	<cf_img icon="delete" onclick="dsaEdit('#CountryCityId#','#LocationCode#','default','delete');">
						</cfif>	 
					</td>
					<td>
						<cfif LocationDefault eq "0">	
							<font size="1">
							<a href="javascript:dsaEdit('#CountryCityId#','#LocationCode#','default','edit')">Set&nbsp;as&nbsp;Default</a>
							</b>
						<cfelse>
							<img src="#CLIENT.VirtualDir#/Images/favorite.gif" 
					            alt="Default" 
								border="0" 
								align="absmiddle"
								style="cursor: hand;">		
						</cfif>		
					</td>
				</tr>
			 </table>
			 		
		
		&nbsp;					
								
		</td>	
		</tr>
		
		<tr>
		   <td></td>
		   <td colspan="6" height="0" id="cityadd_#CountryCityId#_#locationcode#">
		   </td>
		</tr>
		
		<cfif LocationDefault eq "1">
		<tr><td></td><td height="1" bgcolor="C0C0C0" colspan="6"></td></tr>
		</cfif>
		
		<cfquery name="Last" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   DateEffective
		FROM     Ref_ClaimRates
		WHERE    ClaimCategory = 'DSA' 
		AND      ServiceLocation = '#LocationCode#'
		ORDER BY DateEffective DESC
		</cfquery>	
		
		<cfquery name="Rate" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_ClaimRates
		WHERE    ClaimCategory = 'DSA' 
		AND      ServiceLocation = '#LocationCode#'
		AND      DateEffective = '#DateFormat(Last.DateEffective, client.DateSQL)#'
		ORDER BY DateEffective DESC
		</cfquery>	
			
		<cfloop query="Rate">
		   
			<tr>
				<td></td>
				<td><&nbsp;#RatePointer# days</td>
				<td>#DateFormat(DateEffective, CLIENT.DateFormatShow)#-
				<cfif dateexpiration eq "">no expiry<cfelse>#DateFormat(DateExpiration, CLIENT.DateFormatShow)#</cfif>
				<td>#Currency# #numberFormat(Amount,"_,__.__")#</td>
				<td colspan="2">USD #numberFormat(AmountBase,"_,__.__")# </td>
			</tr>
			
		</cfloop>
								
		</cfoutput>
		
		</table>
			
	</cfif>		
	
	


	