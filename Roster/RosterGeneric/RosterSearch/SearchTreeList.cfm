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

<cfif url.val eq "">
   <cfabort>
</cfif>

<cfquery name="List" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	  SELECT   R.*, 
	           D.FunctionalTitle, 
			   D.DocumentNo
	  FROM     RosterSearch R LEFT OUTER JOIN
	           Vacancy.dbo.Document D ON R.SearchCategoryId = STR(D.DocumentNo) 
	  WHERE    (R.Description LIKE '%#url.val#%' or 
	            R.SearchCategoryId  LIKE '%#url.val#%' or 
				R.SearchCategoryId IN 
				                      (
				                       SELECT  STR(DocumentNo)
				                       FROM    Vacancy.dbo.Document 
									   WHERE   D.FunctionalTitle LIKE '%#url.val#%'
									  )
				)
	  AND      R.OfficerUserId = '#SESSION.acc#' 
	  AND      R.Searchid IN (SELECT SearchId 
	                          FROM   RosterSearchResult
							  WHERE  SearchId = R.SearchId)
	  ORDER BY R.Created DESC
</cfquery>

<cfif url.docNo neq "">
	 <cfset tg = "main">
<cfelse>
	 <cfset tg = "main"> 
</cfif>

	<cfset prior = "">
			
			<table width="100%" cellspacing="0" cellpadding="0" class="navigation_table">
						
			<cfoutput query="List">
			
			<cfif Dateformat(created,CLIENT.DateFormatShow) neq prior>
			<cfset prior = Dateformat(created,CLIENT.DateFormatShow)> 
			<tr><td colspan="2" class="labelmedium">#Dateformat(created,CLIENT.DateFormatShow)#</td></tr>
			</cfif>
			
			<tr class="linedotted navigation_row">
			<cfif FunctionalTitle neq "">
				
					<td class="labelit" style="padding-left:16px">							
						  #Dateformat(created,"HH:MM")# <a href="ResultView.cfm?mode=#url.mode#&docno=#url.docno#&ID=#SearchId#" target="#tg#"><font color="0080CO">#left(FunctionalTitle,20)#.. </a></font> 
					</td>
					<td align="right" class="labelit" style="padding-right:15px">
						<a href="javascript:showdocument('#documentno#')"><font color="0080C0">#DocumentNo#</font></a>
					</td>
					
			<cfelse>
				<td style="width:60px;padding-left:10px" class="labelit">#Dateformat(created,"HH:MM")#</td>
				<td class="labelit"><a href="ResultView.cfm?mode=#url.mode#&docno=#url.docno#&ID=#SearchId#" target="#tg#"><font color="0080FF">#Description#</a></td>
			</cfif>			
			</tr>
			
			</cfoutput>
			
			</table>
			

<cfset ajaxonload("doHighlight")>