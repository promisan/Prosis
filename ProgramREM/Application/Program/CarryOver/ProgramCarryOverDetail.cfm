
<cfoutput>

<cfset programlist = "#programlist#,#programcode#">

<TR class="labelmedium line navigation_row">
	
	<td height="23"></td>
	<td  width="10%" style="padding-left:20px"><cfif Reference neq "">#Reference#<cfelse>#ProgramCode#</cfif></td>
	<td colspan="4" style="background-color:ffffaf;padding-left:5px">#ProgramName#</b></td>
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
			   <img src="#SESSION.root#/Images/check.png" height="12" width="15" alt="" border="0" align="bottom">
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
  
     
	   <tr class="line navigation_row labelmedium">
		    <td height="21"></td>
			<td width="10%"></td>
		    <td bgcolor="ffffaf" colspan="3" style="padding-left:25px" class="labelit">#Components.ProgramName#</A></td>
			<TD bgcolor="ffffaf"><cfif Reference neq "">#Components.Reference# (#Components.ProgramCode#)<cfelse>#Components.ProgramCode#</cfif></TD>
			<td bgcolor="ffffaf" align="center" style="padding-right:5px">
			
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
		
		   <tr class="line navigation_row labelmedium">
		   
		   	   <td></td>
			   <td width="5%"></td>
			   <td bgcolor="ffffdf" colspan="3" style="padding-left:35px" class="labelit">#SubComponents.ProgramName#</td>
			   <TD bgcolor="ffffdf" colspan="1" class="labelit"><cfif Reference neq "">#SubComponents.Reference#<cfelse>#SubComponents.ProgramCode#</cfif></TD>
			   <td bgcolor="ffffdf" colspan="1" align="center">
				
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


