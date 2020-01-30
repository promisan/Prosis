

<cfquery name="Clean"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    DELETE 
	FROM   Ref_PostTypeGrade
	WHERE  PostType = '#Url.PostType#'
</cfquery>


<cfloop index="g" from="1" to="#Form.groups#" step="1">

	<cfif isDefined("Form.PostGrade_#url.posttype#_#g#")>

		<cfset glist = Evaluate("Form.PostGrade_#url.posttype#_#g#")>


		<cfloop index="i" list="#glist#" delimiters=",">
		
			<cfquery name="Insert"
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    INSERT INTO Ref_PostTypeGrade
				VALUES(
					'#url.PostType#',
					'#i#',
					'#SESSION.acc#',
				    '#SESSION.last#',		  
					'#SESSION.first#',
					getDate()
				)
			</cfquery>
		
		</cfloop>
	
	</cfif>
	
</cfloop>

<font color="#0080C0">
Saved!
</font>