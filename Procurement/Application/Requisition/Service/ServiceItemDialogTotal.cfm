
<!--- total --->


<cftry>

	<cfset tot = "#url.sqty*url.qty*url.rate#">
	
	<cfoutput>
		  
	  		<input type="Text"
			   name="svctotal"
			   style="text-align: right;" 
		       value="#numberformat(tot,'__,__.__')#"	
			   readonly		       
			   style="width:80"
			   maxlength="10"
			   class="regularxl">

	</cfoutput>	

	<cfcatch>n/a</cfcatch>

</cftry>