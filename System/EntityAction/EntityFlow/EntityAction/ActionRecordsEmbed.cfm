<cfoutput>

<cfset box = replace(actioncode,"-","","ALL")> 

 <cfquery name="Check" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_EntityActionDocument R 
		WHERE  R.ActionCode = '#ActionCode#'			
	 </cfquery>
					 
				<cfif check.recordcount eq "0">
			   			   
				 <img src="#SESSION.root#/Images/folder2.gif"
			     alt="Define Embedded Objects"
			     id="d#box#_min"
			     border="0"
				  height="12"
				 width="12"
				  align="absmiddle"
			     class="regular"
			     style="cursor:pointer"
			     onClick="object('#box#','#actioncode#')">
				 
				 <cfelse>
				 
				  <img src="#SESSION.root#/Images/agent.gif"
			     alt="Embedded Objects Associated"
			     id="d#box#_min"
			     border="0"
				  height="12"
				 width="12"
				  align="absmiddle"
			     class="regular"
			     style="cursor:pointer"
			     onClick="object('#box#','#actioncode#')">
				 
				 
				 </cfif>
				 
				<img src="#SESSION.root#/Images/icon_collapse.gif"
			     alt="Hide"
			     id="d#box#_max"
			     border="0"
				  height="12"
				 width="12"
				 align="absmiddle"
			     class="hide"
			     style="cursor:pointer"
			     onClick="object('#box#','#actioncode#')">
				 
</cfoutput>				 