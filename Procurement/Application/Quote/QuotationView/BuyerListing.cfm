<!--- Create Criteria string for query from data entered thru search form --->

<cfoutput>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="silver">
				
		<tr>
		 <td colspan="9">
			 <table width="100%"  border="0">
			 <tr>
			 <td width="200" height="25" class="labelit">
							  
			 <cfset link = "BuyerListingSubmit.cfm?jobno=#url.id1#">
				
				<cf_tl id="Press HERE to insert another buyer" var="1">
										
				<cf_selectlookup
			    box          = "buyerbox"
				title        = "#lt_text#"
				link         = "#link#"
				button       = "No"
				close        = "No"
				class        = "user"
				des1         = "acc">	
					
			</td>
			</tr>
			</table>		   
			</td>
		</tr>
		
		
	<tr><td>	
	
	<cfdiv bind="url:#link#" id="buyerbox"/>
	
	</td>
	
	</tr>
	
		
</table>

</cfoutput>

