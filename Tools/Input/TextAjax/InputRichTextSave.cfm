
<!--- ajax saving on the fly --->		
	
<!--- saves the report selection fields --->

<cfset content = evaluate("Form.fld#url.name#")>

<cfquery name="Check" 
		datasource="#url.DataSource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM #url.TableName# 
		WHERE   #url.keyfield1# = '#url.keyvalue1#' 
		 <cfif url.keyfield2 neq "">
		 AND     #url.keyfield2# = '#url.keyvalue2#' 
		</cfif>
</cfquery>

<cfif check.recordcount eq "1">

		<cfquery name="Update" 
		datasource="#url.DataSource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		     UPDATE  #url.TableName# 
			 SET     #url.field#     = '#content#'
		     WHERE   #url.keyfield1# = '#url.keyvalue1#' 
			 <cfif url.keyfield2 neq "">
			 AND     #url.keyfield2# = '#url.keyvalue2#' 
			 </cfif>
		</cfquery>

<cfelse>

	<cfquery name="Insert" 
		datasource="#url.DataSource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		   INSERT INTO #url.TableName#
		   (  #url.keyfield1#,
		   	  <cfif url.keyfield2 neq "">#url.keyfield2#,</cfif>
			  #url.field#,
			  OfficerUserId,
			  OfficerLastName,
			  OfficerFirstName
			)
			
			VALUES
			
			('#url.keyvalue1#',
			 <cfif url.keyfield2 neq "">'#url.keyvalue2#',</cfif>
		     '#content#',
			 '#SESSION.acc#',
			 '#SESSION.last#',
			 '#SESSION.first#'
			 )		   
		</cfquery>

</cfif>


<cfoutput>
<script>
	#AjaxLink('#SESSION.root#/tools/Input/TextAjax/InputRichTextAction.cfm?mode=view&datasource=#url.datasource#&tablename=#url.tablename#&keyfield1=#url.keyfield1#&keyvalue1=#url.keyvalue1#&keyfield2=#url.keyfield2#&keyvalue2=#url.keyvalue2#&name=#url.name#&field=#url.field#')#
</script>
</cfoutput>