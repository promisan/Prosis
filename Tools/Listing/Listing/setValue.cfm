
<cfoutput>
	<cfset val = evaluate("form.#url.field#")>	
	<cf_param name="val" default="" type="string">	
	#urldecode(val)#		
</cfoutput>


