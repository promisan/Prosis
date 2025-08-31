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
<!--- in this template we apply 

	- flyfilter
	- additional report defined conditions
	- selection of the user in this screen 
	- search as entered by the user
	
--->
 
<cfoutput>

<cfparam name="mode" default="dialog">
<cfparam name="url.tmp" default="">
<cfparam name="url.val" default="">
<cfparam name="url.adv" default="">
<cfparam name="flyfilter" default="">
<cfparam name="url.fly" default="">

<!--- ---------- --->
<!--- fly filter --->
<!--- ---------- --->

<cfset sel = replace(url.fly, ";", "'", "ALL")>  
<cfset sel = replace(sel, "$", ",", "ALL")> 
				
<cfloop index="itm" list="#sel#" delimiters=",">

     <cfif flyfilter eq "">
	     <cfset flyfilter = "#itm#">
	 <cfelse>
		 <cfset flyfilter = "#flyfilter#,#itm#">
	 </cfif>	 
	 
</cfloop> 
			 
<cfif flyfilter eq "">

      <cfset flyfilter = "''">
	  
</cfif>

<!--- predefined filter and fly conversion --->

<cfset Crit = replaceNoCase("#CriteriaValues#","@userid","#SESSION.acc#","ALL")>
<cfset Crit = replaceNoCase(Crit,"@manager",SESSION.isAdministrator,"ALL")>

<cfif flyfilter neq "'all'">
	<cfset Crit = replaceNoCase("#Crit#", "@parent", "#flyfilter#" , "ALL")>
<cfelse>
	<cfset Crit = replaceNoCase("#Crit#", "IN (@parent)", "NOT IN ('')" , "ALL")>
</cfif>	

<cfset val = replace(url.val,"'","","ALL")> 

<!--- change 20/5/2010 was : mode eq "edit" --->


<cfif mode eq "dialog">
	
	<!--- online search in dialog --->
	
	<cfif tmp eq "">  <!--- single --->
	
		<cfif URL.adv eq "1">
		  <!--- advanced search --->
		  <cfset str = "WHERE (#LookupFieldValue# LIKE '%#val#%' OR #LookupFieldDisplay# LIKE '%#val#%')">
		<cfelse>
		  <cfset str = "WHERE (#LookupFieldValue# LIKE '#val#%' OR #LookupFieldDisplay# LIKE '#val#%')">
		</cfif>
		
	<cfelse>
	
		<cfif URL.adv eq "1">
		  <cfset str = "WHERE (#LookupFieldValue# LIKE '%#val#%' OR #LookupFieldDisplay# LIKE '%#val#%') AND #LookupFieldValue# NOT IN (#preserveSingleQuotes(tmp)#)">
		<cfelse>
		  <cfset str = "WHERE (#LookupFieldValue# LIKE '#val#%' OR #LookupFieldDisplay# LIKE '#val#%') AND #LookupFieldValue# NOT IN (#preserveSingleQuotes(tmp)#)">
		</cfif>
	
	</cfif>

<cfelse>

   <cfset str = "WHERE 1=1">

</cfif>
	
<cfif FindNoCase("WHERE", "#Crit#")> 
	<cfset Crit = replaceNoCase("#Crit#","WHERE"," #str# AND ")>	
<cfelseif FindNoCase("ORDER BY", "#Crit#")> 	
	<cfset Crit = replaceNoCase("#Crit#","ORDER BY"," #str# ORDER BY ")>
<cfelse>
 	<cfset Crit = "#str#">
</cfif>	

<cfif FindNoCase("ORDER BY #LookupFieldValue#", "#preserveSingleQuotes(Crit)#")>				
	      <cfset dis = "DISTINCT">
	      <cfset t = "1">
<cfelseif FindNoCase("ORDER BY #LookupFieldDisplay#", "#preserveSingleQuotes(Crit)#")>	
 	      <cfset dis = "DISTINCT">
		  <cfset t = "0">
<cfelseif FindNoCase("ORDER BY", "#preserveSingleQuotes(Crit)#")>
	      <cfset dis = "">
    	  <cfset t = "0">
<cfelse>
	   <cfset dis = "DISTINCT">
	   <cfset t = "0">
</cfif> 

<cfset con = "#Crit#">
	
<cfif FindNoCase("ORDER BY", "#Crit#")>	

   <cfset l = FindNoCase("ORDER BY", "#Crit#")-1>
	   <cfif l gt "0">  
		 <cfset con = left("#crit#","#l#")>
	   <cfelse>
	     <cfset con = "">	 
	   </cfif>
</cfif>

</cfoutput>
