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
<cfif SearchResult.recordcount eq "0">

<tr><td colspan="6" align="center" style="padding-top:5px" class="labelmedium"><cf_tl id="There are no records to show in this view"></td></tr>

</cfif>

<cfoutput query="SearchResult" group="Reference">

<cfif Reference neq "">
<tr class="labelmedium">
     <td colspan="6" bgcolor="f4f4f4" style="padding-left:4px">#Reference#</td>
</tr>
</cfif>

<cfoutput>

	<CFIF ProgramAccess EQ "ALL"> 
		 
		<tr bgcolor="white" style="height:23px" class="navigation_row line">
		<td align="center">
		
			<table cellspacing="0" cellpadding="0">
			<tr>
				<td style="padding-top:1px">
				<cf_img icon="edit" onclick="AddActivity('#URL.ProgramCode#','#URL.Period#','#ActivityId#')">			
				</td>
				<td style="padding-left:3px;padding-top:1px">
				<cf_img icon="delete" onclick="DeleteActivity('#URL.ProgramCode#','#URL.Period#','#ActivityID#','#ProgramAccess#')">			
				</td>			
			</tr>
			</table>
		</td>			   
	
	<cfelse>
	
		<tr style="height:20px" class="navigation_row line">
		<td align="center"></td>
	
	</cfif>
	
	<TD colspan="6" style="padding-left:4px">
	
	  <table cellspacing="0" cellpadding="0">
	  <tr class="labelmedium" style="height:23px">
		  <td>#SearchResult.ActivityDescription#</td>	  
		  <td style="padding-left:3px;padding-top:2px"><cf_img icon="add" onclick="AddOutputs('#URL.ProgramCode#','#URL.Period#','#ActivityId#','')" tooltip="Output"></td>
	  </tr>
	  </table>
	    
	 </TD>
	
</TR>

 <cf_filelibraryCheck
			DocumentPath="#Parameter.DocumentLibrary#"
			SubDirectory="#SearchResult.ProgramCode#" 
			Filter="#SearchResult.ActivityId#">
			
<cfif files gte "1">
	
	<tr>
		 <td colspan="1"></td>
		 <td colspan="5">
		 
			 <CFIF ProgramAccess EQ "ALL"> 
			 
				 <cf_filelibraryN
					DocumentPath="#Parameter.DocumentLibrary#"
					SubDirectory="#SearchResult.ProgramCode#" 
					Filter="#SearchResult.ActivityId#"
					Insert="no"
					box="att#SearchResult.ActivityId#"
					Remove="yes"
					Highlight="no"
					Listing="yes">
				
			 <cfelse>
			 
				  <cf_filelibraryN
					DocumentPath="#Parameter.DocumentLibrary#"
					SubDirectory="#SearchResult.ProgramCode#" 
					Filter="#SearchResult.ActivityId#"
					box="att#SearchResult.ActivityId#"
					Insert="no"
					Remove="no"
					Highlight="no"
					Listing="yes">
			 
			 </cfif>	
			
		</td>
	</tr>

</cfif>

<cfset Cond = "">	

<cfif URL.Sorting eq "period">
    <cfset Cond = " AND O.ActivityPeriodSub = '#Sub#'">
</cfif>

<cfquery name="OutputPeriods" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   DISTINCT O.ActivityPeriodSub, S.DescriptionShort
	FROM     ProgramActivityOutput O, Ref_SubPeriod S
	WHERE    O.ActivityId = '#SearchResult.ActivityId#' 
	 AND     O.ProgramCode = '#SearchResult.ProgramCode#'
	 AND     S.SubPeriod = O.ActivityPeriodSub
	         #PreserveSingleQuotes(cond)#
	ORDER BY S.DescriptionShort
</cfquery>

<cfset OutActivityID     = SearchResult.ActivityID>
<cfset OutActivityPeriod = SearchResult.ActivityPeriod>
<cfset OutProgramCode    = SearchResult.ProgramCode>

