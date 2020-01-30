
<cf_screentop height="100%" scroll="Yes" layout="innerbox" title="Preferences">

<script>

ie = document.all?1:0
ns4 = document.layers?1:0

window.height = "100"

function hl(itm,fld){

     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
	 
	 	 		 	
	 if (fld != false){
		
	 itm.className = "highLight3";
	 }else{
		
     itm.className = "regular";		
	 }
  }

</script>

<cfquery name="List" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT    DISTINCT M.Mission, 
          M.MandateNo, 
		  M.OrgUnit, 
		  M.OrgUnitCode, 
		  M.OrgUnitName, 
		  C.ConditionValue
FROM      Organization.dbo.Ref_MissionModule A INNER JOIN
          Organization.dbo.Organization M ON A.Mission = M.Mission LEFT OUTER JOIN
          UserModuleCondition C ON M.OrgUnitCode = C.ConditionValue 
		  AND C.SystemFunctionId = '#URL.ID#'
		  AND C.Account          = '#SESSION.acc#'
		  AND C.ConditionField   = 'OrgUnit'
WHERE     A.SystemModule = 'Insurance'
AND       (M.ParentOrgUnit = '' or M.ParentOrgUnit is NULL)
ORDER BY M.Mission, MandateNo 
</cfquery>

<table width="97%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">

<cfform action="../TopicsEditSubmit.cfm" method="POST">

<cfoutput>
<input type="hidden" name="SystemFunctionId" value="#URL.ID#">
<input type="hidden" name="ConditionField" value="OrgUnit">
</cfoutput>

<tr><td>

<table width="100%">

<cfset module = "">

<cfoutput query="List" group="Mission">

<cfoutput group="MandateNo">

 <tr><td colspan="2" class="header"><b>#Mission# [#MandateNo#]</b></td></tr>

<cfoutput>

<cfif #ConditionValue# is ''>
   <tr class="regular">
<cfelse>
   <tr class="highLight">
</cfif>   
   
    <TD>
	<cfif ConditionValue is ''>
	<input type="checkbox" name="Value_#List.currentrow#" value="#OrgUnitCode#" onClick="hl(this,this.checked)">
	<cfelse>
	<input type="checkbox" name="Value_#List.currentrow#" value="#OrgUnitCode#" checked onClick="hl(this,this.checked)">
	</cfif>
    </TD>
    <TD class="regular">#OrgUnitName#</font></TD>
 
</TR>

</CFOUTPUT>
</CFOUTPUT>
</CFOUTPUT>

<cfoutput>
	<input type="hidden" name="number" value="#List.recordcount#">
</cfoutput>

<tr><td align="center" colspan="2">
   <input type="button" class="button10g" value="   Close  " onClick="window.close()">
   <input type="submit" class="button10g" name="Update" value="Save">
</td></tr>
	
</CFFORM>

</table>

</table>

<cf_screenbottom layout="innerbox">
