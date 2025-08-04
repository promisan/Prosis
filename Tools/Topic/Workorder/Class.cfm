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
<cfparam name="url.scopetable"  default="">
<cfparam name="url.checked"     default="">

<cfif url.scopetable eq "Ref_TopicServiceItem">

	<cfset refTable     = "ServiceItem">
	<cfset refField     = "ServiceItem">
	
<cfelse>

	<font color="red">Sorry, I am not able to determine the scope of this topic.</font>
	<cfabort>
	
</cfif>

<cfif url.checked neq "">

	<cfif url.checked eq "true">
	
		<cfquery name="Update" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
	    	INSERT INTO #url.scopetable# 
				(Code,
				 #refField#,
				 Created)
			VALUES(
				'#url.topic#',
				'#url.class#',
				getdate()
			)			
			
		</cfquery>
		
	<cfelse>
	
		<cfquery name="Delete" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    	DELETE FROM #url.scopetable#
			WHERE  Code       = '#url.topic#'
			AND    #refField# = '#url.class#'
		</cfquery>
		
	</cfif>
	
</cfif>

<cfquery name="Select" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	
	SELECT   C.Code, C.Description, C.ServiceClass, C.ServiceDomain, EC.Code as Selected
	FROM     #refTable# C
	LEFT     JOIN #url.scopetable# EC
		   ON C.Code = EC.#refField# AND EC.Code = '#url.topic#'
	ORDER  BY C.ServiceDomain, C.ServiceClass, C.ListingOrder

</cfquery>

<cfset columns = 2>
<cfset cont    = 0>

<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
	
	<cfoutput query="Select" group="ServiceDomain">
	
		<cfif servicedomain neq "">
		
		<tr class="line"><td style="height:42px;font-size:24px" colspan="#columns*2#" class="labellarge"><font color="0080C0">#ServiceDomain#</td></tr>
		
		<tr>
		 <td class="xxxhide" id="#servicedomain#_class"></td>
		 <td id="#servicedomain#" colspan="#columns*2#">
		
			<cfquery name="DomainClass" 
				datasource="AppsWorkorder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">					
					SELECT *, (SELECT count(*)
							   FROM   Ref_TopicDomainClass
							   WHERE  Code          = '#url.topic#' 
							   and    ServiceDomain = '#ServiceDomain#'
							   AND    ServiceDomainClass = C.Code) as Selected
					FROM   Ref_ServiceItemDomainClass C
					WHERE  ServiceDomain = '#ServiceDomain#'									
				</cfquery>
					
			<table class="formpadding">
						
			<cfloop query="domainclass">
			
				<cfif cont eq 0> <tr> </cfif>
				<cfset cont = cont + 1>
				<td style="padding-left:5px;width:20px">			
					<input type="checkbox" class="radiol"
					  	value="#code#" <cfif Selected eq 1>checked</cfif> 
					    onClick="_cf_loadingtexthtml='';ColdFusion.navigate('#SESSION.root#/Tools/Topic/Workorder/setDomainClass.cfm?Topic=#URL.Topic#&ServiceDomain=#serviceDomain#&ServiceDomainClass=#code#&checked='+this.checked,'#servicedomain#_class')">
				</td>
				<td class="labelit" style="padding-left:5px;padding-right:10px">#Description#</td>		
				
				 <cfif cont eq 4> </tr> <cfset cont = 0> </cfif>
				 	
			</cfloop>
								
			</table>
				
		</td></tr>
		
		</cfif>
		
		<cfoutput group="ServiceClass">
		
			<tr class="line">
			<td colspan="#columns*2#" style="padding-left:16px" class="labelmedium">#ServiceClass#
						
				<cfquery name="Class" 
				datasource="AppsWorkorder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					
					SELECT *
					FROM   ServiceItemClass
					WHERE  Code = '#serviceClass#'	
				
				</cfquery>
			
				#class.Description#
			
			</td>
			</tr>
			
			<cfset cont = 0>
		
			<cfoutput>
			
				<cfif cont eq 0> <tr> </cfif>
				<cfset cont = cont + 1>
				
				<td style="height:21px;padding-left:27px" bgcolor="<cfif selected neq "">ffffbf</cfif>">
				 	<input type="checkbox" style="height:14px;width:14px"
					   value="#code#" <cfif Selected neq "">checked="yes"</cfif> 
					   onClick="_cf_loadingtexthtml='';ColdFusion.navigate('#SESSION.root#/Tools/Topic/Workorder/Class.cfm?scopetable=#url.scopetable#&Topic=#URL.Topic#&class=#code#&checked='+this.checked,'#url.topic#_class')">
				</td>
				<td bgcolor="<cfif selected neq "">ffffbf</cfif>" style="padding-left:5px" class="labelit">#Code# #Description#</td>
						 
				 <cfif cont eq columns> </tr> <cfset cont = 0> </cfif>
		
			</cfoutput>
	
		</cfoutput>	 
		
	</cfoutput>	
 
	 <tr class="hide">
	 	<td colspan="#columns#" height="25" align="center" class="labelit"><cfif url.checked neq "">  <font color="##0080C0"> Saved! <font/> </cfif>  </td>
	 </tr>
	 
</table>

