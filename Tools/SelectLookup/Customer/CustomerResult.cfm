
<cfparam name="criteria" default="">

<cfif Form.Crit1_Value neq "">

	<CF_Search_AppendCriteria
	    FieldName="#Form.Crit1_FieldName#"
	    FieldType="#Form.Crit1_FieldType#"
	    Operator="#Form.Crit1_Operator#"
	    Value="#Form.Crit1_Value#">
	
</cfif>	
	
<cfif Form.Crit2_Value neq "">	
	
	<CF_Search_AppendCriteria
	    FieldName="#Form.Crit2_FieldName#"
	    FieldType="#Form.Crit2_FieldType#"
	    Operator="#Form.Crit2_Operator#"
	    Value="#Form.Crit2_Value#">

</cfif>


<cfif Form.Crit3_Value neq "">

	<CF_Search_AppendCriteria
	    FieldName="#Form.Crit3_FieldName#"
	    FieldType="#Form.Crit3_FieldType#"
	    Operator="#Form.Crit3_Operator#"
	    Value="#Form.Crit3_Value#">
	
</cfif>	


<cfif Form.Crit4_Value neq "">

	<CF_Search_AppendCriteria
	    FieldName="#Form.Crit4_FieldName#"
	    FieldType="#Form.Crit4_FieldType#"
	    Operator="#Form.Crit4_Operator#"
	    Value="#Form.Crit4_Value#">
	
</cfif>	

<cfset link    = replace(url.link,"||","&","ALL")>

<!--- 14/11/2015 conversion for value on the fly --->

<cfset start = "1">
<cfset new   = link>

<cfloop condition="#start# lte #len(new)#">
		
		<cfif find("{","#new#",start)>
						
			<cfset str   = find("{",new,start)>
			<cfset str   = str+1>
			<cfset end   = find("}",new,start)>
			<cfset end   = end>
						
			<cfset fld   = Mid(new, str, end-str)>
				
			<cfset new = replaceNoCase(new,"{#fld#}","'+document.getElementById('#fld#').value+'","ALL")>
									
			<cfset start = end>
			
		<cfelse>
		
			<cfset start = len(new)+1>	

		</cfif> 
	
</cfloop>		

<cfset link = new>
  
<table width="100%" border="0" cellspacing="0" cellpadding="0">

<tr>
 
<td width="100%" colspan="2" valign="top" style="padding:10px">

<!--- Query returning search results --->

<cfparam name="url.datasource" default="appsWorkorder">

<cfif url.datasource eq "">
	 <cfset url.datasource = "appsworkorder">
</cfif>

<cfquery name="Total" 
datasource="#url.datasource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT count(*) as Total
    FROM   Customer
	WHERE   1=1
	<cfif url.filter1value neq "">
	AND    orgUnit IN (SELECT OrgUnit FROM Organization.dbo.Organization WHERE Mission = '#url.filter1value#')
	</cfif>	
	<cfif url.filter2value neq "">
	AND    CustomerId IN (SELECT CustomerId FROM Workorder WHERE ServiceItem = '#url.filter2value#')
	</cfif>	
	<cfif criteria neq "">
	AND    #preserveSingleQuotes(criteria)# 	
	</cfif>
</cfquery>

<cf_pagecountN show="13" 
               count="#Total.Total#">
			   
<cfset counted  = total.total>	

<cf_verifyOperational module="WorkOrder" Warning="No">

<cfif operational eq "0">
	
	<cfsavecontent variable="mycustomer">
	
		SELECT CustomerId, Reference,CustomerName,PhoneNumber,eMailAddress,OrgUnit
		FROM Customer
		
	</cfsavecontent>

<cfelse>

	<cfsavecontent variable="mycustomer">
	
		SELECT CustomerId,Reference,PersonNo,CustomerName,PhoneNumber,eMailAddress,OrgUnit
		FROM Customer		
		UNION
		SELECT CustomerId,Reference,PersonNo,CustomerName,PhoneNumber,eMailAddress, OrgUnit
		FROM WorkOrder.dbo.Customer
		
				
	</cfsavecontent>

</cfif>



<cfquery name="SearchResult" 
datasource="#url.datasource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT TOP #last# *
    FROM (#mycustomer#) as V
	WHERE 1=1 
	
	<cfif url.filter1value neq "">
	AND  OrgUnit IN (SELECT OrgUnit 
	                 FROM   Organization.dbo.Organization 
					 WHERE  Mission = '#url.filter1value#') 
	</cfif>	
	
	<cfif url.filter2value neq "">
	AND  CustomerId IN (SELECT CustomerId 
	                    FROM   Workorder 
						WHERE  ServiceItem = '#url.filter2value#')
	</cfif>	

	<cfif criteria neq "">
	AND  #preserveSingleQuotes(criteria)#
	</cfif>
	
</cfquery>

	<table width="100%" class="navigation_table">
	
		<tr><td height="14" colspan="6">						 
			 <cfinclude template="CustomerNavigation.cfm">	 				 
		</td></tr>
		
		<cfoutput query="SearchResult">
		
		<cfif currentrow gte first>
		
			<tr class="navigation_row line labelmedium" style="height:21px">	  
			    <td height="18" width="35" style="padding-left:5px;padding-top:4px;padding-right:6px" class="navigation_action" onclick="_cf_loadingtexthtml='';ColdFusion.navigate('#link#&action=insert&#url.des1#=#customerid#','#url.box#','','','POST','');<cfif url.close eq 'Yes'>ProsisUI.closeWindow('dialog#url.box#')</cfif>">			  
				<cf_img icon="select">						
				</td>
				<td style="min-width:90px">#Reference#</td>
				<td style="min-width:70px">#PersonNo#</td>
				<TD width="70%">#CustomerName#</TD>
				<TD style="min-width:100px">#PhoneNumber#</TD>
				<TD style="min-width:100px">#eMailAddress#</TD>
			</tr>
				
		</cfif>	
				     
		</CFOUTPUT>
		
		<tr><td height="14" colspan="6">						 
			 <cfinclude template="CustomerNavigation.cfm">	 				 
		</td></tr>
	
	</table>

</td>
</tr>
 
</table>

<cfset AjaxOnLoad("doHighlight")>
