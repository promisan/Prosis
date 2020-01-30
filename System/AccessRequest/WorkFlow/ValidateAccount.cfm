

<cfparam name="url.acc" default="">


<cfquery name="Check" 
	     datasource="AppsSystem" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 
		 SELECT *
		 FROM   UserNames
		 WHERE  Account = '#url.acc#'
		 
</cfquery>

<cfoutput>

	<cfif Check.recordcount gt 0>
		<font color="red">
			Account is in use
			<input type="hidden" value="0" name="result" id="result">
		</font>
	<cfelse>
		<img src="#SESSION.root#/Images/check_mark.gif" alt="" border="0" align="absmiddle">
		<input type="hidden" value="1" name="result" id="result">
	</cfif>

</cfoutput>

