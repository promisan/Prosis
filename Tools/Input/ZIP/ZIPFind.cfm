
<cfparam name="url.fld" default="">
<cfparam name="attributes.style" default="">

<cfif URL.Code neq "">
	
	<!--- Query returning search results --->
	<cfquery name="SearchResult" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	    FROM  PostalCode
	    WHERE PostalCode = '#URL.Code#' 
	</cfquery>
	
	<cfset l = len(SearchResult.PostalCode)>
	<cfset k = len(SearchResult.Location)>
	
	<cfoutput>
	
	    <cfif SearchResult.recordcount eq "1">
			<input size="#k+l+4#" 
			       type="text" 
				   name="Postal" 
				   id="Postal"
				   style="#attributes.style#"
				   value="#SearchResult.Location#" 			   
				   readonly class="regularxl">
				 
		<cfelse>
			&nbsp;<cf_tl id="...">&nbsp;
		</cfif>
		
	
	<cfif url.fld neq "">	
		
		<script>			
			$('###url.fld#').trigger('keyup');
		</script>
		
	</cfif>
	
	</cfoutput>

</cfif>

	