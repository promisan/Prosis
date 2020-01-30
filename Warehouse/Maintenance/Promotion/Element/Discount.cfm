<cf_compression>

<!-- <cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#&promotionid=#url.promotionid#" method="POST" name="frmElement2"> -->

<cfset vDiscount = url.Discount>
<cfif vDiscount eq "">
	<cfset vDiscount = 0>
</cfif>

<cfif url.code eq "percentage">
	<cfif vDiscount*100 gt 100>
		<cfset vDiscount = 0>
	</cfif>
	
	<cfinput type="text" 
	       name="Discount" 
		   value="#vDiscount * 100#" 
		   message="Please enter a valid numeric discount percentage between 0 and 100." 
		   required="yes" 
		   validate="numeric" 
		   range="0,100" 
		   size="6" 
	       maxlength="6" 
		   class="regularxl" 
		   style="text-align:right;padding-right:2px;"> % Discount
	
<cfelseif url.code eq "cash">

	<cfinput type="text"
	       name="Discount" 
		   value="#vDiscount#" 
		   message="Please enter a valid numeric discount amount greater than 0." 
		   required="yes" 
		   validate="numeric" 
		   range="0,"
		   size="6" 
	       maxlength="6" 
		   class="regularxl" 
		   style="text-align:right;padding-right:2px;"> back
		   
<cfelseif url.code eq "fixed">

	<cfinput type="text"
	       name="Discount" 
		   value="#vDiscount#" 
		   message="Please enter a valid numeric price greater than 0." 
		   required="yes" 
		   validate="numeric" 
		   range="0,"
		   size="6" 
	       maxlength="6" 
		   class="regularxl" 
		   style="text-align:right;padding-right:2px;">		   
		   
</cfif>

<!-- </cfform> -->