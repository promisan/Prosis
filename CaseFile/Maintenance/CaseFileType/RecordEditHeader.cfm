<cfquery name="Get" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ClaimType
	WHERE  Code = '#URL.ID1#'
</cfquery>


<cfoutput>
	<table width="100%">
		 <TR>
			 <TD class="labellarge" style="padding-top:5px;"><b>#get.Code# - #get.Description#</b></TD>  
		 </TR>
	</table>
</cfoutput>