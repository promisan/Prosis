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

<cfoutput>

<cfset programlist = "#programlist#,#programcode#">

<TR class="labelmedium2 line navigation_row">
	
	<td height="23"></td>
	<td width="10%" style="padding-left:20px"><cfif Reference neq "">#Reference#<cfelse>#ProgramCode#</cfif></td>
	<cfif ProgramScope eq "Global" or ProgramScope eq "Parent">
	<td colspan="4" style="background-color:##80FF8080;padding-left:5px">#ProgramName#</td>
	<cfelse>
	<td colspan="4" style="background-color:##ffffaf80;padding-left:5px">#ProgramName#</td>
	</cfif>
	<td></td>
	<td align="center">
	
		 <cfif Exist eq "0" and ProgramScope neq "Global" and ProgramScope neq "Parent">		 
		 
		     <table>
			 <tr>
			 <td><input type="checkbox" class="radiol" name="selected" value="#ProgramCode#"></td>
			 <td><!--- this always a program level---></td>
			 </tr>
			 </table>
		     
		 <cfelse>		  
			   <img src="#SESSION.root#/Images/check.png" height="15" width="15" alt="Selected by default" border="0" align="bottom">
		 </cfif>
	</td>
	
</TR>

<cfquery name="Components" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT   P.ProgramCode, 
	         P.ProgramName, 
			 P.ProgramClass,
			 P.Reference, 
			 P.Exist
    FROM     tmp#SESSION.acc#Program P
	WHERE    P.ParentCode = '#ProgramCode#'
	<!--- added 20/9/08 to be more rigid --->
	AND      P.OrgUnit   = '#SearchResult.OrgUnit#'
	ORDER BY ListingOrder
	</cfquery>
		
  <cfloop query="Components">  
     
	   <tr class="line navigation_row labelmedium2">
		    <td height="21"></td>
			<td style="min-width:180px"></td>
		    <td style="background-color:##ffffaf80;padding-left:25px" colspan="3">#Components.ProgramName#</A></td>
			<TD style="min-width:150px;background-color:##ffffaf80" ><cfif Reference neq "">#Components.Reference# (#Components.ProgramCode#)<cfelse>#Components.ProgramCode#</cfif></TD>
			<td style="background-color:##ffffaf80"  align="center" style="padding-right:5px">
			
				<cfoutput>
				
				     <cfif Exist eq "0">
					 	
				     <table>
					 <tr>
					 <td>
				       <input type="checkbox" class="radiol" name="selected" value="#Components.ProgramCode#">
					 </td>
					 <td>
					 
					 <cfif GlobalNew.recordcount neq "0">
					 
						 <cfif Components.ProgramClass neq "Program">
						 
						 <select class="regularxl" name="selected_#Components.ProgramCode#" style="border:0px;border-left:1px solid silver;border-right:1px solid silver">
						    <option value=""><cf_tl id="As before"></option>
						 	<cfloop query="GlobalNew">
							   <option value="#ProgramCode#">#Reference#</option>
							</cfloop>
						 </select>					 
						 
						 </cfif>
					 
					 </cfif>
					 
					 </td>
					 </table>
					   
					 <cfelse>
					   <img src="#SESSION.root#/Images/check.png" height="12" width="15" alt="" border="0" align="bottom"></A>
				     </cfif>
				 
				</cfoutput>
			 
		    </td>
			<td></td>		
			
		</tr>
		
		<cfset programlist = "#programlist#,#Components.ProgramCode#">
					
		<cfquery name="SubComponents" 
			datasource="AppsQuery" 
			username="#SESSION.login#" 
	        password="#SESSION.dbpw#">
			SELECT    P.ProgramCode, 
			          P.ProgramName, 
					  P.Reference, 
					  P.Exist
	  		FROM      tmp#SESSION.acc#Program P
			WHERE     P.ParentCode = '#Components.ProgramCode#'
			<!---
			AND     P.OrgUnit = '#SearchResult.OrgUnit#'
			--->
			ORDER BY  ListingOrder
		</cfquery>
				
		<cfloop query="SubComponents">
		
		   <tr class="line navigation_row labelmedium2">
		   
		   	   <td></td>
			   <td width="5%"></td>
			   <td style="background-color:##ffffdf80;padding-left:35px" colspan="3">#SubComponents.ProgramName#</td>
			   <TD style="background-color:##ffffdf80"  colspan="1"><cfif Reference neq "">#SubComponents.Reference#<cfelse>#SubComponents.ProgramCode#</cfif></TD>
			   <td style="background-color:##ffffdf80"  colspan="1" align="center">
				
			        <cfoutput>
				
					     <cfif Exist eq "0">
					       <input type="checkbox" class="radiol" name="selected" value="#SubComponents.ProgramCode#">
						 <cfelse>
						   <img src="#SESSION.root#/Images/check.png" height="12" width="15" alt="" border="0" align="bottom"></A>
					     </cfif>
				 
			       	</cfoutput>		
		       
		        </td>	
				<td></td>
					
			</tr>			
			
			<cfset programlist = "#programlist#,#SubComponents.ProgramCode#">
			
	        <cfinclude template="ProgramCarryOverSubDetail.cfm"> 
				
	    </cfloop>  	
     
  </cfloop> 
  
</cfoutput>   


