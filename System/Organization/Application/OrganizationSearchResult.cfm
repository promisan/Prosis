
<CFSET Criteria = ''>

<cfif Criteria is ''>
   <CFSET Criteria = "O.Mission = '#URL.Mis#'">
<cfelse>
   <CFSET Criteria = "#Criteria# AND O.Mission = '#URL.Mis#'">
</cfif>

<cfoutput>

	<cfparam name="URL.Mandate" default="">
	
	<cfif URL.Mandate eq "">
	
	    <cfquery name="SearchResult" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT MandateNo 
	     FROM Ref_Mandate
	     WHERE Mission = '#URL.Mis#'
		 ORDER BY MandateDefault DESC
	    </cfquery>
		
		<cfset URL.Mandate = #SearchResult.MandateNo#>
	
	</cfif>
	
	<CFSET Criteria = #Criteria#&" AND O.MandateNo = '#URL.Mandate#'" >
	    
	<cfparam name="URL.cls" default="all">
	
	<cfif URL.cls neq 'all'> 	
	     <cfif #Criteria# is ''>
		 <CFSET Criteria = "O.OrgUnitClass IN (#PreserveSingleQuotes(URL.cls)# )">
		 <cfelse>
		 <CFSET Criteria = #Criteria#&" AND O.OrgUnitClass IN ( #PreserveSingleQuotes(URL.cls)# )" >
	     </cfif>
	</cfif> 
	
	<cfif url.uni neq ''> 	
	     <cfif #Criteria# is ''>
		 <CFSET #Criteria# = "O.OrgUnitName LIKE '%#PreserveSingleQuotes(URL.uni)#%'">
		 <cfelse>
		 <CFSET #Criteria# = #Criteria#&" AND O.OrgUnitName LIKE '%#PreserveSingleQuotes(URL.uni)#%'">
	     </cfif>
	</cfif> 

</cfoutput>

<table width="100%">
   
<tr><td colspan="2" valign="top">

<table width="100%" height="100%" align="center">

<tr><td style="padding-left:5px;padding-bottom:4px">

<table width="98%" class="navigation_table">

<cfif URL.UNI eq ''> 

	<!--- Query returning search results --->
			
	<cfquery name="SearchResult" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT TOP 1000 *, '1' as Enabled 
	    FROM #CLIENT.LanPrefix#Organization O
	    WHERE #PreserveSingleQuotes(Criteria)#
		ORDER BY O.HierarchyCode 
	</cfquery>		
								
	<cfoutput query="SearchResult">
		
	    <cfset name = replaceNoCase(OrgUnitName,"'","","ALL")>
		<cfset code = replaceNoCase(OrgUnitCode,"'","","ALL")>

	   <cfif ParentOrgUnit eq "">		  
  		  		    
		<tr bgcolor="FFFFAF"
		    id="#orgunit#" style="cursor: pointer;" class="navigation_row line labelmedium2">
			
			<td width="25" style="padding-top:1px;padding-left:4px">
			
		     <cfif enabled eq "1">
			 
			 	 <cfif url.mode eq "cfwindow">
				     <cf_img icon="select" navigation="Yes" onClick="setvalue('#url.field#','#OrgUnit#')">
				 <cfelse>				 
			         <cf_img icon="open" navigation="Yes" onClick="selected('#OrgUnit#','#Code#','#Mission#','#Name#','#OrgUnitClass#')">
				 </cfif>	 
			 				
		     </cfif> 
			 
		  </td>
		 			  
		  <td style="width:50px;padding-left:7px;padding-right:4px">#OrgUnitCode#</td>
		  <td width="16%" style="padding-left:7px;padding-right:4px"><cfif len(OrgUnitNameShort) lte 10>#OrgUnitNameShort#</cfif></td>			   
		  <td width="70%"><cfif enabled eq "0"><font color="gray"></cfif>#OrgUnitName#</TD>			  
		  <td width="15%" style="padding-left:4px;padding-right:4px">
			  <cfif enabled eq "0"><font color="gray"></cfif>#HierarchyCode#</b>
		  </td>
	
	  </TR>
	   
	   <cfelse>
	   
		<tr bgcolor="FFFFFF" id="#orgunit#" style="cursor: pointer;height:20px" class="navigation_row line labelmedium2">

		<td width="25" style="padding-top:3px;padding-left:4px">
		
	     <cfif enabled eq "1">
		 
		  <cfif url.mode eq "cfwindow">
		      <cf_img icon="select" navigation="Yes" onClick="setvalue('#url.field#','#OrgUnit#')">
		  <cfelse>
	    	  <cf_img icon="open"   navigation="Yes" onClick="selected('#OrgUnit#','#Code#','#Mission#','#Name#','#OrgUnitClass#')">
		  </cfif>	  
	      
		 </cfif> 
	   
	   </td>
	  
	   <td style="width:50px;padding-left:7px;padding-right:4px">#OrgUnitCode#</td>
		
	   <cfset nm = replace(OrgUnitName, "'","","ALL")> 
		
	   <td><cfif len(OrgUnitNameShort) lte 10>#OrgUnitNameShort#</cfif></td>
					
	   <TD width="60%"><cfif enabled eq "0"><font color="gray"></cfif>#OrgUnitName#</TD>
		
	   <td width="15%" style="padding-left:4px;padding-right:4px">
		   <cfif enabled eq "0"><font color="gray"></cfif>#HierarchyCode#
	   </td>
		
	   <!--- <TD width="20%" class="regular"><b>#OrgUnitClass#</b></TD> --->
	   <!--- <TD width="10%" class="regular"><b>#DateFormat(DateExpiration, CLIENT.DateFormatShow)#</b>&nbsp;&nbsp;</TD> --->
	   
	   </TR>
	  
	   </cfif>
	    
	</CFOUTPUT>
		
