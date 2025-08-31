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
<cfoutput>
	<cfset tit = "Add actions to: #URL.EntityClass#">
</cfoutput>

<!---
<cf_screentop height="100%" close="parent.ColdFusion.Window.destroy('mystep',true)" jquery="yes" label="#tit#" scroll="yes" layout="webapp" banner="gray" bannerheight="55">
--->

<cfquery name="Action" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *, 'NOT USED' as Status 
	FROM   Ref_EntityAction
	WHERE  EntityCode = '#URL.EntityCode#'
	AND    Operational = '1'
	AND    ActionType IN ('Action','Decision')
	AND    ActionCode NOT IN (SELECT ActionCode 
	                       FROM   Ref_EntityClassAction
						   WHERE  EntityCode = '#URL.EntityCode#'
						   AND    EntityClass = '#URL.EntityClass#')
						   
	<!---					   
	UNION
	SELECT *, 'IN USE' as Status
	FROM Ref_EntityAction 
	WHERE EntityCode = '#URL.EntityCode#'
	AND Operational = '1'
	AND ActionType IN ('Action','Decision')
	AND ActionCode IN (SELECT ActionCode 
	                   FROM   Ref_EntityClassAction
					   WHERE  EntityCode = '#URL.EntityCode#'
					   AND    EntityClass = '#URL.EntityClass#'
					  )
					  
	--->				  
	ORDER BY ListingOrder		
				   
</cfquery>

<cfform action="#session.root#/System/EntityAction/EntityFlow/ClassAction/ActionStepAddSubmit.cfm?EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#" target="result" method="POST" style="height:98%">
		
<table height="100%" width="98%" align="center">

<tr class="hide"><td><iframe name="result" id="result"></iframe></td></tr>

<cf_presentationscript>

<tr>
	<td style="padding-left:10px;">
	
	<cfinvoke component = "Service.Presentation.TableFilter"  
	   method           = "tablefilterfield" 
	   filtermode       = "auto"
	   name             = "filtersearch"
	   style            = "font:14px;height:23;width:120"
	   rowclass         = "lines"
	   rowfields        = "cdescription,ccode,csearch">							
		
	</td>
</tr>

<tr><td valign="top" height="95%">
			
	<cf_divscroll>
	
	<table width="97%" align="center" class="navigation_table">
		
	<tr class="fixrow labelmedium2 line fixlengthlist">
	   <td style="background-color:white">Code</td>
	   <td style="background-color:white">Description</td>
	   <td style="background-color:white">Type</td>
	   <td style="background-color:white">Officer</td>
	   <td style="background-color:white"></td>
	   <td style="background-color:white"></td>
	</tr>
		
	<cfoutput query="Action">
				
		<cfquery name="Used" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
		SELECT   DISTINCT R.EntityClassName, R.EntityClass
		FROM     Ref_EntityClassAction AS A INNER JOIN
		         Ref_EntityClass AS R ON A.EntityCode = R.EntityCode AND A.EntityClass = R.EntityClass
		WHERE    A.EntityCode   = '#EntityCode#'
		AND      A.ActionCode  = '#ActionCode#'
		AND      A.EntityClass != '#URL.EntityClass#'
		</cfquery>
	
	<tr class="line labelmedium2 navigation_row lines fixlengthlist">
		<td class="ccode" style="padding-left:4px">#ActionCode#</td>
		<td class="cdescription">#ActionDescription#</td>
		<td>#ActionType#</td>
		<td>#officerUserId#</td>
		<td>#dateformat(created, CLIENT.DateFormatShow)#</td>
		<td align="left">
		<cfif Status eq "IN USE">
			<font color="0080FF">
			#Status#
		<cfelse>
			<input type="checkbox" name="selected" id="selected" value="'#ActionCode#'">
		</cfif>
		</td>
	</tr>
	
	<cfset search = "#ActionCode# #ActionDescription#">
		
	<cfif Used.recordcount gte "1">
	
		<tr class="line fixlengthlist lines" style="height:15px">
		  <td style="display:none" class="csearch">#search#</td>
		  <td align="right" style="padding-right:4px">
		  <font size="1" color="6688aa">Used in draft:</font>	 
		  </td>
		  <td colspan="4"><font face="Verdana" size="1" color="gray">#Used.entityClassName# (#Used.EntityClass#)</td>
		  <td></td>
		</td>		
		</tr>
		
		<cfloop query="Used" startrow="2">
		<tr class="line  fixlengthlist lines" style="height:15px">
			<td style="display:none" class="csearch">#search#</td>
			<td></td>
			<td colspan="5"> <font size="1" face="Verdana" color="gray">#entityClassName# (#Used.EntityClass#)</td>
		</tr>
		</cfloop>
	
	</cfif>
	
	<tr style="display:none" class="lines fixlengthlist">
	   <td style="display:none" class="csearch">#search#</td><td colspan="6" class="line"></td>
	</tr>
		
	</cfoutput>	
		
	</table>
	
	</cf_divscroll>
		
	</td>

</tr>

<tr>
	<td colspan="5" height="25" align="center" valign="bottom">	
		<input type="submit" name="Submit" id="Submit" value="Add" style="width:200px" class="button10g">
	</td>
</tr>

</table>

</cfform>

<cfset ajaxonload("doHighlight")>

<cf_screenbottom layout="webapp">