
<cfoutput>

	<cfset amt = replace(url.amount,',','',"ALL")>	
	<cfset out = replace(url.outstanding,',','',"ALL")>
	<cfset exc = replace(url.exchange,',','',"ALL")>
	
	<cfif not LSIsNumeric(amt) or not LSIsNumeric(exc)>
	   <font color="FF0000">incorrect</font>
	   <cfabort>
	</cfif>
	
	<cfif amt gt out>
		<cfset amt = out>
	</cfif>
	
	<cfset val = amt/exc>
		
	<script>			
		document.getElementById('amt_#url.field#').value = "#NumberFormat(amt,'_,____.__')#"
		document.getElementById('off_#url.field#').value = "#NumberFormat(val,'_,____.__')#"
	</script>		 
	

</cfoutput>

