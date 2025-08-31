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
<cfif URL.id eq "" OR URL.id2 eq "" OR URL.id3 eq "" OR URL.id4 eq "" OR URL.eff eq "">
	<script>
		alert('Please define all the inputs');
	</script>
	<cfabort>
</cfif>

<cfset dateValue = "">
<CF_DateConvert Value="#url.eff#">
<cfset EFF = dateValue>
	
<cfquery name="qCheck" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * FROM ItemMasterRipple
	WHERE Code           = '#URL.id#' 
	AND TopicValueCode   = '#URL.id11#' 
	AND Mission          = '#URL.id22#'
	AND RippleItemMaster = '#URL.id33#'
	AND RippleObjectCode = '#URL.id44#'
	AND DateEffective    = '#URL.id55#'
</cfquery>

<cfif qCheck.recordcount eq "1">

	<cfquery name="qUpdate" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE ItemMasterRipple
		SET    TopicValueCode   = '#url.id1#',
               Mission          = '#url.id2#',
               RippleItemMaster = '#url.id3#',
               RippleObjectCode = '#url.id4#',
			   DateEffective    = #eff#,
               BudgetMode       = '#url.id5#',
               BudgetAmount     = '#url.id6#',
		       Operational      = '#url.id7#'
		WHERE  Code             = '#URL.id#' 
		AND    TopicValueCode   = '#URL.id11#' 
		AND    Mission          = '#URL.id22#'
		AND    RippleItemMaster = '#URL.id33#'
		AND    RippleObjectCode = '#URL.id44#'	
		AND    DateEffective    = '#URL.id55#'		
	</cfquery>

	<cfoutput>
	<script>
		ptoken.navigate('Budgeting/RecordRipple.cfm?Code=#URL.id#&mode=view','ripple');
	</script>
	</cfoutput>	
	
<cfelse>

	<cfquery name="qCheck" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   ItemMasterRipple
		WHERE  Code             = '#URL.id#' 
		AND    TopicValueCode   = '#URL.id1#' 
		AND    Mission          = '#URL.id2#'
		AND    RippleItemMaster = '#URL.id3#'
		AND    RippleObjectCode = '#URL.id4#'
		AND    DateEffective    = '#URL.id8#'
	</cfquery>

	<cfif qCheck.recordcount eq 0>
	
		<cftransaction>
		
		<cfquery name="qDelete" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE ItemMasterRipple
			WHERE  Code = '#URL.id#' 
			AND    TopicValueCode   = '#URL.id11#' 
			AND    Mission          = '#URL.id22#'
			AND    RippleItemMaster = '#URL.id33#'
			AND    RippleObjectCode = '#URL.id44#'
			AND    DateEffective    = '#URL.id55#'
		</cfquery>

		<cfquery name="qInsert" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO ItemMasterRipple
	           (Code
	           ,TopicValueCode
	           ,Mission
	           ,RippleItemMaster
	           ,RippleObjectCode
			   ,DateEffective
	           ,BudgetMode
	           ,BudgetAmount
	           ,Operational
	           ,OfficerUserId
	           ,OfficerLastName
	           ,OfficerFirstName)
	     VALUES
	           ('#url.id#',
			    '#url.id1#',
			    '#url.id2#',
			    '#url.id3#',
				'#url.id4#',
				'#eff#',
				'#url.id5#',
				'#url.id6#',
				1,
				'#Session.acc#',
				'#Session.first#',
				'#Session.last#'
			   ) 
		</cfquery>
		</cftransaction>	
	
	<cfelse>
		<script>
			alert('An existing entry has been defined');	
		</script>
	</cfif>
	
</cfif>	

