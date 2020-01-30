<cfoutput>
<cfswitch expression="#cells.cellValueFormat#">
	<cfcase value="Text">								
		#val#
	</cfcase>

	<cfcase value="Currency">
		$ #numberformat(val,'__,__.__')#
	</cfcase>

	<cfcase value="Number">
		#numberformat(val,'__,__.__')#
	</cfcase>
</cfswitch>
</cfoutput>