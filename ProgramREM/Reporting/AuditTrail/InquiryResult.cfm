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

<cf_screentop height="100%" scroll="yes" html="No">

<cfparam name="URL.User" default="All">
<cfparam name="URL.Criteria" default="">

<cfif URL.Criteria eq "">

    <cfparam name="URL.ProgramGroup" default="#FORM.ProgramGroup#">

	<CFSET Criteria = ''>
		
	<cfparam name="Form.ProgramGroup" default="All">
	<cfparam name="Form.ProgramStatus" default="Operational">
		
	<cfif #Form.ProgramGroup# IS NOT 'All'>
	     <CFSET #Criteria# = #Criteria#&" AND Cl.ProgramGroup = '#Form.ProgramGroup#'">
	</cfif> 
	
	<cfif Form.ProgramStatus IS NOT ''>
	     <CFSET #Criteria# = #Criteria#&" AND P.ProgramStatus = '#Form.ProgramStatus#'">
	</cfif> 
	
	<cfif #Form.Start# IS NOT ''>
	     <cfset dateValue = "">
         <CF_DateConvert Value="#Form.Start#">
         <cfset DTE = #dateValue#>
	     <CFSET #Criteria# = #Criteria#&" AND Audit.Created >= #DTE# ">
	</cfif> 
				
	<cfif #Form.End# IS NOT ''>
	      <cfset dateValue = "">
         <CF_DateConvert Value="#Form.End#">
         <cfset DTE = #dateValue#>
	     <CFSET #Criteria# = #Criteria#&" AND Audit.Created <= #DTE# ">
	</cfif> 
		
	<cfset #URL.Criteria# = #Criteria#>
	
</cfif>	

<cfoutput>

	<script>
	
	function reloadForm(page,tmp, user)
	
	{
	        window.location="InquiryResult.cfm?ProgramGroup=#URL.ProgramGroup#&Criteria=#URL.Criteria#&Page=" + page + "&User=" + user;
	}
	
	</script>	

</cfoutput>

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfparam name="CLIENT.Sort" default="OrgUnit">
<cfparam name="URL.Sort" default="ListingOrder">
<cfparam name="URL.View" default="All">
<cfparam name="URL.Lay" default="Components">
<cfparam name="URL.page" default="1">

<!--- define program component status --->
   
<cfoutput>


    <cfquery name="Parameter" 
         datasource="AppsProgram" 
         username="#SESSION.login#" 
         password="#SESSION.dbpw#">
		 SELECT *
		 FROM Parameter
	</cfquery>	
	   
	<cfquery name="RawListing" 
         datasource="AppsSystem" 
         username="#SESSION.login#" 
         password="#SESSION.dbpw#">
		 SELECT     Audit.*, 
		            T.AuditListingOrder, 
					T.AuditFieldName, 
		            P.ProgramName as ProgramName, 
					P.ProgramClass, 
					A.LastName, 
					A.FirstName
           FROM     AuditLog Audit, 
		            AuditTopic T, 
					Program.dbo.Program P, 					
					UserNames A
		   WHERE    Audit.Reference1 = P.ProgramCode
		    AND     Audit.Topic = T.Topic 
			AND     T.AuditArea = 'Program'
		    AND     A.Account   = Audit.OfficerUserId			
		   <cfif URL.ProgramGroup neq "All"> 
		  
		    AND     P.ProgramCode IN (SELECT ProgramCode 
			                          FROM   Program.dbo.ProgramGroup 
									  WHERE  ProgramGroup = '#URL.ProgramGroup#')
		   </cfif>
		    #preserveSingleQuotes(Criteria)#
		   ORDER BY  Audit.Reference1, T.AuditListingOrder
        </cfquery>	
		
		
		<cfquery name="User" dbtype="query">
			SELECT DISTINCT FirstName, LastName, OfficerUserId
			FROM RawListing
		</cfquery>
		
		<cfquery name="SearchResult" dbtype="query">
			SELECT *
			FROM RawListing
			<cfif #URL.User# neq "All">
			  WHERE  OfficerUserId = '#URL.User#'
			</cfif>
		</cfquery>
			       
</cfoutput>

