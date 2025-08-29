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
<cfparam name="url.selected" default="">
<cfparam name="url.init" default="0">

<cfquery name="ItemMaster" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		  SELECT I.Code, I.Description, R.Description as EntryClass
		  FROM   ItemMaster I, Ref_EntryClass R
		  WHERE I.EntryClass = R.Code
		  <!--- has entry for that mission --->
		  AND    I.Code IN (SELECT ItemMaster FROM ItemMasterMission M WHERE ItemMaster = I.Code and Mission = '#URL.Mission#')
		  <!--- has one or more OE --->
		  AND    I.Code IN (SELECT ItemMaster FROM ItemMasterObject WHERE ItemMaster = I.Code)		
		  ORDER BY R.ListingOrder, I.Code,I.Description, R.Description		 
</cfquery>

<cfform>

	<cfif url.mode eq "edit" or url.mode eq "add">
	
		<cfselect name = "RippleItemMaster" 
		     group     = "EntryClass" 
			 query     = "ItemMaster" 
			 onchange  = "_cf_loadingtexthtml='';ptoken.navigate('Budgeting/getItemMasterObject.cfm?itemmaster='+this.value+'&mission=#URL.Mission#&mode=#URL.mode#','itemmasterobject')" 
			 value     = "Code" 
			 style     = "width:99%"
			 display   = "Description" 
			 class     = "regularxl"
			 selected  = "#url.selected#"
			 queryposition="below">
				<option name=""></option>
			</cfselect>	 
	<cfelse>
		<cfquery name="ItemMaster" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				  SELECT Description
				  FROM   ItemMaster I
				  WHERE Code = '#URL.selected#'
		</cfquery>	
	
		<cfoutput>
		#ItemMaster.Description#		
		</cfoutput>
	</cfif>
	
</cfform>

<cfoutput>
<cfif url.init eq "0">

	<script language="JavaScript">
		 ptoken.navigate('Budgeting/getItemMasterObject.cfm?itemmaster=#url.selected#&mission=#url.mission#&mode=#URL.mode#','itemmasterobject')
	</script> 

</cfif>
</cfoutput>