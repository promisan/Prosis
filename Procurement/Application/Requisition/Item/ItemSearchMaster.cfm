<cfparam name="url.mode"    default="regular">	
<cfparam name="url.mission" default="">	
<cfparam name="url.period"  default="">	
<cfparam name="url.id"      default="">	

<cf_tl id="Item Master" var="1">

<cf_screentop label="#lt_text#" line="No" html="no" busy="busy10.gif"
   layout="webapp" close="parent.ColdFusion.Window.destroy('mymaster',true)" height="100%" jQuery="Yes" banner="gray" scroll="yes">

<cfajaximport tags="cfwindow">

<CFOUTPUT>		
	
	<script>
		
	function setvalue(val) {		    
			
			
			try {				    
				parent.selectmasapply(val);	
			} catch(e) {}
			
			parent.ProsisUI.closeWindow('mymaster')
						
		}			
		
	function recordadd(grp) {	
    	 ptoken.open("#session.root#/Procurement/Maintenance/Item/RecordAdd.cfm?mission=#url.mission#&period=#url.period#", "_blank");		 		
	}
		
	function recordedit(id1) {   
         ptoken.open("#session.root#/Procurement/Maintenance/Item/RecordEdit.cfm?menuaccess=no&mission=#url.mission#&ID1=" + id1, "_blank");		 	 
	}
	
	function GetObjects(id,item,mission,period) {
		
		itm=document.getElementById('d'+id);		
	    if (itm.className == "regular") {
			itm.className = "hide"		
		} else {
			itm.className = "regular"
			ColdFusion.navigate('ObjectResult.cfm?item='+item+'&mission='+mission+'&period='+period,'d'+id);		
		}
	}
	
	</script>

<form name="locform" id="locform" style="height:100%">

	<INPUT type="hidden" name="mission"               id="mission"                value="#url.mission#">
	<INPUT type="hidden" name="period"                id="period"                 value="#url.period#">	
	<INPUT type="hidden" name="itemmaster"            id="itemmaster"             value="#URL.flditemmaster#">

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

<table width="100%" height="100%" align="center">

