
<cfcomponent>
	
	<cffunction name="LookupOptions" returnType="string">
			
		<cfoutput>
		
			<cf_tl id = "contains"    var = "vContains">
			<cf_tl id = "begins with" var = "vBegins">
			<cf_tl id = "ends with"   var = "vEnds">
			<cf_tl id = "is"          var = "vIs">
			<cf_tl id = "is not"      var = "vIsNot">
			<cf_tl id = "before"      var = "vBefore">
			<cf_tl id = "after"       var = "vAfter">												
			
			<cfsavecontent variable = "content">
			
				<OPTION value="CONTAINS">#vContains#
				<OPTION value="BEGINS_WITH">#vBegins#
				<OPTION value="ENDS_WITH">#vEnds#
				<OPTION value="EQUAL">#vIs#
				<OPTION value="NOT_EQUAL">#visNot#
				<OPTION value="SMALLER_THAN">#vBefore#
				<OPTION value="GREATER_THAN">#vAfter#
				
			</cfsavecontent>
			
		</cfoutput>
	
		<cfreturn content>
		
	</cffunction>
		
</cfcomponent>
