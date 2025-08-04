<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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