<tr><td height="30">

    <table width="98%" align="center" class="formpadding">
	
	<tr class="line">
	<td colspan="3">
	
	<cfquery name="Param" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_ParameterMission
		WHERE  Mission  = '#url.Mission#'		
	</cfquery>
	
	<cfquery name="per" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT TOP 1 * 
		FROM   Ref_MissionPeriod
		WHERE  Mission  = '#url.Mission#'
		AND    Period    = '#url.period#' 
	</cfquery>	
	
	<cfquery name="SelectedItem" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT I.EntryClass, RL.ItemMaster
		FROM   RequisitionLine RL, ItemMaster I
		WHERE  RL.ItemMaster=I.Code
		AND    RL.RequisitionNo = '#URL.ID#'
	</cfquery>
	
	<!--- Query returning search results --->
	<cfquery name="EntryClass" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT * 
		FROM   Ref_EntryClass
		WHERE Code IN (
	              SELECT DISTINCT EntryClass
		          FROM   ItemMaster
			      WHERE  Operational = 1 
				  
				  <!---
		          AND    (Mission = '#url.Mission#' or Mission is NULL ) 
				  --->
		
					<cfif url.mission neq "" and url.period neq "">
					
					AND  EntryClass IN (SELECT EntryClass 
					                    FROM   Ref_ParameterMissionEntryClass 
										WHERE  Mission = '#url.Mission#'
										AND    Operational = 1 
										AND    Period  = '#url.period#')
										
										
					AND  EntryClass IN (SELECT DISTINCT EntryClass
				                        FROM   ItemMaster I, ItemMasterMission IM
							            WHERE  I.Code = IM.ItemMaster
			             			    AND    I.Operational = 1
				                        AND    IM.Mission = '#url.Mission#' 
							   )						
					</cfif>
			
					<cfif getAdministrator(url.mission) eq "0" and url.period neq "">
					
					AND EntryClass IN (SELECT DISTINCT ClassParameter 
									   FROM   Organization.dbo.OrganizationAuthorization
									   WHERE  UserAccount = '#SESSION.acc#'
									   AND    Role IN ('ProcReqEntry','ProcReqReview')
									  ) 
									  
					</cfif>		
					
					<cfif Param.FilterItemMaster eq "1">
					
					AND  ( 
					      Code IN (SELECT ItemMaster 
					                   FROM   Program.dbo.ProgramAllotmentDetail A, ItemMasterObject O
									   WHERE  A.ObjectCode = O.ObjectCode
									   AND    A.Period = '#URL.Period#'
									   AND    A.ProgramCode IN (SELECT ProgramCode 
									                          FROM   Program.dbo.Program
															  WHERE  Mission = '#url.Mission#') 
									 <cfif per.editionid neq "">					  
									  AND     A.EditionId = '#per.editionid#'		
									 </cfif>	
									 )
									 
							OR 
							
							EnforceListing = 1
							
							)		 
									 
					</cfif>	
				
			)				  
		
			ORDER BY ListingOrder 
	</cfquery>
			
		<script language="JavaScript1.1">
		
			 function selclass(row) {
			   
			   cnt = 0
			   se = document.getElementsByName('boxEntryClass')
			   rd = document.getElementsByName('EntryClass')
			   while (se[cnt]) {
			    	if (cnt == row) {
				       se[cnt].className = "highlight1"
					   rd[cnt].click()
					   _cf_loadingtexthtml='';	
					   Prosis.busy('yes')
					   ptoken.navigate('ItemSearchMasterResult.cfm?mission=#url.mission#&period=#url.period#','result','','','POST','locform')
					} else {
					   se[cnt].className = "regular"
					}
				
				cnt++
			   }	  	   
			   
			 }
		
		</script>
		
	</cfoutput>
	
	<table class="formspacing" cellspacing="0" cellpadding="0"><tr>		
	
	<cfif entryclass.recordcount gte "5">	
	
	<td style="padding-left:5px">
	
	<select class="regularxl" name="EntryClass"
	  onchange="_cf_loadingtexthtml='';Prosis.busy('yes');ptoken.navigate('ItemSearchMasterResult.cfm?<cfoutput>mission=#url.mission#&period=#url.period#</cfoutput>','result','','','POST','locform')">
	  
		<cfoutput query="EntryClass">	
		<option value="#code#"  <cfif SelectedItem.recordcount neq 0>	<cfif Code eq SelectedItem.EntryClass> selected </cfif></cfif>>#description#</option>
		</cfoutput>	
		
	</select>
	
	</td>
	
	<cfelse>
	   
	<cfoutput query="EntryClass">	
	    
	    <td onclick="selclass('#currentrow-1#')" style="height:29px;cursor: pointer;padding-right:6px;padding-left:6px;font-size:18px"
		   id="boxEntryClass" 
		   class="labelmedium <cfif SelectedItem.recordcount neq 0> <cfif Code eq SelectedItem.EntryClass>highlight1</cfif><cfelse><cfif currentrow eq "1">highlight1</cfif></cfif>" >

			<input type="radio" 		       
	           name="EntryClass" 	
               id="EntryClass"		   
		       value="#Code#" 
			   onclick="_cf_loadingtexthtml='';Prosis.busy('yes');ptoken.navigate('ItemSearchMasterResult.cfm?<cfoutput>mission=#url.mission#&period=#url.period#</cfoutput>','result','','','POST','locform')"
	 
			   <cfif SelectedItem.recordcount neq 0>
					<cfif Code eq SelectedItem.EntryClass>
						checked
					</cfif>	   
			   <cfelse>
				   <cfif currentrow eq "1">checked</cfif>
			   </cfif>>	
			   		   
		   #Description#
		
		</td>
			
	</cfoutput>	
	
	</cfif>
	
	<cfquery name="Access" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
				
			  SELECT DISTINCT Mission
		      FROM   Organization.dbo.OrganizationAuthorization
			  WHERE  UserAccount = '#SESSION.acc#'
			  AND    Role        = 'AdminProcurement'	
			  AND    Mission     = '#url.mission#'
						
	</cfquery>
	
	<cfif Access.recordcount gte "1" or getAdministrator(url.mission) eq "1">
	
		<td align="right" class="labelmedium" style="padding-left:40px;padding-right:4px">
			<a href="javascript:recordadd()"><cf_tl id="Add Item"></a>
		</td>
	
	</cfif>
	
	</tr>
	</table>
		
	</td></tr>
	
 		
	<INPUT type="hidden" name="Crit1_FieldName" id="Crit1_FieldName" value="I.Description">
	
	<INPUT type="hidden" name="Crit1_FieldType" id="Crit1_FieldType" value="CHAR">
	<TR>
	<TD class="labelmedium">&nbsp;<cf_tl id="Description"></TD>
	<TD><SELECT name="Crit1_Operator" id="Crit1_Operator" class="regularxl">
		
			<OPTION value="CONTAINS"><cfoutput>#vcontains#</cfoutput>
			<OPTION value="BEGINS_WITH"><cfoutput>#vbegins#</cfoutput>
			<OPTION value="ENDS_WITH"><cfoutput>#vends#</cfoutput>
			<OPTION value="EQUAL"><cfoutput>#vis#</cfoutput>		
			<OPTION value="NOT_EQUAL"><cfoutput>#visnot#</cfoutput>
			<OPTION value="SMALLER_THAN"><cfoutput>#vbefore#</cfoutput>
			<OPTION value="GREATER_THAN"><cfoutput>#vafter#</cfoutput>
		
		</SELECT>
	</TD>
	<TD>

    <INPUT type="text" class="regularxl" name="Crit1_Value" id="Crit1_Value" size="20">
	
	</TD>
	</TR>	
				
	<INPUT type="hidden" name="Crit2_FieldName" id="Crit2_FieldName" value="I.Code">
	
	<INPUT type="hidden" name="Crit2_FieldType" id="Crit2_FieldType" value="CHAR">
	<TR>
	<TD class="labelmedium">&nbsp;<cf_tl id="Code"></TD>
	<TD><SELECT name="Crit2_Operator" id="Crit2_Operator" class="regularxl">
		
			<OPTION value="CONTAINS"><cfoutput>#vcontains#</cfoutput>
			<OPTION value="BEGINS_WITH"><cfoutput>#vbegins#</cfoutput>
			<OPTION value="ENDS_WITH"><cfoutput>#vends#</cfoutput>
			<OPTION value="EQUAL"><cfoutput>#vis#</cfoutput>		
			<OPTION value="NOT_EQUAL"><cfoutput>#visnot#</cfoutput>
			<OPTION value="SMALLER_THAN"><cfoutput>#vbefore#</cfoutput>
			<OPTION value="GREATER_THAN"><cfoutput>#vafter#</cfoutput>
		
		</SELECT>
	</TD>
	<TD>

    <INPUT type="text" class="regularxl" name="Crit2_Value" id="Crit2_Value" size="20">
	
	</TD>
	</TR>	
	
	<!--- Field: Item.ItemColor=CHAR;20;FALSE --->
	<INPUT type="hidden" name="Crit4_FieldName" id="Crit4_FieldName" value="ObjectCode">
	
	<INPUT type="hidden" name="Crit4_FieldType" id="Crit4_FieldType" value="CHAR">
	<TR>
	<TD class="labelmedium">&nbsp;<cf_tl id="Object Code"></font>
	<TD><SELECT name="Crit4_Operator" id="Crit4_Operator" class="regularxl">
		
			<OPTION value="CONTAINS"><cfoutput>#vcontains#</cfoutput>
			<OPTION value="BEGINS_WITH"><cfoutput>#vbegins#</cfoutput>
			<OPTION value="ENDS_WITH"><cfoutput>#vends#</cfoutput>
			<OPTION value="EQUAL"><cfoutput>#vis#</cfoutput>		
			<OPTION value="NOT_EQUAL"><cfoutput>#visnot#</cfoutput>
			<OPTION value="SMALLER_THAN"><cfoutput>#vbefore#</cfoutput>
			<OPTION value="GREATER_THAN"><cfoutput>#vafter#</cfoutput>
		
		</SELECT> 
	</TD>
	<TD>
		
	<INPUT type="text" name="Crit4_Value" id="Crit4_Value" size="20" class="regularxl">
	
	</TD>
	</TR>
			
	<tr><td height="1" colspan="3" class="line"></td></tr>
	
	<tr valign="top"><td height="10" colspan="3" align="center">
	<cfoutput>
	<input class="button10g" type="button" name="OK" id="OK"    value="#vClose#" onClick="parent.ProsisUI.closeWindow('mymaster')">
	
	<input class="button10g" type="button" name"Search" id="Search" value="#vsearch#"
	onclick="Prosis.busy('yes');_cf_loadingtexthtml='';	ptoken.navigate('ItemSearchMasterResult.cfm?mode=#url.mode#&mission=#url.mission#&period=#url.period#','result','','','POST','locform')">
	</cfoutput>
	</td></tr>

	</table>	

	</TD>
</TR>	

	<!--- Query returning search results --->
	<cfquery name="Check" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  COUNT(*) as total 
	    FROM    ItemMaster
		WHERE   Operational = 1	
		AND     (Mission = '#url.Mission#' or Mission is NULL) 			
		AND     EntryClass = '#entryclass.code#'
	</cfquery>
	
<TR>
	<TD height="100%" width="100%" style="padding-left:25px;padding-right:4px">	
	
	    <cf_divscroll id="result" style="padding-right:20px">
	
		<CFIF check.total lte 100>
		
			<cfif SelectedItem.recordcount neq 0>
				 <cfset url.entryclass = SelectedItem.EntryClass>
				 <cfset url.itemmaster = SelectedItem.ItemMaster>
			<cfelse>
				 <cfset url.entryclass = entryclass.code>
				 <cfset url.itemmaster = "">
			</cfif>	 
		
			<cfinclude template="ItemSearchMasterResult.cfm">
		
		</CFIF>		
		
		</cf_divscroll>
	
	</TD>	
</TR>

</table>

</td>
</tr>

</table>

</FORM>

<cf_screenbottom layout="innerbox">