<cf_dialogREMProgram> 

<HTML><HEAD>
    <TITLE>Search - Search Result</TITLE>

</HEAD><body onLoad="javascript:document.forms.result.page.focus(); window.focus()" class="dialog">
		
<table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="#002350" style="border-collapse: collapse;">
	  <tr>
		    <td height="30">&nbsp;<b>
				<a href="InquiryForm.cfm"><font color="0080FF">Return</a>				
			</td>
				
			<td align="right">	
			
			   <select name="user" size="1" 
			onChange="javascript:reloadForm(page.value,'',this.value)">
			<option value="All" selected>All
			 <cfoutput query="User">
		       <option value="#OfficerUserId#" <cfif #URL.user# eq "#OfficerUserId#">selected</cfif>>#FirstName# #LastName#
		 	</cfoutput>
			</select>
					
			<!--- drop down to select only a number of record per page using a tag in tools --->	
           <cfinclude template="../../../Tools/PageCount.cfm">
           <select name="page" size="1" 
           onChange="javascript:reloadForm(this.value,'',user.value)">
		   <cfloop index="Item" from="1" to="#pages#" step="1">
              <cfoutput><option value="#Item#"<cfif #URL.page# eq "#Item#">selected</cfif>>Page #Item# of #pages#</option></cfoutput>
           </cfloop>	 
           </SELECT> &nbsp;  	
				
		    </TD>
			
		  </tr>
		  
		</table>
		
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="000000">
				
		<cfoutput query="SearchResult" group="Reference1" startrow="#first#" maxrows="#No#">
		
		<tr bgcolor="CBE2FA">
		  <td width="60" height="24" class="top3n"><b>&nbsp;
		  <a href="javascript:ViewProgram('#Reference1#','','#ProgramClass#')">
		  #Reference1#
		  </a>&nbsp;&nbsp;</td>
		  <td colspan="5" class="top3n"><b>#ProgramName#</td>
		  </tr>
		  
		<cfoutput group="AuditListingOrder">  
		
		<tr>
		   <td height="16" colspan="6" class="top3n"><b>&nbsp;#AuditFieldName#&nbsp;&nbsp;</td>
		</tr>
		
		<tr><td height="4"></td></tr>
		
		<cfoutput>
		
		<tr>
		<td align="center" class="regular">&nbsp;</td>
		<td class="regular"><img src="#SESSION.root#/images/point.jpg" alt="" border="0">&nbsp;&nbsp;<b><font color="008000">#UCase(LogAction)#</b></td>
		<td class="regular">#LastName#, #FirstName# [#OfficerUserId#]</td>
		<td class="regular">#DateFormat(Created, CLIENT.DateFormatShow)# #TimeFormat(Created, "HH:MM")#</td>
		<td class="regular"><b>#Reference2#</td>
		<td align="right" class="regular"><b>#LanguageCode#&nbsp;</td>
		</tr>
		
		<tr>
		    <td height="1" colspan="6"></td>
		</tr>
			
		<cfif #LogAction# neq "Insert">				
		<tr>
		<td colspan="3" class="regular"></td>
		<td colspan="3" class="regular">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<td width="10%" bgcolor="FFFFCF" class="regular">&nbsp;<b>Was:</b></td>
			<td width="90%" class="regular" bgcolor="FFFFCF">#FieldValueOLD#</td>
			<td class="regular">&nbsp;</td>
		</table>
		</td>
		</tr>
		</cfif>
		
		<tr>
		<td colspan="3" class="regular"></td>
		<td colspan="3" class="regular">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<td width="10%" bgcolor="FFFF7F" class="regular">&nbsp;<b>Now:</b></td>
			<td width="90%" class="regular" bgcolor="FFFF7F">#FieldValueNEW#</td>
			<td class="regular">&nbsp;</td>
		</table>
		</td>
		</tr>
				
		<tr>
		   <td></td>
		   <td height="1" colspan="6" bgcolor="C0C0C0"></td>
		</tr>
		
		<tr>
		   <td height="4" colspan="6"></td>
		</tr>
		
		</cfoutput>
		
		</cfoutput>
							
		</cfoutput>
								
</table>
		
