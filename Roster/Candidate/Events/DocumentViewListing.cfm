
<cfparam name="URL.page" default="1">
<cfset currrow = 0>

	<cfquery name="SearchResult" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    userQuery.dbo.#SESSION.acc#Event
	</cfquery>

<cfset counted = Searchresult.recordcount>
	
<!--- Query returning search results --->
		
<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">

<tr>
<td colspan="7" height="23" style="font-size:25px;padding-left:20px" class="labellarge">Matching records</td>
<td colspan="4" align="right" bgcolor="white">

    <cf_PageCountN count="#counted#">
	<cfif pages gte "2">
         <select name="page" size="1" style="background: #e4e4e4; color: black;"
          onChange="javascript:reloadForm(this.value)">
		  <cfloop index="Item" from="1" to="#pages#" step="1">
             <cfoutput><option value="#Item#"<cfif #URL.page# eq "#Item#">selected</cfif>>Page #Item# of #pages#</option></cfoutput>
          </cfloop>	 
         </SELECT>
	</cfif>	 
		 
</td>

<tr><td style="padding-left:20px" height="14" colspan="12" class="regular">
						 
	 <cfinclude template="Navigation.cfm">
	 				 
</td></tr>

<tr><td colspan="14">

<table width="95%" align="center" class="navigation_table">

<TR class="labelmedium line">
    <TD></TD>
    <TD>Last name</TD>
	<TD>Middle name</TD>
    <TD>First name</TD>
    <TD align="center">Nat.</TD>
    <TD align="center">S</TD>
    <TD align="center">Birth date</TD>
    <TD align="center">IndexNo</TD>
	<TD align="center">Owner</TD>
    <TD align="center">Proposed label</TD>
    <TD align="center">Event</TD>
	<td width="25"></td>
 </TR>
 
<cfoutput query="SearchResult" group="Status">

<tr bgcolor="FCFED3"><td colspan="12">&nbsp;<b>

<cfquery name="Status" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_EntityStatus
	WHERE   EntityCode = 'EntCandidate'
	AND     EntityStatus = '#Status#'
	</cfquery>

#Status.StatusDescription#</td></tr>

<cfset prior = "">

<cfoutput>

	<cfset currrow = currrow + 1>
							
		<cfif currrow gte first and currrow lte last>
					
			<tr class="line navigation_row">
			    <TD width="5%" height="20" align="center">
				
				<cf_img icon="select" onClick="documentedit('#EventId#')">
								
			  </td>
			  <TD><a href="javascript:ShowCandidate('#PersonNo#')"><font color="0080FF"><cfif prior neq personNo>#LastName#</cfif></a></TD>
			  <TD><cfif prior neq personNo>#MiddleName#</cfif></TD>
			  <TD><cfif prior neq personNo>#FirstName#</cfif></TD>
			  <TD align="center"><cfif prior neq personNo>#Nationality#</cfif></TD>
			  <TD align="center"><cfif prior neq personNo>#Gender#</cfif></TD>
			  <td align="center"><cfif prior neq personNo>#DateFormat(DOB, CLIENT.DateFormatShow)#</cfif></td>
			  <TD align="center"><cfif prior neq personNo>#IndexNo#</cfif></TD>
			  <TD align="center">#Owner#</TD>
  			  <TD align="center" bgcolor="#InterfaceColor#">#Description#</TD>
			  <td align="center">#DateFormat(EventDate, CLIENT.DateFormatShow)#</td>
			  <td>
				<cfif eMailAddress is not ''>
					<a href="javascript:email('#eMailAddress#','','','','Applicant','#PersonNo#')">
					<img src="#SESSION.root#/Images/mail.gif" alt="send eMail" border="0"></A>
				</cfif>
			  </td>
			 </TR>
			<!---
			<tr class="hide" id="d#currrow#">
			<td colspan="12">
				<table width="100%" border="0">
					<iframe name="id#currrow#" id="id#currrow#" width="100%" height="0" marginwidth="0" marginheight="0" hspace="0" vspace="0" scrolling="no" frameborder="0" style="scrollbar-face-color: Gray;"></iframe>
				</table> 
			</td>
	        </tr>
			--->		
	  </cfif>	
	  
	  <cfset prior = PersonNo>
	  
	 
	  <!---	   	 
	  			
	  <cfif currrow gt last>
	 		 <tr><td height="14" colspan="12" class="regular">
		        	 <cfinclude template="Navigation.cfm">
		     </td></tr>
			 <cfabort>
	  </cfif>	
	  
	  --->
	
	</cfoutput>   
      
</cfoutput>   

</table>
</td>
</tr>

<tr class="line"><td height="1" colspan="12"></td></tr>

<tr>
	<td style="padding-left:20px"  height="14" colspan="12" class="regular">
	<cfinclude template="Navigation.cfm">
    </td>
</tr>

</TABLE>			 

<cfset ajaxonload("doHighlight")>

