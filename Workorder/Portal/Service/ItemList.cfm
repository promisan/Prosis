
<cfparam name="URL.ID" default="Cat">
<cfparam name="URL.ID1" default="xxx">
<cfparam name="URL.Status" default="0">

<cfif URL.find neq "">
    <cfset Criteria = "(I.Description LIKE '%#URL.find#%' OR I.Code LIKE '%#URL.find#%')">
</cfif>   

<cfoutput>
	<cfsavecontent variable="sql">
		<!--- SELECT     R.*, M.Contact AS Contact --->
        FROM       ServiceItem R INNER JOIN
                   ServiceItemMission M ON R.Code = M.ServiceItem INNER JOIN
				   ServiceItemClass C ON R.ServiceClass = C.Code
        WHERE     (R.Operational = 1) AND (M.Mission = '#url.mission#')	  	 
	   	<cfif URL.find neq "">
		AND   #PreserveSingleQuotes(Criteria)#   
		</cfif>
		<cfif URL.category neq "undefined" and URL.Category neq "All">
		AND   R.ServiceClass = '#URL.Category#'  
		</cfif>			
	</cfsavecontent>
</cfoutput>

<!--- Query returning search results --->
<cfquery name="Total" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT  count(*) as Total
	FROM    ServiceItem R INNER JOIN
            ServiceItemMission M ON R.Code = M.ServiceItem INNER JOIN
			ServiceItemClass C ON R.ServiceClass = C.Code
    WHERE   (R.Operational = 1) AND (M.Mission = '#url.mission#')	  	 
   	<cfif URL.find neq "">
	AND   #PreserveSingleQuotes(Criteria)#   
	</cfif>
	<cfif URL.category neq "undefined" and URL.Category neq "All">
	AND   R.ServiceClass = '#URL.Category#'  
	</cfif>				
</cfquery>

<cfparam name="url.page" default="1">
<cfset cpage  = url.page>
<cfset pages = ceiling(total.total/9)>
<cfif pages lt "1">
   <cfset pages = '1'>
</cfif>

<cfset top    = (page)*9>
<cfset first  = ((page-1)*9)+1>

<!--- Query returning search results --->
<cfquery name="SearchResult" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT TOP #top# R.*, C.Description as ClassDescription
	FROM   ServiceItem R INNER JOIN
           ServiceItemMission M ON R.Code = M.ServiceItem INNER JOIN
		   ServiceItemClass C ON R.ServiceClass = C.Code
    WHERE  (R.Operational = 1) AND (M.Mission = '#url.mission#')	  	 
   	<cfif URL.find neq "">
	AND   #PreserveSingleQuotes(Criteria)#   
	</cfif>
	<cfif URL.category neq "undefined" and URL.Category neq "All">
	AND   R.ServiceClass = '#URL.Category#'  
	</cfif>			
    ORDER BY C.ListingOrder, R.ListingOrder 
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
 
<tr><td>
		
		<table width="97%" align="center" border="0" cellspacing="1" cellpadding="1">
		
		<cfoutput query="SearchResult" group="ServiceClass" startrow="#first#">
		<tr><td colspan="6" height="20"><b>#ClassDescription#</b></td></tr>
		<tr><td height="1" colspan="6" style="border-top: 1px dotted Silver;"></td></tr>		
		
		<cfset cnt = 0>
		
		<cfoutput>
		
			<!---	
		    <cfif isNotRequest eq "">
			--->
			
				<cfset cnt = cnt+1>
				<cfif cnt eq "1"><TR></cfif>
				<td id="b#currentrow#_1" name="b#currentrow#12"  
				        width="190" 
						height="100%" 
						bgcolor="white" 
						style="cursor: pointer;"
			            align="center"
						onmouseover="hl('b#currentrow#_1','b#currentrow#_2')"
						onmouseout="sl('b#currentrow#_1','b#currentrow#_2')"
						onclick="add('#Code#','0000')" bgcolor="white">
							
					 <table width="100%" height="100%" bgcolor="white" >
					 <tr><td bgcolor="white" valign="top" align="center">	
					
					<!--- slow performance to be reviewed
					 
					<cfif FileExists("#SESSION.RootDocumentPath#WorkOrder/Pictures/#Code#.jpg")>
					
					 <cftry> 					 
					
					 <cfimage 
					  action="RESIZE" 
					  source="#SESSION.RootDocument#Workorder/Pictures/#Code#.jpg" 
					  name="showimage" 
					  height="150" 
					  width="190">
					  
					  <cfimage 
					  action="WRITETOBROWSER" source="#showimage#">
					  
					  <cfcatch>
					  
					  	<img src="#SESSION.Root#/images/image-not-found.gif"
					     alt="#Description#"
					     height="150"
					     border="0"
					     align="absmiddle">
					  
					  </cfcatch>
					  
					  </cftry>					  
										   
					 <cfelse>
					 
					 --->
					 
					 	<img src="#SESSION.Root#/images/image-not-found.gif"
					     alt="#Description#"
					     height="150"
					     border="0"
					     align="absmiddle">
						 
					 <!---	 
						 
					 </cfif>
					 
					 --->
					 
					 </td></tr></table>	
					 
				</td>
				<td width="30%" name="b#currentrow#_2"  id="b#currentrow#_2" style="cursor:pointer" class="regular" valign="top"
					onmouseover="hl('b#currentrow#_1','b#currentrow#_2')"
					onmouseout="sl('b#currentrow#_1','b#currentrow#_2')"
					onclick="add('#Code#','00000')">
					
				     <table width="100%" cellspacing="0" cellpadding="2" class="formpadding">
					    				     	 
						 <tr><td width="100" class"labelit">Item:</td><TD class"labelit">#Description#</TD></tr>
						 <tr><td class"labelit"><cf_tl id="Details">:</td><TD class"labelit">#Memo#</TD></tr>
						 <!--- detailed lines --->						 
						 <!---
						 <tr><td><font color="gray">UoM:</font></td><TD>#UoMDescription#</TD></tr>
						 <tr><td><font color="gray"><cf_tl id="Category">:</TD><TD>#Category#</TD></tr>
						 <tr><td><font color="gray"><cf_tl id="Cost Price">:</font></td><td>#NumberFormat(StandardCost,'_____.__')#</td></tr>
						 --->
						 <tr><td><b><!--- <font color="0080FF">Available</font></b>---></td></tr>
				     </table>
				 </td>
				 <cfif cnt eq "2"></TR>
				 <tr><td height="1" colspan="6" class="line"></td></tr>
				 <cfset cnt=0>
				 
				 <!---
				 </cfif>
				 --->
						
			</cfif>
		</cfoutput>
		</CFOUTPUT>
		
		<tr><td align="center" colspan="6">
									
		<cf_pagenavigation cpage="#cpage#" pages="#pages#">					
		
		</td></tr>
		
		</TABLE>
		
</td></tr>
					
</table>			
