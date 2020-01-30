<!--- Create Criteria string for query from data entered thru search form --->
<cf_screentop  layout="webapp" html="No" JQuery="Yes" height="100%" scroll="Yes" >
	
<cfparam name="URL.View" default="Hide">

<cfajaximport tags="cfwindow,cfdiv,cfform,cfinput-datefield">

<cfsavecontent variable="option">  

<select name="view" id="view" size="1" class="regularxl" onChange="search(this.value)">
      <OPTION value="Hide" <cfif URL.view eq "Hide">selected</cfif>>Hide vendors
	  <OPTION value="Show" <cfif URL.view eq "Show">selected</cfif>>Show vendors
 </select>
	 
</cfsavecontent>	

<!--- initially populate

<cfquery name="ItemService" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO ItemMasterMission
	         (ItemMaster, 
			  Mission, 					 
			  OfficerUserId, 
			  OfficerLastName, 
			  OfficerFirstName)
	SELECT   Code, 
	         Mission, 					
			 '#SESSION.acc#', 
			 '#SESSION.last#',
			 '#SESSION.first#'
	FROM     ItemMaster I
	WHERE    Code NOT IN (SELECT ItemMaster 
	                      FROM   Purchase.dbo.ItemMasterMission
						  WHERE  ItemMaster = I.Code
						  AND    Mission    = I.Mission)			
</cfquery>	
--->

<!--- load service items as item master 
	
<cf_verifyOperational 
         datasource= "appsSystem"
         module    = "WorkOrder" 
		 Warning   = "No">
		 
<cfif operational eq "1">

	<cfquery name="Check" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    SELECT * 
		FROM   Ref_EntryClass
		WHERE  Code = 'Services'
	</cfquery>
	
	<cfif check.recordcount eq "1">	
	
		<cfquery name="ItemService" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO Purchase.dbo.ItemMaster
		             (Code, 
					  Description, 
					  EntryClass, 
					  isServiceItem, 
					  OfficerUserId, 
					  OfficerLastName, 
					  OfficerFirstName)
			SELECT   Code, 
			         Description, 
					 'Services', 
					 1, 
					 '#SESSION.acc#', 
					 '#SESSION.last#',
					 '#SESSION.first#'
			FROM     ServiceItem
			WHERE    Code NOT IN (SELECT Code 
			                      FROM   Purchase.dbo.ItemMaster)
			AND      (Operational = 1)
			AND      ServiceClass IN (SELECT Code 
			                          FROM   ServiceItemClass 
									  WHERE  Operational = 1)
		</cfquery>	
	</cfif>
	
</cfif>	

--->
 
<cfajaximport>
<table width="99%" height="100%" cellspacing="0" cellpadding="0" align="center">

<tr><td height="30">
	
	<cfset Page         = "0">
	<cfset add          = "1">
	<cfset option       = option>
	<cfinclude template = "../HeaderMaintain.cfm"> 

</td></tr>

<cfoutput>

<script>

function search(view) {		
    Prosis.busy('yes')
	_cf_loadingtexthtml='';	
    ptoken.navigate('RecordListingResult.cfm?view='+view,'mylistings','','','POST','searchform')     	
}

function recordadd(grp) {
     window.open("RecordAdd.cfm?idMenu=#url.idmenu#&ts="+new Date().getTime(), "_blank");	
}

function refreshlisting(obj) {
    Prosis.busy('yes')
	se = document.getElementById("view").value
	_cf_loadingtexthtml='';	
	ptoken.navigate('RecordListingResult.cfm?view='+se+'&object='+ret,'mylistings','','','POST','searchform')	
}		

function recordedit(id1) {  
     ptoken.open("RecordEdit.cfm?idMenu=#url.idmenu#&mission="+document.getElementById('mission').value+"&ID1=" + id1,"_blank","left=30, top=30, width=1100, height=899, toolbar=no, menubar=no, status=yes, scrollbars=yes, resizable=yes");
}
	 
function refreshlist(id1) {	 
	
	   _cf_loadingtexthtml='';	
	   ColdFusion.navigate('RecordListingRefresh.cfm?id1='+id1+'&col=code',id1+'_code')
	   ColdFusion.navigate('RecordListingRefresh.cfm?id1='+id1+'&col=desc',id1+'_desc')	
	   ColdFusion.navigate('RecordListingRefresh.cfm?id1='+id1+'&col=objc',id1+'_objc')	
	   ColdFusion.navigate('RecordListingRefresh.cfm?id1='+id1+'&col=clss',id1+'_clss')	
	   ColdFusion.navigate('RecordListingRefresh.cfm?id1='+id1+'&col=oper',id1+'_oper')
	
     }

</script>	

