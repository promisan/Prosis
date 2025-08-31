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
<cfparam name="url.code" 			default="">
<cfparam name="url.listcode" 		default="">
<cfparam name="url.darkStyle" 		default="background-color:##6BBFB5; color:##FAFAFA;">
<cfparam name="url.lightStyle" 		default="background-color:##F5F5F5; color:##E0E0E0;">

<cfoutput>

<table width="100%" height="100%" border="0"><tr>

	<td width="100%" valign="top">
	
	<cftransaction isolation="READ_UNCOMMITTED">

	<cfquery name="TopicList"
	   datasource="AppsSelection"
	   username="#SESSION.login#"
	   password="#SESSION.dbpw#">
   	     SELECT * 
       	 FROM   #CLIENT.LanPrefix#Ref_TopicList
	  	 WHERE  Code = '#URL.Code#'		
		 AND    Operational = 1
		 ORDER BY ListOrder ASC
	</cfquery>	
	
	<cfif url.ListCode eq "">
		<cfset url.ListCode = TopicList.ListCode>
	</cfif>
	
	<cfif trim(TopicList.ListExplanationSelectedStyle) neq "">
		<cfset url.darkStyle = TopicList.ListExplanationSelectedStyle>
	</cfif>
	
	<cfquery name="ListCode"
	   datasource="AppsSelection"
	   username="#SESSION.login#"
	   password="#SESSION.dbpw#">
   	     SELECT * 
       	 FROM   #CLIENT.LanPrefix#Ref_TopicListCode
	  	 WHERE  ListCode = '#url.listcode#'				 
	</cfquery>	
	
	</cftransaction>
	
	<table width="100%" height="100%">
		
	<tr>
	
	<cfif ListCode.ListExplanation neq "">	    
		<td valign="top" class="labelmedium" style="border-right:1px solid silver;width:50%;font-size:13px;padding-top:9px;padding-left:4px;padding-right:6px">
		<table>
			<tr><td class="labelmedium" style="font-size:15px; padding-bottom:8px;"><b>#UCASE(ListCode.ListLabel)# (#UCASE(ListCode.ListCode)#)</td></tr>
			<tr><td class="labelmedium" style="font-size:12px; color:##525252;">#ListCode.ListExplanation#</td></tr>		
		</table>
		
		
		</td>
	</cfif>
	
	<td valign="top" style="width:50%">
	
	<table width="100%">
		
	<cfloop query="TopicList">
	
		<cfquery dbtype="query" name="qValidateListCode">
			SELECT 	*
			FROM 	TopicList
			WHERE	ListCode = '#url.ListCode#'
		</cfquery>
		
		<cfif trim(qValidateListCode.ListExplanation) neq "">
			
			<cfif ListCode eq url.listcode>		
				
				<tr>	
				<td valign="top" class="labelmedium" style="font-size:14px;padding-top:9px;padding:12px; #url.darkStyle#">#ListExplanation#</td>
				</tr>
							
			<cfelse>
			    <tr>	
				<td 
					valign="top" 
					style="font-size:12px; padding-top:6px; padding-left:6px; padding-right:6px; padding-bottom:6px; text-shadow: 0 0 3px ##CCCCCC; #url.lightStyle#" class="labelmedium">
						
						<cfif len(ListExplanation) gt "200">
						#left(ListExplanation,150)#...
						<cfelse>
						#ListExplanation#
						</cfif>
				
				</td>
				</tr>
						
			</cfif>
		<cfelse>
			
			<tr><td></td></tr>
		
		</cfif>
	
	</cfloop>
	
	</table>
	
	</tr>
							
	</table>

	</td></tr>
	
</table>

</cfoutput>
