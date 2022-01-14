

<!--- address information tax code --->

<cfparam name="url.mission"   default="">
<cfparam name="url.addressid" default="">

<cfif url.addressid eq "">
		  
	<cfswitch expression="#url.context#">
		
		<cfcase value="TaxCode">
		
		   <cfquery name="TaxCode" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT * FROM CountryTaxCode
					WHERE  TaxCode = '#url.contextid#'	
			</cfquery>	
		
		</cfcase>
	
	</cfswitch>	
	
	<cfset addressid = TaxCode.addressid>	  
	
	
<cfelse>

   <cfset addressid = url.addressid>

</cfif>


<cfset url.mode = "edit"> 

<cfoutput>

<cfform name="theaddress" onsubmit="return false">

<table align="center" class="formpadding">
	
	<tr><td colspan="2" id="addressprocess"></td></tr>
	
	<tr><td colspan="2">
			
		    <!--- a NEW ddress object --->	
			<cf_address mode="#url.mode#" styleclass="labelmedium" addressid="#addressid#" addressscope="Tax" mission="#url.mission#" emailrequired="No">
						
		</td>
	</tr>
		
	<tr><td colspan="2" align="center">
	
	<input type="hidden" name="Addressid" value="#addressid#">
	
	<table>
	<tr>
	<td><input type="button" class="button10g" name="Close" value="Close" onclick="ProsisUI.closeWindow('address')"></td>
	<td><input type="button" class="button10g" name="Save" value="Save" onclick="saveaddress('#addressid#','#url.context#','#url.contextid#')"></td>
	</tr>
	</table>
	</td></tr>
	
</table>	

</cfform>

</cfoutput>