<cfelse>

	<!--- Query returning search results --->
	<cfquery name="SearchResult" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   * 
	    FROM     #CLIENT.LanPrefix#Organization O
	    WHERE    #PreserveSingleQuotes(Criteria)#
		ORDER BY Mission, MandateNo, TreeOrder
	</cfquery>
	
	<cfif SearchResult.recordcount eq "0">
	<tr class="labelmedium2"><td colspan="4" align="center"><font color="FF0000"><b>No records found</b></td></tr>		
	</cfif>
	
	<cfoutput query="SearchResult" group="Mission">
	
		<cfoutput group="MandateNo">
		
			<tr class="labelmedium2 line">
			     <td colspan="4">#Mission# #MandateNo#</td>
			</tr>
			
			<cfoutput group="TreeOrder">
			
				<cfoutput>
				
					<cfset nm = replace(OrgUnitName, "'","","ALL")> 
					<cfset cd = replaceNoCase(OrgUnitCode,"'","","ALL")>
				
					<tr style="cursor:pointer" class="navigation_row labelmedium2 line" style="height:20px">
					
					   <td width="8%" align="center" style="padding-left:4px">			     
						 
						 <cfif url.mode eq "cfwindow">
						     <cf_img icon="select" navigation="Yes" onClick="setvalue('#url.field#','#OrgUnit#')">
						 <cfelse>
							 <cf_img icon="select" navigation="Yes" onClick="selected('#OrgUnit#','#Cd#','#Mission#','#Nm#','#OrgUnitClass#')">
						 </cfif>	 
					    				   
					   </td>
					   
					   <td width="20%" style="padding-left:4px;padding-right:4px">#OrgUnitCode#</td>
					   
					   <cfif url.uni neq "">
							<cfset unit = ReplaceNoCase(OrgUnitName, url.uni, "<b><u><font color='0066CC'>#url.uni#</font></u></b>")>
					   <cfelse>
							<cfset unit = "#OrgUnitName#">
					   </cfif>
					   
					   <td width="60%">#unit#</TD>
					   <td width="15%">#OrgUnitClass#</TD>
						 				
					</tr>
										
				</cfoutput>
						
			</cfoutput>
	
		</cfoutput>
	
	</cfoutput>

</cfif>		
		
</TABLE>

<!---
</div>
--->

</tr></td>
</table>

</td>
</tr>

</table>

<cfset AjaxOnLoad("doHighlight")>	

