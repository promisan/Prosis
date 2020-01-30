
<cfparam name="url.recordid" default="">
<cfparam name="url.Mode" default="regular">
<cfparam name="url.type" default="cost">
<cfparam name="url.actioncode" default="">
<cfparam name="url.box" default="costcontainer">

<cfquery name="Object" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT        *
	FROM          OrganizationObject
	WHERE         ObjectId = '#URL.ObjectId#'
</cfquery>

<cfset objectId = Object.ObjectId>

<cfquery name="Get" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     *
	FROM       OrganizationObjectActionCost
	<cfif url.RecordId neq "">
		WHERE ObjectCostId = '#URL.RecordId#'	
	<cfelse>
		WHERE 1=0
	</cfif>
</cfquery>
	
<cfoutput>	

<table width="100%" height="100%" align="center" cellspacing="0" cellpadding="0" bgcolor="white" class="formpadding">

<tr><td align="center" bgcolor="white" valign="top" style="padding-left:15px;padding-right:15px;padding-top:10px">

<cfform action="#SESSION.root#/tools/entityaction/Details/Cost/CostSubmit.cfm?box=#url.box#&type=#url.type#&actioncode=#url.actionCode#"  
   name="costentryform">
   
<table width="97%" height="99%" align="center" cellpadding="0" cellspacing="0" class="formpadding formspacing">
   
	<tr><td colspan="2" class="labelit">
		
	<cfif url.recordid eq "" and url.mode neq "Cost" and url.Mode neq "Work">

		<cfif url.type eq "Cost">
		
		<cf_tl id="Press button to switch to">:&nbsp;
		<button name="Work" id="Work" class="button10g" onClick="javascript:costentry('#url.objectid#','','Work','#URL.mode#','costcontainer')">
		<img src="#SESSION.root#/Images/activity.gif" align="absmiddle" border="0">
		Work
		</button>
			
		<cfelse>
		
		<cf_tl id="Press button to switch to">:&nbsp;
		<button name="Cost" id="Cost" class="button10g" onClick="javascript:costentry('#url.objectid#','','Cost','#URL.mode#','costcontainer')">
		<img src="#SESSION.root#/Images/calculate.gif" align="absmiddle" border="0">
		<cf_tl id="Expense">
		</button>
			
		</cfif>   
	
	<cfelse>
	
	<!---
		<b>Edit Record</b>
		--->
	
	</cfif>

	</td></tr>
	
	<tr><td>
   
<cfif get.recordcount eq "0">
	<cf_assignid>   
	<cfset id = rowguid>
<cfelse>
    <cfset id = get.ObjectCostId> 
</cfif>	
   
<cfoutput>
	<input type="hidden" name="Mode" id="Mode"        value="#URL.Mode#">
	<input type="hidden" name="ObjectId" id="ObjectId"     value="#URL.ObjectId#">
	<input type="hidden" name="ObjectCostId" id="ObjectCostId" value="#id#">	
	<input type="hidden" name="EntityCode" id="EntityCode"   value="#Object.EntityCode#">
</cfoutput>      

<cfif url.recordid eq "" and url.mode neq "Cost" and url.Mode neq "Work">

	<tr><td height="1" colspan="2" class="linedotted"></td></tr></tr>
	<tr><td height="2"></td></tr>
	
</cfif>	

<tr><td class="labelit"><cf_tl id="Stage">:</td> 

<cfif url.actioncode neq "" and url.actioncode neq "undefined">

	<cfquery name="Current" 
	datasource="AppsOrganization"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   ActionCode 
    FROM     OrganizationObjectAction 
    WHERE    ObjectId = '#ObjectId#'
	AND      ActionCode = '#URL.actionCode#'	
   </cfquery>	

	<cfquery name="Step" 
	datasource="AppsOrganization"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT DISTINCT O.EntityCode, R.ActionDescription, R.ActionCode, R.ActionOrder
	FROM      Ref_EntityActionPublish R INNER JOIN
              OrganizationObject O ON R.ActionPublishNo = O.ActionPublishNo
	WHERE     (O.ObjectId = '#ObjectId#')
	AND       R.ActionCode = '#URL.actionCode#'	
	</cfquery>	

