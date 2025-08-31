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
<cfparam name="url.refresh" default="0">

<cfset vThresholdGroupNumber = 1>
<cfset vThresholdRowsNumber = 50>

<cfif url.refresh eq "1">
	<cfinclude template="MyClearancesDataPrepare.cfm">
</cfif>

<cfquery name = "ResultListing" datasource="AppsQuery">
    SELECT  * 
    FROM    #Session.acc#_ActionResultDataset
    WHERE   1=1
    <cfif URL.EntityGroup neq "">
    AND     EntityGroup = '#URL.EntityGroup#'
    </cfif>
    <cfif URL.Mission neq "">
    AND     Mission = '#URL.Mission#'
    </cfif>
    <cfif URL.Owner neq "">
    AND    Owner = '#URL.Owner#'
    </cfif>		
    ORDER BY ListingOrder, SystemModule, EntityOrder, EntityCode 	
</cfquery>

<cfset vGroups = 0>

<cf_mobilepanel bodystyle="border:0px; padding-top:0px; padding-bottom:0px;">
    <cfoutput query="ResultListing" group="application">
        <cf_mobilerow>
            <cf_mobilecell class="col-lg-12">
				<table style="width:100%" align="right">
				<tr>
				<td align="right" style="border-top:0px solid silver;padding-right:10px;font-size:17px;height:35px;background-color:e4e4e4">#Application#</td>
				</tr>
				</table>                
            </cf_mobilecell>
        </cf_mobilerow>
        <cfoutput group="entitycode">
            <cfset vGroups = vGroups + 1>
            <cf_mobilerow class="rowHighlight clsActionGroup" onclick="toggleGroup('#entityCode#', '#url.entitydue#','#url.entitygroup#', '#url.mission#', '#url.owner#', '#url.me#');" style="cursor:pointer; padding-left:20px;">
                <cf_mobilecell class="col-xs-8 subGroupTitle clsHeader clsHeader_#entityCode#">
                    #EntityDescription#
                </cf_mobilecell>	

                <cf_mobilecell class="col-xs-4 subGroupTitle pullTextRight clsHeader clsHeader_#entityCode#">
                    <cfquery name="Total" dbtype="query">
                        SELECT     *
                        FROM       ResultListing
                        WHERE      EntityCode = '#EntityCode#'
                    </cfquery>			 
                
                    <cfquery name="Overdue" dbtype="query">
                        SELECT count(*)
                        FROM   ResultListing
                        WHERE  EntityCode = '#EntityCode#'
                        AND    due > ActionLeadTime+5 
                    </cfquery>	

                    <span class="subGroupSubTitle">
							#Total.Recordcount# (&nbsp;#Overdue.recordcount#&nbsp;|&nbsp;<span style="color:##FF0000;">#Total.Recordcount-Overdue.recordcount#</span>&nbsp;)					
					</span>
                </cf_mobilecell>
			
            </cf_mobilerow>
            <cf_mobilerow class="clsRow_#EntityCode# clsEntityContainer" id="container_#entityCode#" style="display:none; padding-left:60px; width:98%;" />
        </cfoutput>
    </cfoutput>
</cf_mobilepanel>

<cfif vGroups lte vThresholdGroupNumber AND ResultListing.recordCount lte vThresholdRowsNumber>
    <cfset ajaxOnLoad("function(){ $('.clsActionGroup').trigger('click'); }")>
</cfif>