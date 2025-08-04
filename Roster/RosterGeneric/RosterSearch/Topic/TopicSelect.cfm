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

<cfquery name="Search" 
   datasource="AppsSelection" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
		SELECT   *
		FROM     RosterSearch
		WHERE    SearchId = '#URL.ID#' 	
</cfquery>	
	
<cf_divscroll>

	<table width="100%" height="100%">
	
	<tr><td bgcolor="white" valign="top" style="padding:10px">	
	
		<cfform action="Topic/TopicSelectSubmit.cfm?owner=#url.owner#&id=#url.id#" method="post">
	
			<table width="98%" align="center" cellspacing="0" cellpadding="0">
						
			<tr><td height="4"></td></tr>
			
			<cfquery name="Master" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			 	  SELECT   R.*, A.SelectParameter as Selected
				  FROM     Ref_Topic R LEFT OUTER JOIN
			               RosterSearchLine A ON A.SearchId = '#URL.ID#' and A.SearchClass = 'Assessment' AND A.SelectId = R.Topic
				  WHERE    R.Operational = 1				  
				  AND      ValueClass = 'List'
				  <!---
				  AND      R.Parent   = 'Miscellaneous'
				  --->
				  AND      R.Topic IN (SELECT Topic 
				                       FROM Ref_TopicOwner 
									   WHERE Owner = '#url.owner#' AND Operational = 1)	  	 
				  ORDER BY R.ListingOrder 
			</cfquery>		
			
			<cfif Master.recordcount eq "0">
			
			<tr><td align="center" class="labelmedium" height="30"><font color="808080">No topics defined</td></tr>
			
			</cfif>
							
			<tr><td>
								
			       <table width="100%" border="0" cellspacing="0" cellpadding="0" class="navigation_table">
				   	    		
					<cfoutput query="Master">
									
						<tr class="navigation_row">
						
						  <td align="left" height="20" style="width:50%;padding-left:4px" class="labelmedium">#Description#</td>										
				    	  <td width="50%" align="right">
							
							   <cf_TopicEntry 
								   Mode="labelit"
								   SearchId="#url.id#"
								   Topic="#Topic#">
							
						  </td>
						  
						</tr>
						
					</cfoutput>	
										
					</table>
					
				</td>
			</tr>								
			<tr><td class="linedotted"></td></tr>
			<tr><td height="40" align="center">
				<INPUT class="button10g" type="submit" value="Save">
				</td>
			</tr>	
				
			</table>
	
		</cfform>
	
	</td></tr>
	
	</table>
	
</cf_divscroll>
	
<cfset ajaxonload("doHighlight")>
<cf_screenbottom layout="webapp">