<cfelse>
	
	<cfquery name="Current" 
		datasource="AppsOrganization"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   ActionCode 
	    FROM     OrganizationObjectAction 
	    WHERE    ObjectId = '#ObjectId#'
		AND      ActionStatus = '0'
		ORDER BY ActionFlowOrder 
	</cfquery>	
	
	
	<cfquery name="Step" 
		datasource="AppsOrganization"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT DISTINCT O.EntityCode, R.ActionDescription, R.ActionCode, R.ActionOrder
		FROM         Ref_EntityActionPublish R INNER JOIN
	                 OrganizationObject O ON R.ActionPublishNo = O.ActionPublishNo
		WHERE     (O.ObjectId = '#ObjectId#')
		AND        (R.ActionCode IN (SELECT ActionCode 
		                             FROM   OrganizationObjectAction 
								     WHERE  ObjectId = '#ObjectId#'
								     AND    ActionStatus >= '2') 
									 
								  OR R.ActionCode = '#current.actionCode#')
		ORDER BY R.ActionOrder 
		
	</cfquery>	

</cfif>

<td>

	<cfif get.actionCode eq "">

    <select name="actionCode" id="actionCode" class="regularxl enterastab" style="width:90%">
		<cfloop query="step">
		<option value="#actionCode#" <cfif actioncode eq current.actioncode>selected</cfif>>#ActionDescription#</option>
		</cfloop>
    </select>
	
	<cfelse>
	
	 <select name="actionCode" id="actionCode" class="regularxl enterastab" style="width:90%">
		<cfloop query="step">
		<option value="#actionCode#" <cfif actioncode eq get.actioncode>selected</cfif>>#ActionDescription#</option>
		</cfloop>
    </select>
	
	</cfif>
	
</td>

</tr>

<tr>
	<td class="labelit">Officer :</td>
	<td class="labelmedium">
	
	<cfif url.mode eq "Actor" or url.mode eq "Work" or url.mode eq "Cost">
	
		#SESSION.first# #SESSION.last#
		
		<input type="hidden" name="UserAccount" id="UserAccount" value="#SESSION.acc#">
	
	<cfelse>
	
		<cfif Get.OwnerAccount eq "">
		
		<cfselect name="UserAccount" 
		   bindOnLoad="yes"
		   class="regularxl"
		   bind="cfc:service.EntityAction.Object.AuthorisedUsers('#ObjectId#',{actionCode})"/>	   
		   
		<cfelse>
			
		<cfquery name="User" 
			datasource="AppsSystem"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    *
			FROM      UserNames
			WHERE     Account = '#Get.OwnerAccount#'
		</cfquery>	
		
		<input type="hidden" name="UserAccount" id="UserAccount" value="#get.OwnerAccount#">
		
		#user.FirstName# #user.LastName# (#Get.OwnerAccount#)
		   
		</cfif>   
		
	</cfif>	
	  

	</td>

</tr>

<cfquery name="Group" 
		datasource="AppsOrganization"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    L.DocumentItem, L.DocumentItemName, L.DocumentId
		FROM      Ref_EntityDocument R INNER JOIN
	              Ref_EntityDocumentItem L ON R.DocumentId = L.DocumentId
		WHERE     R.DocumentMode = '#url.type#'
		AND       R.EntityCode = '#Step.EntityCode#'
		ORDER BY L.ListingOrder
	</cfquery>	 
	
<cfif group.recordcount gte "1">

<tr>
	<td class="labelit">Classification :</td>
	
	<cfquery name="Group" 
		datasource="AppsOrganization"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    L.DocumentItem, L.DocumentItemName, L.DocumentId
		FROM      Ref_EntityDocument R INNER JOIN
	              Ref_EntityDocumentItem L ON R.DocumentId = L.DocumentId
		WHERE     R.DocumentMode = 'Cost'
		AND       R.EntityCode = '#Step.EntityCode#'
		ORDER BY L.ListingOrder
	</cfquery>	 
	
	<input type="hidden" name="DocumentId" id="DocumentId" value="#Group.DocumentId#">	
	<td>
	
		<select name="DocumentItem" id="DocumentItem" clas="regularxl enterastab" style="width:100%">
			<cfloop query="group">
				<option value="#documentitem#" <cfif documentitem eq get.documentitem>selected</cfif>>#DocumentItemName#</option>
			</cfloop>
	    </select>
		
	</td>
</tr>

</cfif>