<cfloop query="OutputPeriods">

	<cfif OutActivityID eq URL.ExpandOutput AND OutputPeriods.ActivityPeriodSub eq URL.ExpandSubPeriod>
	
	<!--- show this activity's output expanded --->
	
		<cfinclude template="../ActivityProgramOutput/OutputProgressEntry.cfm">
	
	<cfelse>
	
	<cfquery name="Output" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   O.*, S.DescriptionShort
		FROM     #CLIENT.LanPrefix#ProgramActivityOutput O, Ref_SubPeriod S
		WHERE    O.ActivityId = '#OutActivityID#' 
		 AND     O.ProgramCode = '#OutProgramCode#' 
		 AND     O.ActivityPeriodSub = '#OutputPeriods.ActivityPeriodSub#'
		 AND     (O.RecordStatus <> 9 OR O.RecordStatus IS NULL)
		 AND      S.SubPeriod = O.ActivityPeriodSub
		ORDER BY S.DescriptionShort
	</cfquery>
	
	<tr class="line">
	
	<td colspan="6">
	
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		
		<cfset period = "">
		
		<cfloop query="Output">
		
			<CFIF ProgramAccess EQ "ALL"> 
		
			<tr class="labelmedium navigation_row" onContextMenu="cmexpand('mymenu','#client.dropdownno#','')" onclick="cmclear('mymenu')">
			
			<cfelse>
			
			<tr class="labelmedium">
			
			</cfif>
			
		    <cfif Period neq ActivityPeriodSub>
		
		     	 <cfset period = ActivityPeriodSub>
				 
				 <TD width="5%" valign="top" align="right" valign="top">&nbsp;</TD>
				 <td width="5%" align="left" valign="top" style="padding-top:2px;padding-left:5px">	
				
				<cfif ProgramAccess eq "EDIT" or ProgramAccess eq "ALL">  <!--- access invoked by ComponentViewHeader --->
				<!--- diabled on Kristina's request
					<a href="javascript:ReloadActivities('#SearchResult.ProgramCode#','#SearchResult.ActivityPeriod#','#ActivityId#','#ActivityPeriodSub#')">
					<img src="#SESSION.root#/Images/zoomin.jpg" alt="" width="10" height="9" border="0"></A>
		        --->			
				</cfif>				
				#DescriptionShort#
				</td>
				 
			<cfelse>	
				<td width="5%" align="right">&nbsp;</td>
		        <td width="5%"></td>
			</cfif>	 
			
			<td width="3%">
			
				<CFIF ProgramAccess EQ "ALL"> 
				
					<table><tr>
					<td style="padding-left:3px;padding-top:3px">
					<cf_img icon="edit" onclick="EditOutput('#URL.ProgramCode#','#URL.Period#','#OutActivityID#','#OutputID#')">
					</td>
					<td style="padding-left:3px;padding-top:2px;padding-right:10px">
					<cf_img icon="delete" onclick="DeleteOutput('#URL.ProgramCode#','#URL.Period#','#OutputID#','#ProgramAccess#')">		
					</td>
					
					</tr></table>
								  	  
			    </cfif> 
			
			</td>
		    	
		    <td width="30%" style="padding-right:4px">#Output.ActivityOutput#</td>
			<td width="10%" style="padding-right:4px" align="left">#DateFormat(ActivityOutputDate, CLIENT.DateFormatShow)#</td>	
			
			<cfquery name="Progress" 
		    datasource="AppsProgram" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			    SELECT   *
			    FROM     ProgramActivityProgress A, Ref_Status S 
			    WHERE    A.OutputId = '#Output.OutputId#' 
			    AND      A.ProgramCode = '#Output.ProgramCode#' 
			    AND      A.ProgressStatus = S.Status 
				AND	     (A.RecordStatus <> 9 OR A.RecordStatus is NULL)
			    AND      S.ClassStatus = 'Progress'
				ORDER BY Created
		    </cfquery>
			
			<cfif Progress.recordcount gt "0">
			
		    	<td width="56%" valign="top" bgcolor="ffffcf">
			
			<cfelse>
			
		    	<td width="56%" valign="top">
			
			</cfif>
		   				
				<table width="96%" border="0" cellspacing="0" cellpadding="0" align="center">
				
				  <cfloop query="Progress">
				  
					  <cfif ProgressStatus neq 0>	
					   <tr class="labelit">
					    
						<td width="40%" align="left" valign="top" style="padding-right:10px">
						     <cfif ProgressStatus eq 0>
							     <img src="#SESSION.root#/Images/arrow.gif" alt="" border="0" align="bottom"></A>
							 <cfelseif ProgressStatus eq 1>
								 <img src="#SESSION.root#/Images/check.gif" alt="" border="0" align="bottom"></A>
							 <cfelseif ProgressStatus eq 2>
								 <img src="#SESSION.root#/Images/pending.gif" alt="" border="0" align="bottom"></A>
							 <cfelse>
								 <img src="#SESSION.root#/Images/pending.gif" alt="" border="0" align="bottom"></A>
							 </cfif>&nbsp;#Description#	(#DateFormat(ProgressStatusDate, CLIENT.DateFormatShow)#)			 
						    </td>
						<td width="40%" align="left" valign="top" class="regular">#OfficerFirstName# #OfficerLastName# (#DateFormat(Created, CLIENT.DateFormatShow)#)</td>
						<TD width="5%" valign="top" style="padding-right:10px">
							<cfif ProgramAccess eq "ALL">
								<a  href="javascript:DeleteProgress('#URL.ProgramCode#','#URL.Period#','#ProgressID#')">
								<img src="#SESSION.root#/Images/cancelN.jpg" alt="" border="0" align="middle">
								</a>
							</cfif>
						</td>
						</tr>
						<tr class="labelit">
						<td colspan="4" valign="top" class="regular"><A HREF ="javascript:EditProgress('#Progress.ProgramCode#','#Progress.ProgressId#')">#Progress.ProgressMemo#&nbsp;</a></td>
						</tr>		
						</cfif>
						
				   </cfloop>
				     
				  </table>	
				  
			</td></tr>	  
		   
		</cfloop> 
		
		</td></tr>
		</table>
	
	</td>
	</tr>
	
	</cfif>

</cfloop>

</cfoutput>

</cfoutput>