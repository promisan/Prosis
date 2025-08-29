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
<cfoutput>

<cfparam name="url.mission" default="">
<cfparam name="url.owner" default="">
<cfparam name="url.condition" default="">


<cfset con = replace(url.condition,"|","&","ALL")> 

<cfif action eq "1">

		<cfquery name="Check" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO UserFavorite
				(Account,
				 SystemFunctionId,
				 <cfif url.mission neq "">
				 Mission,
				 </cfif>
				 <cfif url.owner neq "" and owner neq "undefined">
				 Owner,
				 </cfif>
				 <cfif url.condition neq "" and owner neq "undefined">
				 Condition,
				 </cfif>
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
				VALUES				
				('#SESSION.acc#',
				 '#systemFunctionId#',
				 <cfif url.mission neq "">
				 '#url.mission#',
				 </cfif>
				 <cfif url.owner neq "" and owner neq "undefined">
				 '#url.owner#',
				 </cfif>
				 <cfif url.condition neq "" and owner neq "undefined">
				 '#con#',
				 </cfif>
				 '#SESSION.acc#',
				 '#SESSION.last#',
				 '#SESSION.first#')
	</cfquery>	
		
		 <button class="button3" onClick="favorite('0','#systemFunctionId#','#mission#')">     
		 	 	<img src="#SESSION.root#/Images/favorite.gif" height="14" width="14" alt="Remove as Favorite" border="0" style="cursor: pointer;" border="0" align="absmiddle">
		 </button> 	

<cfelse>
	
		<cfquery name="DEL" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE FROM UserFavorite
				WHERE Account    = '#SESSION.acc#'
				AND   SystemFunctionId = '#systemFunctionId#'
				<cfif url.mission neq "" and url.mission neq "undefined">
				AND   Mission = '#mission#'			
				</cfif>
				<cfif url.owner neq "" and url.owner neq "undefined">
				AND   Owner = '#owner#'				
				</cfif>
		</cfquery>	
		
		 <button class="button3" onClick="favorite('1','#systemFunctionId#','#mission#')">     
	 		 	<img src="#SESSION.root#/Images/favoriteset1.gif" height="14" width="14" alt="Set as Favorite" border="0" style="cursor: pointer;" border="0" align="absmiddle">
		 </button> 	

</cfif>

</cfoutput>

<cfquery name="Check" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * FROM UserFavorite
		WHERE Account    = '#SESSION.acc#'
</cfquery>	

<cfif Check.recordcount gte "1">
  <script>
     try {
	  parent.document.getElementById("favfunction").className = "regular" } catch(e) {}
  </script>
<cfelse>
	<script>
	  try {
	  parent.document.getElementById("favfunction").className = "hide" } catch(e) {}
  </script>
</cfif>