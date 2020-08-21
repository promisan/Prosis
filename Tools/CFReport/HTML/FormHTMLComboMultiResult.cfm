	
<!--- Query returning search results --->

<cfparam name="URL.Page" default="1">
<cfparam name="URL.adv"  default="1">
<cfparam name="Form.MultiValue" default="">

<input type="hidden" name="page" id="page" value="<cfoutput>#URL.Page#</cfoutput>">

<cfquery name="Base" 
	 datasource="AppsSystem" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT     TOP 1 * 
	 FROM  		Ref_ReportControlCriteria R
	 WHERE  	ControlId     = '#URL.ControlId#' 
	  AND    	CriteriaName  = '#URL.par#'  
</cfquery>

<cfoutput query="Base">
   
	<cfif LookupDataSource eq "">
		<cfset ds = "appsQuery">
	<cfelse>
		<cfset ds = "#LookupDataSource#">
	</cfif> 

	<cfset tmp = "">
								 
        <cfloop index="itm" list="#Form.MultiValue#" delimiters=",">
		 <cfif itm neq "*"> 
   	     <cfif tmp eq "">
    	    <cfset tmp = "'#itm#'">
	     <cfelse>
	        <cfset tmp = "#tmp#,'#itm#'">
	     </cfif>
		 </cfif>
  	     </cfloop>
 
	<cfif tmp eq "">
	   <cfset tmp = "''">
	</cfif>  
		
	<cfif CriteriaType eq "Unit">
	
		<cfquery name="Mandate"
				datasource="appsOrganization" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				SELECT TOP 1 *
			    FROM   Ref_Mandate		
				WHERE  Mission = '#url.fly#' 
				AND    DateEffective  <= getdate()
				ORDER BY DateExpiration DESC			
		</cfquery>			
		
		 <cf_selectOrgUnitBase 
		controlid="#url.controlid#" 
		criteriaName="#url.par#">
		
		<cfparam name="url.val" default="">
				
		<cfset val = replace(url.val,"'","","ALL")> 

		<!--- search --->

		<cfif tmp eq "">  <!--- single --->

			<cfif URL.adv eq "1">
			  <cfset str = "AND (OrgUnitCode LIKE '%#val#%' OR OrgUnitName LIKE '%#val#%')">
			<cfelse>
			  <cfset str = "AND (OrgUnitCode LIKE '#val#%' OR OrgUnitName LIKE '#val#%')">
			</cfif>
	
		<cfelse>

			<cfif URL.adv eq "1">
			  <cfset str = "AND (OrgUnitCode LIKE '%#val#%' OR OrgUnitName LIKE '%#val#%') AND OrgUnit NOT IN (#preserveSingleQuotes(tmp)#)">
			<cfelse>
			  <cfset str = "AND (OrgUnitCode LIKE '#val#%' OR OrgUnitName LIKE '#val#%') AND OrgUnit NOT IN (#preserveSingleQuotes(tmp)#)">
			</cfif>

		</cfif>
				
		<cfset con = str>

		 <cfquery name="total" 
	     datasource="appsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		     SELECT count(*) as Total
			 FROM  Organization Org
			<cfif selectedorg neq "all" and selectedorg neq "" and selectedorg neq "''">
				WHERE  OrgUnit IN (#preservesinglequotes(selectedorg)#)
			 <cfelse>
				WHERE  Mission   = '#Mandate.Mission#' 
		 		AND    MandateNo = '#Mandate.MandateNo#'
			 </cfif>	
			 <cfif LookupUnitParent eq "1">
				AND (ParentOrgUnit = '' or ParentOrgUnit is NULL or Autonomous = 1)
			 </cfif>
			 	
			 #preserveSingleQuotes(con)# 		
			  AND     DateEffective  < getdate()
			 AND      DateExpiration > getDate()		 
		</cfquery>
		
		<cfquery name="checkall" 
	     datasource="appsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		     SELECT count(*) as Total
			 FROM   Organization Org
			 <cfif selectedorg neq "all" and selectedorg neq "">
				WHERE  OrgUnit IN (#preservesinglequotes(selectedorg)#)
			 <cfelse>
			    WHERE  Mission   = '#Mandate.Mission#' 
		 		AND    MandateNo = '#Mandate.MandateNo#'
			 </cfif>	
			  <cfif LookupUnitParent eq "1">
				AND (ParentOrgUnit = '' or ParentOrgUnit is NULL or Autonomous = 1)
			 </cfif>	
			 #preserveSingleQuotes(con)# 
			
		</cfquery>
		
		<cfif CheckAll.total lte "200">
		
			<cfquery name="All" 
		    	datasource="appsOrganization" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
			    SELECT DISTINCT OrgUnit as PK, OrgUnitCode as Code, HierarchyCode as ListingOrder
		    	FROM   Organization Org
			    <cfif selectedorg neq "all" and selectedorg neq "" and selectedorg neq "''">
				 WHERE   OrgUnit IN (#preservesinglequotes(selectedorg)#)
			    <cfelse>
				 WHERE   Mission   = '#Mandate.Mission#' 
		 		 AND     MandateNo = '#Mandate.MandateNo#'
			    </cfif>	
				 <cfif LookupUnitParent eq "1">
				AND (ParentOrgUnit = '' or ParentOrgUnit is NULL or Autonomous = 1)
				 </cfif>		
				#preserveSingleQuotes(con)#  
								
			</cfquery> 
															
			<cfset allv = ValueList(all.pk)> 
					
			<input type="hidden" name="allv" id="allv"  value="#allv#">
		
		</cfif>	
	
	<cfelse>
			
		<cfloop query="Base">		
		   <!---
		   <cfset mode = "edit">   --->
		   <cfinclude template="FormHTMLComboQuery.cfm">
		  
		</cfloop>		
		
		<cfset con = ltrim(con)>		
																												
		<cfquery name="Total" 
		    datasource="#ds#" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    SELECT count(DISTINCT #LookupFieldValue#) as total
			<cfif not Find("FROM ", "#preserveSingleQuotes(con)#") or LEFT(con,5) eq "WHERE">
			FROM #LookupTable#
			</cfif>	
	    	#preserveSingleQuotes(con)# 
		</cfquery> 
		
		<cfquery name="CheckAll" 
		    datasource="#ds#" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    SELECT count(DISTINCT #LookupFieldValue#) as total
	    	<cfif not Find("FROM ", "#preserveSingleQuotes(con)#") or LEFT(con,5) eq "WHERE">
			FROM #LookupTable#
			</cfif>	
	    	#preserveSingleQuotes(con)# 
		</cfquery> 
			
		<cfif CheckAll.total lte "100">
		
			<cfquery name="All" 
		    	datasource="#ds#" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
			    SELECT DISTINCT CONVERT(varchar(1000), #LookupFieldValue#) as PK
		    	<cfif not Find("FROM ", "#preserveSingleQuotes(con)#") or LEFT(con,5) eq "WHERE">
				FROM #LookupTable#
				</cfif>	
	    		#preserveSingleQuotes(con)# 
			</cfquery> 
		
		    <cfset allv = "">
			
		    <cfloop query="all">
			
				<cfif allv eq "">
					<cfset allv = "#pk#">
				<cfelse>
					<cfset allv = "#allv#,#pk#">
				</cfif>
					
			</cfloop>
			
			<input type="hidden" name="allv" id="allv" value="#allv#" size="70">
		
		</cfif>
		
	</cfif>	
	
	<cfset show = "10">
	
	<cfset No = URL.Page*show>
	
	<cfif No gt Total.Total>
		  <cfset No = Total.Total>
	</cfif> 
	
	<cftry>
	
		<cfif CriteriaType eq "Unit">
					
			<cfquery name="SearchResult" 
			    datasource="appsOrganization" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
			    SELECT  OrgUnitCode as Code, 
			            OrgUnit as PK,  
			            OrgUnitName as Display					 	
				 FROM Organization Org
				 <cfif selectedorg neq "all" and selectedorg neq "" and selectedorg neq "''">
				 WHERE  OrgUnit IN (#preservesinglequotes(selectedorg)#)
			     <cfelse>
				 WHERE Mission   = '#Mandate.Mission#' 
		 		 AND   MandateNo = '#Mandate.MandateNo#'
			     </cfif>		
				 <cfif LookupUnitParent eq "1">
				 AND (ParentOrgUnit = '' or ParentOrgUnit is NULL or Autonomous = 1)
			     </cfif>								 	
				 #preserveSingleQuotes(con)# 	
				 ORDER BY HierarchyCode 
			</cfquery> 		
			
		<cfelse>
						
			<cfquery name="SearchResult" 
			    datasource="#ds#" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
			    SELECT  #dis# #LookupFieldValue#, 
			            CONVERT(varchar(1000), #LookupFieldValue#) as PK,  
			            #LookupFieldDisplay# as Display			
			 	<cfif not Find("FROM ", "#preserveSingleQuotes(CriteriaValues)#") or LEFT(con,5) eq "WHERE">
				 FROM #LookupTable#
				 </cfif>	
				 #preserveSingleQuotes(Crit)# 
				 
			</cfquery> 
		
		</cfif>

	 	 <cfcatch>		
		      		 
		 		<cfabort>		 
	     </cfcatch>
	
	</cftry>
		
</cfoutput>

<table width="100%" height="100%" cellspacing="0" cellpadding="0" border="0">

<cfif SearchResult.recordcount eq "0">
						   
	<tr class="line"><td align="center"class="labelmedium" style="color:FF0000;"><cf_tl id="No more records to be selected"></td></tr>
				
<cfelse>

	<tr><td class="labelmedium" colspan="3">
	
		<cfif Total.total lte "100">	   
 	   
	   <cfoutput>
	   
		   <table>
		   <tr>
		   <td><cf_img icon="select" onClick="multivalue('selectall','0','#url.par#','#url.fly#','#URL.Page#')"></td>
		   <td class="labelmedium">
			   <a href="javascript:multivalue('selectall','0','#url.par#','#url.fly#','#URL.Page#')"><cf_tl id="Select all"></a>
		   </td>
		   </tr>
		   </table>
	  
		</cfoutput>   
					
	</cfif>
	
	</td></tr>
	
</cfif>	

<tr><td height="97%" valign="top" style="padding-left:15px;padding-right:14px">

        <cf_divscroll>
    
		<table style="width:99%" class="navigation_table">   
																	
			<TR bgcolor="f4f4f4" class="labelmedium fixrow">
			   	
			    <td height="15" width="8%"></td>
			    <TD><cf_tl id="Code"></TD>				
				<TD><cf_tl id="Display"></TD>
								
			</TR>
							
			<cfset Start = (show)*(URL.Page-1)+1> 
							
			<cfoutput query="SearchResult" startrow="#start#" maxrows="#show#">
		
			<cfif SearchResult.recordcount lt "100">
			
				<TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('f7f7f7'))#" style="border-top:1px solid silver" class="navigation_row labelmedium">
			
			<cfelse>
			
				<TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('f7f7f7'))#" style="border-top:1px solid silver" class="navigation_row labelmedium">
			
			</cfif>
				
			<td style="min-width:30px">			
			  <cf_img icon="open" onClick="multivalue('add','#PK#','#url.par#','#url.fly#','#URL.Page#')" navigation="Yes">						   
			</td>
						
			<cfif base.Lookupfieldshow eq "1">	
			  <TD style="min-width:90px">		 
			  <cfif Base.CriteriaType eq "Unit">#Code#<cfelse>#PK#</cfif>
			  </td>
			</cfif>			
			
			<td style="padding-left:5px;width:70%;padding-right:20px">
			
			  <cfif len(display) gt "65">
			    <a href="##" title="#Display#">#left(Display,65)#...</a>
			  <cfelse>
			    #display#	
			  </cfif>
			  
			</td>			
				
			</TR>
							
			</cfoutput>						
			
		</table>
		
		</cf_divscroll>
					
	</td></tr>
		
	<tr>
	<td align="center" valign="bottom">
		<cfinclude template="FormHTMLComboNavigation.cfm">
	</td>
	</tr>	
	
</table>	

<cfset ajaxonload("doHighlight")>

