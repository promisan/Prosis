<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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