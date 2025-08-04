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

<cfparam name="url.selected"   default="">
<cfparam name="url.itemmaster" default="">

<cfquery name="ItemMasterObject" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		  SELECT I.*
		  FROM   ItemMasterObject I
		  WHERE  ItemMaster = '#url.itemmaster#'
		  AND ObjectCode IN
		  	(
				SELECT  Code
				FROM    Program.dbo.Ref_Object
				WHERE   (ObjectUsage IN
			       	(SELECT     ObjectUsage
			            FROM      Program.dbo.Ref_AllotmentVersion V, Program.dbo.Ref_AllotmentEdition A
            			WHERE      V.Code = A.Version AND A.Mission = '#url.mission#'
					)
				)
				
			)
</cfquery>


<cfform>
	<cfif url.mode eq "edit" or url.mode eq "add">
	
		<cfselect name="RippleObjectCode" class="regularxl" style="width:100px"
			query="ItemMasterObject" 
			value="ObjectCode" 
			display="ObjectCode" 
			selected="#url.selected#"
			queryposition="below">
				
		</cfselect>	
	<cfelse>
		<cfoutput>
			#url.selected#
		</cfoutput>
	</cfif>		
	
</cfform>