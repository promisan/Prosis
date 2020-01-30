
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

<cf_divscroll>

<table width="98%" align="center" bordercolor="white" border="0" cellspacing="0" cellpadding="0">

<tr class="hide"><td><iframe name="result" id="result"></iframe></td></tr>

<cf_presentationscript>

<tr>
			<td style="padding-left:15px;">
			
				<cfinvoke component = "Service.Presentation.TableFilter"  
				   method           = "tablefilterfield" 
				   filtermode       = "auto"
				   name             = "filtersearch"
				   style            = "font:13px;height:21;width:120"
				   rowclass         = "lines"
				   rowfields        = "cdescription,ccode,csearch">							
				
			</td>
		</tr>

<tr><td valign="top">

	<cfform action="#session.root#/System/EntityAction/EntityFlow/ClassAction/ActionStepAddSubmit.cfm?EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#" target="result" method="POST">
	
	<table width="97%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding navigation_table">
		
	<tr class="labelmedium line">
	   <td width="10%">Code</td>
	   <td width="40%">Description</td>
	   <td width="10%">Type</td>
	   <td width="20%">Officer</td>
	   <td width="80">Created</td>
	   <td width="6%"></td>
	</tr>
		
	<cfoutput query="Action">
	
		<cfset search = "#Action.ActionCode# #Action.ActionDescription#">
	
		<cfquery name="Used" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
		SELECT   DISTINCT R.EntityClassName, R.EntityClass
		FROM     Ref_EntityClassAction AS A INNER JOIN
		         Ref_EntityClass AS R ON A.EntityCode = R.EntityCode AND A.EntityClass = R.EntityClass
		WHERE    A.EntityCode = '#EntityCode#'
		AND      A.ActionCode = '#ActionCode#'
		AND      A.EntityClass != '#URL.EntityClass#'
		</cfquery>
	
	<tr class="line labelmedium navigation_row">
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
		
	<cfif Used.recordcount gte "1">
	
		<tr>
		  <td style="display:none" class="csearch">#search#</td>
		  <td colspan="1" align="right" style="padding-right:4px">
		  <font size="1" color="6688aa">Used in:</font>	  
		  </td>
		  <td colspan="4"><font face="Verdana" size="1" color="gray">#Used.entityClassName# (#Used.EntityClass#)</td>
		  <td></td>
		</td>
		
		</tr>
		
		<cfloop query="Used" startrow="2">
		<tr>
			<td style="display:none" class="csearch">#search#</td>
			<td></td>
			<td colspan="4"> <font size="1" face="Verdana" color="gray">#entityClassName# (#Used.EntityClass#)</td>
		</tr>
		</cfloop>
	
	</cfif>
	
	<tr style="display:none" class="lines"><td style="display:none" class="csearch">#search#</td><td colspan="6" class="line"></td></tr>
		
	</cfoutput>	
	
	<tr>
	<td colspan="5" height="25" align="center" valign="bottom">	
		<input type="submit" name="Submit" id="Submit" value="Add" style="width:200px" class="button10g">
	</td>
	</tr>
	
	</table>
		
	</cfform>
	
	</td>

</tr>

</table>

</cf_divscroll>

<cfset ajaxonload("doHighlight")>

<cf_screenbottom layout="webapp">