
<!--- perform check --->


<cfset val = right("#url.source#","4")>


<cfif val eq ".JPG">		

			<cf_tl id="Apply Picture" var="1">
			<cfoutput>
				<input type="submit" 
				  name="Load" id="Load" value="#lt_text#" style="font-size:13px;width:170;height:27" 
				  class="photoupload button10g">
			</cfoutput>

<cfelse>

	<cfoutput>
		<script>
			alert("Unsupported format.")
		</script>
	</cfoutput>

</cfif>
