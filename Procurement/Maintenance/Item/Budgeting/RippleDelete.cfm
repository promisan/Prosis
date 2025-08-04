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
<cfif URL.id eq "" OR URL.id2 eq "" OR URL.id3 eq "" OR URL.id4 eq "" OR URL.eff eq "">
	<script>
		alert('Please define all the inputs');
	</script>
	<cfabort>
</cfif>

<cfquery name="qDelete" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM ItemMasterRipple
	WHERE Code             = '#URL.id#' 
	AND   TopicValueCode   = '#URL.id1#' 
	AND   Mission          = '#URL.id2#'
	AND   RippleItemMaster = '#URL.id3#'
	AND   RippleObjectCode = '#URL.id4#'
	AND   DateEffective    = '#url.eff#' 
</cfquery>

<cfoutput>
<script>
	ptoken.navigate('Budgeting/RecordRipple.cfm?Code=#URL.id#&mode=view','ripple');
</script>
</cfoutput>	