<tr>
   <td class="labelit" width="120"><cfif url.type eq "Cost">Invoice Date<cfelse>Workdate</cfif> :</td>
   <td width="420">
   
   <table cellspacing="0" cellpadding="0"><tr><td>
   
   <cfif url.recordid eq "">
   
			 <cf_intelliCalendarDate9
				FieldName="DocumentDate" 
				Default="#dateformat(now(),CLIENT.DateFormatShow)#"
				AllowBlank="False"
				Class="regularxl enterastab">	
					
   <cfelse>
  
 			 <cf_intelliCalendarDate9
				FieldName="DocumentDate" 
				Default="#dateformat(get.DocumentDate,CLIENT.DateFormatShow)#"
				AllowBlank="False"
				Class="regularxl enterastab">	
   
   </cfif>		
   
   </td>
   
   <cfset thr  = #Timeformat(get.DocumentDate, "HH")#>
   <cfset tmin = #Timeformat(get.DocumentDate, "MM")#>
   
   <td class="labelit" style="padding-left:5px">Time stamp : </td>
   <td style="padding-left:4px;padding-right:4px">
   
  			<cfinput type = "Text"
			  name       = "DocumentDateHour" 
			  value      = "#thr#"
			  maxlength  = "2"
			  message    = "Please enter time using 24 hour format"
			  validate   = "regular_expression"
			  pattern    = "[0-1][0-9]|[2][0-3]"
			  onKeyUp    = "return autoTab(this, 2, event);"
			  size       = "1"
			  required   = "false"
			  style      = "text-align: center;width:25"
			  class      = "regularxl enterastab">
																			
    </td>	
	<TD align="center" style="padding-left:4px;padding-right:4px">:</TD>	
	<td align="center" style="padding-left:4px;padding-right:4px">
					
			<cfinput type="Text"
		       name="DocumentDateMinute"
		       value="#tmin#"
		       message="Please enter a valid minute between 00 and 59"
		       maxlength="2"
			   validate="regular_expression"
		       pattern="[0-5][0-9]"
		       required="false"
			   size="1"
		       style="text-align: center;width:25"
		       class="regularxl enterastab">
   
   </td>
   
   </tr>
   </table>
   				
   </td>
</tr>	

<tr>
   <td class="labelit" width="120"><cfif url.type eq "Cost">Invoice No<cfelse>Reference</cfif>:</td>
   <td width="80%">
   
		<cfinput type="Text" 
	    name="DocumentNo" 
		required="No" 
		Size="30"
		MaxLength="30"
		value="#get.DocumentNo#"
		visible="Yes" 
		message="Please enter a subject" 
		enabled="Yes" 
		class="regularxl enterastab">
	   				
   </td>
</tr>	

<tr>
   <td class="labelit" width="120"><cf_tl id="Descriptive">:</td>
   <td width="80%">
   
		<cfinput type="Text" 
	    name="Description" 
		required="Yes" 
		size="45"
		MaxLength="70"
		value="#get.Description#"
		visible="Yes" 
		message="Please enter a description" 
		enabled="Yes" 
		class="regularxl enterastab">
		   				
   </td>
</tr>	


<tr>
   <td class="labelit" width="120"><cf_tl id="Currency">:</td>
   <td width="80%">
   
   	 <cfquery name="Param" 
    	 datasource="AppsSystem" 
	   	 username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
    	  SELECT *
	      FROM   Parameter
 	 </cfquery>
   
     <cfquery name="Currency" 
    	 datasource="AppsLedger" 
	     cachedwithin="#CreateTimeSpan(0, 2, 0, 0)#"
    	 username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
    	  SELECT *
	      FROM   Currency
 	 </cfquery>
	
	 <cfif get.DocumentCurrency eq "">
	     <cfset cur = param.BaseCurrency>
	 <cfelse>
	  	 <cfset cur = get.DocumentCurrency>
	 </cfif>
	 	 
		<select name="DocumentCurrency" id="DocumentCurrency" class="regularxl enterastab" style="text-align: center; width:60">
			<cfloop query="Currency">
			      <option value="#Currency#" <cfif cur eq Currency>selected</cfif>>
				  #Currency#
				  </option>
			</cfloop>					
		</select>
   		   				
   </td>
</tr>	

<cfif url.type eq "Cost">
  <input type="hidden" name="DocumentQuantity" id="DocumentQuantity" value="1">
<cfelse>

<tr>
   <td width="120" class="labelit"><cf_tl id="Time">:</td>
   <td width="80%">
   
   	<table cellspacing="0" cellpadding="0">
	<tr><td>
	
	   <cfif get.DocumentQuantity eq "">
	   
	   	    <cfset h = 0>	
			<cfset m = 0>
			   
	   <cfelse>
	
		   <cfset a = abs(get.documentquantity)>
		
		   <cfset h = int(a)>
		   <cfset m = round((a - h)*60)>
		   
		   <cfif get.documentquantity lt "0">
		   
			   <cfset h = -h>
		   
		   </cfif>
		 	   
	   </cfif>
	   
	   <select name="DocumentQuantity" id="DocumentQuantity" style="text-align:center" class="regularxl enterastab">
	   		<cfloop index="hr" from="0" to="20" step="1">
				<option value="#hr#" <cfif h eq hr>selected</cfif>>#hr#</option>
			</cfloop>
			<cfloop index="hr" from="-10" to="-1" step="1">
				<option value="#hr#" <cfif h eq hr>selected</cfif>>#hr#</option>
			</cfloop>
	   </select>	
	   
	   </td><td class="labelit">
	   &nbsp;&nbsp;<cf_tl id="Hours">
	   </td>
	   <td>
	   &nbsp;
	   
	   <select name="DocumentMinute" id="DocumentMinute" class="regularxl enterastab" style="text-align:center">
	   		<cfloop index="min" from="0" to="55" step="5">
				<option value="#min#" <cfif m eq min>selected</cfif>>#min#</option>
			</cfloop>
	   </select>
	   </td>
	   <td class="labelit">&nbsp;&nbsp;<cf_tl id="Minutes"></td>
	</tr>
	</table>
		   				
   </td>
