<!--
    Copyright © 2025 Promisan

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
<cfcomponent>

<cfproperty name="LocationTree" type="string" displayname="Organization Tree">

	<cffunction name="getNodesV2" access="remote" returnFormat="json" output="false" secureJSON = "yes" verifyClient = "yes">

		<cfargument name="path"       type="String" required="false" default=""/>
		<cfargument name="value"      type="String" required="true" default=""/>
		<cfargument name="mission"    type="String" required="true" default=""/>
		<cfargument name="template"   type="String" required="true" default=""/>

<!--- set up return array --->

		<cfset var result= arrayNew(1)/>
		<cfset var s =""/>

		<cfif value eq "">

			<cfset s = structNew()/>
			<cfset s.value     = "tree">
			<cfset s.img       = "">
			<cfset s.parent    = "tree">

<!--- following lines activated by dev on April 14 2014 ---->
			<cfset s.href      = "#template#?ID2=#mission#">
			<cfset s.target    = "right">

<!--- static tree --->
			<cfset s.display   = "<b><u>#mission#</b>">
			<cfset s.expand    = "true">

			<cfset arrayAppend(result,s)/>

		<cfelse>

			<cfset l = len(value)>
			<cfset val = mid(value,5,l-4)>

<!--- if arguments.value is empty the tree is being built for the first time --->

			<cfquery name="Node"
					datasource="AppsMaterials"
					username="#SESSION.login#"
					password="#SESSION.dbpw#">
				SELECT TreeOrder,
				LocationName,
				Location,
				LocationCode,
				LocationClass
				FROM   Location
				WHERE  Mission      = '#Mission#'
				<cfif value is "tree">
					AND  	ParentLocation is NULL
				<cfelse>
					AND  	ParentLocation = '#val#'
				</cfif>
				ORDER BY TreeOrder, LocationName
			</cfquery>


<!---
<cfif id eq "Org">

    <cfif SESSION.isAdministrator eq "No">
        AND  (
          Mission IN (SELECT Mission
                      FROM   Organization.dbo.OrganizationAuthorization
                      WHERE  UserAccount = '#SESSION.acc#'
                      AND    Role IN ('HRPosition', 'HRLoaner', 'HRLocator','HROfficer','HRAssistant')
                      AND    OrgUnit = '' OR OrgUnit is NULL
                      )

          <cfif accesslist neq "" and id eq "Org">
          OR OrgUnit IN (#PreserveSingleQuotes(AccessList)#)
          </cfif>
           )
    </cfif>

</cfif>
--->


			<cfoutput query="Node">

				<cfquery name="HasDetail"
						datasource="AppsMaterials"
						username="#SESSION.login#"
						password="#SESSION.dbpw#">
					SELECT   TOP 1 Location
					FROM     Location
					WHERE    Mission        = '#mission#'
				AND      ParentLocation = '#Location#'
				</cfquery>

				<cfquery name="Class"
						datasource="AppsMaterials"
						username="#SESSION.login#"
						password="#SESSION.dbpw#">
					SELECT   *
					FROM     Ref_LocationClass
					WHERE    Code = '#LocationClass#'
				</cfquery>

				<cfset s = structNew()/>
				<cfset s.value     = "node#location#">

				<cfif class.ListingIcon eq "">
					<cfset s.img       = "#SESSION.root#/images/option2.jpg">
				<cfelse>
					<cfset s.img       = "#SESSION.root#/images/#class.listingicon#">
				</cfif>
				<cfset s.parent    = "tree">
				<cfif HasDetail.recordcount eq "0">
					<cfset s.leafnode=true/>
				</cfif>
				<cfif len(LocationName) gt "40">
					<cfset s.display   = "#left(LocationName,40)#..">
				<cfelse>
					<cfset s.display   = "#LocationName#">
				</cfif>
				<cfset s.href      = "#template#?ID1=#Location#&ID2=#mission#">
				<cfset s.target    = "right">
				<cfset s.title     = "aaaaa">
				<cfset s.expand    = "false">
				<cfset arrayAppend(result,s)/>

			</cfoutput>

		</cfif>

		<cfscript>
			treenodes = result;
			msg = SerializeJSON(treenodes);
		</cfscript>

		<cfreturn msg>


	</cffunction>

</cfcomponent>
