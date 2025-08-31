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
<cf_param name="Alias" 		default="" type="String">
<cf_param name="TableName" 	default="" type="String">

<cf_param name="URL.Code" 		default="" type="String">
<cf_param name="URL.Mission" 	default="" type="String">
<cf_param name="URL.ObjectId" 	default="" type="String">
<cf_param name="URL.Owner" 		default="" type="String">
<cf_param name="URL.Section"	default="" type="String">

<cfquery name="Parameter" 
	datasource="#Alias#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
	    FROM Parameter R
</cfquery>
 
<cfquery name="Item" 
	datasource="#Alias#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
	    FROM Ref_#Object#Section
	    WHERE Code = '#URL.Section#'
</cfquery>

<cfif Item.TemplateCondition neq "">
 
	 <cfif left(Item.TemplateCondition,1) neq "&">
	    <cfset cond = "&#Item.TemplateCondition#">
	 <cfelse>
	    <cfset cond = Item.TemplateCondition>
	 </cfif>
 
<cfelse>

	 <cfset cond = ""> 

</cfif>

<!--- 17/8/2008 Dev the below cftry code can be reviewed if still needed for TCP --->

<cftry>

	<cfquery name="Event" 
		datasource="#Alias#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     #Object#Event C
		WHERE    #Object#Id = '#URL.Id#' 
		ORDER BY EventDateEffective
	</cfquery>
	
	<cfset event = "#Event.ClaimEventId#">
	
	<cfcatch>
	     <cfset event = "">
	</cfcatch>

</cftry>

<cfif Item.Recordcount eq "1">
	
	<cfoutput>
			
		<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
		<!--- get a token which is 10 seconds valid so the below template indeed passes 
		      but not later unless it is the same user as  stored in the table --->
		<cfset mid = oSecurity.gethash()/>

		<!--- loading template --->		
		
		<cfif event neq "">
			<script>					   
			     parent.right.location = "#SESSION.root#/#Parameter.TemplateRoot#/#item.TemplateURL#?mid=#mid#&owner=#url.owner#&mission=#url.mission#&code=#URL.Code#&topic=#item.TemplateTopicId#&section=#URL.Section#&alias=#URL.alias#&tableName=#URL.TableName#&Object=#Object#&#Object##ObjectId#=#URL.Id##cond#&id1=#Event#"
			</script>
		<cfelse>
			<script>			    
			     parent.right.location = "#SESSION.root#/#Parameter.TemplateRoot#/#item.TemplateURL#?mid=#mid#&owner=#url.owner#&mission=#url.mission#&code=#URL.Code#&topic=#item.TemplateTopicId#&section=#URL.Section#&alias=#URL.alias#&tableName=#URL.TableName#&Object=#Object#&#Object##ObjectId#=#URL.Id##cond#"
			</script>
		</cfif>
	
	</cfoutput>

<cfelse>

	<script>
		alert("Template could not be found")
    </script>
		
</cfif>	

