
<cfquery name="Clean"
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    DELETE 
	FROM   Ref_ApplicationModule
	WHERE  Code = '#url.application#'
</cfquery>

<cfif isDefined("Form.module_#url.application#")>

	<cfset glist = Evaluate("Form.module_#url.application#")>

	<cfloop index="i" list="#glist#" delimiters=",">
	
		<cfquery name="Insert"
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    INSERT INTO Ref_ApplicationModule
			VALUES(
				'#url.application#',
				'#i#',
				'#SESSION.acc#',
			    '#SESSION.last#',		  
				'#SESSION.first#',
				getDate()
			)
		</cfquery>
	
	</cfloop>

</cfif>

<font color="#0080C0">
Saved!
</font>