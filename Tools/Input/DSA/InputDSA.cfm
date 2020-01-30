

<cfparam name="attributes.Box"              default="DSA">
<cfparam name="attributes.class"            default="regular">
<cfparam name="attributes.Country"          default="">
<cfparam name="attributes.Name"             default="TopicValueCode">
<cfparam name="attributes.Selected"         default="">
<cfparam name="Attributes.Required"         default="Yes">
<cfparam name="attributes.Function"         default="">
<cfparam name="attributes.Passtru"          default="">
<cfparam name="attributes.Line"             default="1">

<cfquery name="GetSelect" 
	datasource="AppsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     * 
		FROM       Ref_PayrollLocation 			
		<cfif attributes.selected neq "">
		WHERE      LocationCode = '#attributes.selected#' 		
		<cfelse>
		WHERE  1=0
		</cfif>
</cfquery>			

<cfquery name="GetCountry" 
	datasource="AppsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT DISTINCT LocationCountry, Name 
		FROM   Ref_PayrollLocation L INNER JOIN System.dbo.Ref_Nation N 
				ON     (N.Code = L.LocationCountry 
							OR N.ISOCode  = L.LocationCountry	
							OR N.ISOCODE2 = L.LocationCountry)
	    WHERE   1 = 1
		<cfif attributes.country neq "">
		AND      LocationCountry = '#attributes.country#' 
		</cfif>
		AND     LocationCountry <> '---' 
		AND     HotelRate = 0
		AND     (DateExpiration is NULL or DateExpiration > getDate())	
		ORDER BY LocationCountry
</cfquery> 

<table style="width:100%" cellspacing="0" cellpadding="0">
	
	<tr><td style="min-width:100">
		
		<select name="dsa_country_<cfoutput>#attributes.line#</cfoutput>" class="<cfoutput>#attributes.class#</cfoutput> enterastab">
			<cfoutput query="getCountry">
				<option value="#LocationCountry#" <cfif getSelect.locationcountry eq LocationCountry>selected</cfif>>#LocationCountry# #Name#</option>
			</cfoutput>
		</select>
	
	    </td>		
		
  	<td style="padding-left:4px">
		
		<cfdiv id="dsaselect_#attributes.line#" bindonload="Yes" 
		       bind="url:#session.root#/Tools/Input/DSA/InputDSALocation.cfm?line=#attributes.line#&class=#attributes.class#&name=#attributes.name#&function=#attributes.function#&passtru=#attributes.passtru#&country={dsa_country_#attributes.line#}&selected=#attributes.Selected#">
			
					
		</cfdiv>
		
		</td>
		
	</tr>

</table>

