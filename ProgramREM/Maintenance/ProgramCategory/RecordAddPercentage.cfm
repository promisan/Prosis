
<cfquery name="Earmark" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT       *
		FROM         Ref_ParameterMissionCategory
		WHERE Category = '#url.par#' 
		AND BudgetEarmark = 1
	</cfquery>
	
	<cfif earmark.recordcount gte "1">
	
	<table cellspacing="0" cellpadding="0">
		<TR>	  
	    <TD>
	  	   <input type="Text" name="EarmarkPercentage" value="0" required="Yes" visible="Yes" enabled="Yes" showautosuggestloadingicon="True" typeahead="No" size="1" maxlength="3" class="regular">%
	    </TD>
		</TR>
	</table>
	
	<script>
	 document.getElementById('linepercent').className = "regular"
	</script>
	
	<cfelse>
	
	<script>
	 document.getElementById('linepercent').className = "hide"
	</script>
	
	
	</cfif>

