
<cfset doc = replace(url.documentamount,',','',"ALL")>
<cfset tax = replace(url.tax,',','',"ALL")>

<cfif doc eq "">
   <cfset doc = 0>
</cfif>

<cfif tax eq "">
    <cfset tax = 0>
</cfif>

<cftry>

		<cfset amt = doc*100/(100+tax)>
	
	<cfcatch>
	
		<cfset amt = 0>
	
	</cfcatch>
	
</cftry>	

<cfoutput>
	
	<input type="Text"
		 name       = "amountpayable"
	     id         = "amountpayable"
         message    = "Enter a valid amount"
		 validate   = "float"
		 required   = "Yes"
		 readonly
		 value      = "#numberformat(amt,',.__')#"
		 visible    = "Yes"
		 enabled    = "Yes"		  
		 size       = "15"
		 class      = "regularxxl"
		 maxlength  = "15"
		 style      = "width:160px;background-color:f4f4f4;border:1px solid silver;font-size:17px;text-align:right;padding-right:2px">
	
	<cfif url.tag eq "Yes">
		<script>
			tagging('#amt#')
		</script>  
	</cfif>
		  
</cfoutput>		  