</tr>	

</cfif>


<tr>
   <td class="labelit" width="120"><cfif url.type eq "Cost"><cf_tl id="Amount"><cfelse><cf_tl id="Rate"></cfif>:</td>
   <td width="80%">
   
		<cfinput type="Text"
	       name="DocumentRate"
	       value="#get.DocumentRate#"
	       message="Please enter an amount"
	       validate="float"
	       required="Yes"      
	       size="6"
		   style="text-align:right"
	       maxlength="30"
	       class="regularxl enterastab">
		   				
   </td>
</tr>	


<cfif url.mode eq "Regular">

<tr>
   <td class="labelit"  width="120"><cfif url.type eq "Cost"><cf_tl id="Invoice"><cfelse><cf_tl id="Invoice Rate"></cfif>:</td>
   <td width="80%">
   
	  <cfinput type="Text"
       name="InvoiceRate"
       value="#get.InvoiceRate#"
       message="Please enter an amount"
       validate="float"
       required="Yes"      
       size="20"
       maxlength="30"
	   style="text-align:right"
       class="regularxl enterastab">
		   				
   </td>
</tr>	

<cfelse>

	<input type="hidden" value="#get.InvoiceRate#">

</cfif>

<tr>
   <td class="labelit" width="120"><cf_tl id="Attachment">:</td>
   <td width="80%" id="#id#">
   
	<cf_filelibraryN
			DocumentPath="#Object.EntityCode#"
			SubDirectory="#id#" 
			Filter=""				
			Width="100%"
			loadscript="No"
			attachDialog="Yes"
			inputsize = "340"
			Box = "#id#"
			Insert="yes"
			Remove="yes">	
							
	</td>
</tr>				

<tr>
  <td class="labelit" width="120"><cf_tl id="Memo">:</td>
  <td valign="top" height="100%">
       
        <textarea name="DocumentMemo"            
			 style="width:95%;height:95%;font-size;14px;padding:3px" 
			 class="regular">#Get.DocumentMemo#</textarea>
	 
	</td>
</tr>		

<tr><td align="center" height="26" colspan="2">
<cfif url.recordid eq "">

	 <cf_tl id="Close" var="1" >
	 <cfset tClose = "#Lt_text#">
	 
    <input class="button10g" type="button" name="Cancel" id="Cancel" value="#tClose#" onClick="costhidedialog('#url.type#')">

	 <cf_tl id="Save" var="1" >
	 <cfset tSave = "#Lt_text#">
	 
	<input class="button10g" type="button" name="Update" id="Update" value="#tSave#" 
	onclick="ColdFusion.navigate('#SESSION.root#/tools/entityaction/Details/Cost/CostSubmit.cfm?box=#url.box#&type=#url.type#&actioncode=#url.actionCode#','#url.box#','','','POST','costentryform')">
	
<cfelse>

	 <cf_tl id="Close" var="1" >
	 <cfset tClose = "#Lt_text#">

    <input class="button10g" type="button" name="Cancel" id="Cancel" value="#tClose#"  onClick="costhidedialog('#url.type#')">
	
	 <cf_tl id="Delete" var="1" >
	 <cfset tDelete = "#Lt_text#">

    <input class="button10g" type="button" name="Delete" id="Delete" value="#tDelete#" onclick="costask('#objectid#','#url.recordid#','#url.mode#','#url.box#','#url.actioncode#')">

	 <cf_tl id="Save" var="1" >
	 <cfset tSave = "#Lt_text#">
	 	
    <input class="button10g" type="button" name="Update" id="Update" value="#tSave#" 
	onclick="ColdFusion.navigate('#SESSION.root#/tools/entityaction/Details/Cost/CostSubmit.cfm?box=#url.box#&type=#url.type#&actioncode=#url.actionCode#','#url.box#','','','POST','costentryform')">
	
	
</cfif>
</td></tr>

</table>

</cfform> 

</td></tr>
</table>

</cfoutput>

<cfset ajaxOnload("doCalendar")>


