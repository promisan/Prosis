<cfoutput>

<cfquery name="Action" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_EntityAction
	WHERE ActionCode  = '#URL.ActionCode#'
</cfquery>

<cfquery name="Class" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_EntityClass
		WHERE EntityCode  = '#URL.EntityCode#'
		AND   EntityClass = '#URL.EntityClass#'	
</cfquery>

<cfif URL.PublishNo eq "">
	
		<cfquery name="Get" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM Ref_EntityClassAction
			WHERE ActionCode  = '#URL.ActionCode#'
			AND   EntityClass = '#URL.EntityClass#'
			AND   EntityCode  = '#URL.EntityCode#' 
		</cfquery>
		
	<cfelse>
	
		<cfquery name="Get" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM Ref_EntityActionPublish A
			WHERE A.ActionCode    = '#URL.ActionCode#'
			AND A.ActionPublishNo = '#URL.PublishNo#'	
		</cfquery>
	
</cfif>	

<cfif URL.PublishNo neq "">
	<cfset l = "Action: #Get.ActionDescription# [Published]">
<cfelse>
    <cfset l = "Action: #Get.ActionDescription# [Draft]">
</cfif>	

<cf_screenTop height="100%" label="#l#" jQuery="Yes" scroll="no" html="No">
	
<cfajaximport tags="cfform,cfdiv">
<cfinclude template="ActionStepEditScript.cfm">

<cf_textareascript>
<cf_LayoutScript>

	
<table style="height:100%" width="100%" align="center">

<TR class="line">
	<td height="29" width="70%" class="labelmedium" style="padding-left:4px">#Class.EntityClassName# (#URL.EntityClass#) step:
	&nbsp;<b><font color="0080FF"><!--- #Get.ActionCode#---> #Get.ActionDescription#
	</TD>
	
	<cfoutput>
	<td id="#URL.EntityClass#_#URL.actionCode#_result" align="right"></td>
	</cfoutput>

	<td align="right" class="labelit">
	<cfif Action.ProcessMode eq "0">
		<font color="808080">Conventional&nbsp;Mode</b></font>
	<cfelse>
		<font color="gray">Advanced&nbsp;Mode</b></font>
	</cfif>
	</td>
	
</TR>	

<cf_menuscript>

<tr class="line"><td colspan="3" height="20">

			 <table width="99%" align="center">
			 <tr>
			 
			 	<cfset ht = "54">
				<cfset wd = "54">
			 		
					<cf_menutab item       = "1" 
					            iconsrc    = "Logos/System/WorkflowStep.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								width      = "33%"
								class      = "highlight2"								
								name       = "Workflow Step Configuration"
								source     = "javascript:showaction()">		
								
					<cf_menutab item       = "2" 
					            iconsrc    = "Logos/System/WorkflowInstructions.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								width      = "33%"
								name       = "Actor Workflow Instructions"								
								source     = "javascript:showinstruction()">					
								
					<cf_menutab item       = "3" 
					            iconsrc    = "Logos/System/WorkflowMovements.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								width      = "33%"
								name       = "Conditional Workflow Movements"								
								source     = "javascript:showflow()">											
				
				<td width="10%"></td>						 
			 </tr>
			 </table>
						
		</td>
</tr>

<tr>
<td style="padding-left:10px" colspan="3" height="100%" width="99%" valign="top" border="0" align="center" id="stepdata">	
	
		<cf_divscroll>		
		<cfinclude template="ActionStepEditAction.cfm">		
		</cf_divscroll>
	
</td>
</tr>

</table>

</cfoutput>