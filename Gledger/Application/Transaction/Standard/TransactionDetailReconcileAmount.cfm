
<cfoutput>

	<cfset url.amount = replace(url.amount,',','',"ALL")>	
	<cfset out = replace(url.outstanding,',','',"ALL")>
	
	<cfif not LSIsNumeric(url.amount)>
	   <font color="FF0000">incorrect</font>
	   <cfabort>
	</cfif>
	
	<cfset val = url.amount*url.exchange>
	
	<cfoutput>

		<script>
			 document.getElementById('val_#url.field#').value = "#NumberFormat(url.amount,'_,____.__')#"
		</script>
		
	</cfoutput>
	
	<cfif val lte out>
	
	     <script>
			 document.getElementById('off_#url.field#').value = "#NumberFormat(val,'_,____.__')#"
		</script>
				 
	<cfelse>
	
		<cfset exc = out/url.amount>
					 
			 <script>	
			     alert("Outstanding amount exceeded, will correct the exchange.")		 
				 ptoken.navigate('TransactionDetailReconcileExchange.cfm?line=#url.line#&field=#url.field#&exchange=#exc#','total')	
			 </script>
	
	</cfif>	 

</cfoutput>

<script>	
	settotal()
</script>