<tr><td style="height:100%" valign="top">

	<form name="searchform" style="height:100%">

	<table width="96%" height="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<tr><td valign="top" height="50">
	
		<cf_tl id="contains" var="1">
		<cfset vcontains=#lt_text#>
		
		<cf_tl id="begins with" var="1">
		<cfset vbegins=#lt_text#>
		
		<cf_tl id="ends with" var="1">
		<cfset vends=#lt_text#>
		
		<cf_tl id="is" var="1">
		<cfset vis=#lt_text#>
		
		<cf_tl id="is not" var="1">
		<cfset visnot=#lt_text#>
		
		<cf_tl id="before" var="1">
		<cfset vbefore=#lt_text#>
		
		<cf_tl id="after" var="1">
		<cfset vafter=#lt_text#>	
		
		<cf_tl id="search" var="1">
		<cfset vsearch=#lt_text#>	
		
		<cf_tl id="close" var="1">
		<cfset vclose=#lt_text#>		
		
	    <table cellspacing="0" cellpadding="0" class="formpadding">
			
		    <cfquery name="MissionList" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT DISTINCT Mission FROM ItemMaster	
				WHERE Mission is not NULL	 
			</cfquery>
		
		<tr><td class="labelmedium">Managed by:</td>
		   
		    <td>	
			
			<table cellspacing="0" cellpadding="0">
			
			<tr><td>
			
			 <select name="mission" id="mission" class="regularxl">
						
				<option value="" selected>Any</option>		
				<cfloop query="MissionList">
				 <option value="#Mission#">#Mission#
				</cfloop>
			
			</select>
			
			</td>
			
			</tr>
			</table>	
		
		</td>
		
		<td class="labelmedium" style="padding-left:10px;padding-right:10px">Enabled for entity:</td>	
		<td style="padding-right:10px"><cfdiv bind="url:filterusage.cfm?view=#url.view#&mission={mission}" id="usage"></td>		
	
		<td class="hide">Service Item:</td>
		
		<td class="hide">
		 <select name="isServiceitem" id="isServiceitem" class="regularxl" onChange="search('#URL.view#')">
			  <option value="" selected>Any</option>
			  <option value="1">Yes</option>
			  <option value="0">No</option>       	     
	   	   </select>
		</td>
		
		</tr>
					 
		<!--- Field: Item.ItemDescription=CHAR;100;FALSE --->
		<INPUT type="hidden" name="Crit1_FieldName" id="Crit1_FieldName" value="I.Description">
		
		<INPUT type="hidden" name="Crit1_FieldType" id="Crit1_FieldType" value="CHAR">
		<TR>
		<TD class="labelmedium"><cf_tl id="Item name">:</TD>
		
		<TD style="padding-right:15px">
		
		<SELECT name="Crit1_Operator" id="Crit1_Operator" style="font:10px" class="hide">
			
				<OPTION value="CONTAINS"><cfoutput>#vcontains#</cfoutput>		
				<OPTION value="BEGINS_WITH"><cfoutput>#vbegins#</cfoutput>
				<OPTION value="ENDS_WITH"><cfoutput>#vends#</cfoutput>
				<OPTION value="EQUAL"><cfoutput>#vis#</cfoutput>		
				<OPTION value="NOT_EQUAL"><cfoutput>#visnot#</cfoutput>
				<OPTION value="SMALLER_THAN"><cfoutput>#vbefore#</cfoutput>
				<OPTION value="GREATER_THAN"><cfoutput>#vafter#</cfoutput>
			
			</SELECT>
			
			 <INPUT type="text" name="Crit1_Value" id="Crit1_Value" style="width:170" size="28" class="regularxl">
		
		</TD>
		
		<!--- Field: Item.ItemColor=CHAR;20;FALSE --->
		<INPUT type="hidden" name="Crit4_FieldName" id="Crit4_FieldName" value="I.Code">	
		<INPUT type="hidden" name="Crit4_FieldType" id="Crit4_FieldType" value="CHAR">
		
		<TD class="labelmedium" style="padding-left:10px;"><cf_tl id="Code">:</td>
		
		<TD >		
		<INPUT type="text" name="Crit4_Value" id="Crit4_Value" size="10" class="regularxl">
		
		     <SELECT name="Crit4_Operator" id="Crit4_Operator" style="font:10px" class="hide">
			
				<OPTION value="CONTAINS"><cfoutput>#vcontains#</cfoutput>
				<OPTION value="BEGINS_WITH"><cfoutput>#vbegins#</cfoutput>
				<OPTION value="ENDS_WITH"><cfoutput>#vends#</cfoutput>
				<OPTION value="EQUAL"><cfoutput>#vis#</cfoutput>		
				<OPTION value="NOT_EQUAL"><cfoutput>#visnot#</cfoutput>
				<OPTION value="SMALLER_THAN"><cfoutput>#vbefore#</cfoutput>
				<OPTION value="GREATER_THAN"><cfoutput>#vafter#</cfoutput>
			
			</SELECT> 
		
		</TD>
		</TR>
				
		<TR>				
			
			<TD class="labelmedium" style="padding-right:10px" width="150"><cf_tl id="Procurement Class">:</td>
			<TD width="120"><cfdiv bind="url:filterentryclass.cfm?view=#url.view#&mission={mission}" id="entryclass"></TD>
			
			<TD class="labelmedium" style="padding-left:10px;" width="120"><cf_tl id="Object Code">:</td>
			<TD width="120px"><cfdiv bind="url:filterobjectcode.cfm?view=#url.view#&mission={mission}" id="objectcode"></TD>	
				
		</TR>
				
		</table>	
	
	</td></tr>
	
	<tr><td class="line" height="1"></td></tr>
	
	<tr><td align="center">
		  <input type="button" name="filter" style="width:140px;height:26" id="filter" class="button10g" value="Search" onClick="search('#URL.view#')">
	</td></tr>
	
	<tr><td class="line" height="1"></td></tr>
	
	<tr><td height="100%">
		<cf_divscroll style="height:100%" id="mylistings"/>		
		</td>
	</tr>
	
	</TABLE>

	</form>

</td></tr>

</table>

</cfoutput>
