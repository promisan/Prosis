<HTML><HEAD>
	<TITLE>Parameters - Roster Edit Form</TITLE>
</HEAD>

<cf_screentop height="100%" scroll="Yes" html="No">

<cfset Page         = "0">
<cfset add          = "0">
<cfset Header       = "Parameter">
<cfinclude template = "../HeaderRoster.cfm"> 

<cfoutput>

<cfajaximport tags="cfwindow,cfform,cfdiv">
	
<cfinclude template="ParameterInsert.cfm">

<script language="JavaScript">

	w = #CLIENT.width# - 100;
	h = #CLIENT.height# - 160;

	function process(owner,status) {	
	    ptoken.open("#SESSION.root#/Roster/Maintenance/RosterStatus/ParameterEditStep.cfm?owner=" + owner + "&status=" + status,"form"+status,"left=30, top=30, width=" + w + ", height= " + h + ", menubar=no, toolbar=no, status=yes, scrollbars=yes, resizable=no");	
	}
	
	function processrefresh(owner) {
	   _cf_loadingtexthtml='';	
	   ColdFusion.navigate('ParameterEditOwnerStatus.cfm?owner='+owner,'mysubtarget_'+owner)		
	}
		
	function deny(owner) {
	   window.open("ParameterEditOwnerGrade.cfm?owner=" + owner, "_blank");
	}
	
	function authorization(owner) {
	    window.open("ParameterEditOwnerAccess.cfm?owner=" + owner, "_blank");		
	}
	
	function authorizationrefresh(owner) {	   
		_cf_loadingtexthtml='';	
	   ColdFusion.navigate('ParameterEditOwnerStatus.cfm?owner='+owner,'mysubtarget_'+owner);
	}
	
	function checkProcessAuthorization(owner, selectedstatus) {	
	    
		try { ColdFusion.Window.destroy('mydialog',true) } catch(e) {}
		ColdFusion.Window.create('mydialog', 'Authorization', '',{x:100,y:100,height:document.body.clientHeight-50,width:document.body.clientWidth-50,modal:false,resizable:false,center:true})    			
		ColdFusion.navigate('#SESSION.root#/Roster/Maintenance/Parameter/ParameterEditOwnerView.cfm?owner=' + owner + '&selectedStatus=' + selectedstatus + '&isReadonly=1','mydialog') 		
	}
	
</script>	

</cfoutput>
 
<cfquery name="Get" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Parameter 
</cfquery>

<cfquery name="Check" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	INSERT INTO Ref_ParameterOwner (Owner)
	SELECT Code
	FROM   Organization.dbo.Ref_AuthorizationRoleOwner
	WHERE  Code NOT IN (SELECT Owner 
	                   FROM Ref_ParameterOwner)
	AND    Roster = 1				   
</cfquery>

<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="silver">
	
<tr><td height="4"></td></tr>	
<tr>
<td height="40" style="padding:4px">

	<table width="100%" style="border:0px solid silver;padding:4px" cellspacing="0" cellpadding="0" align="center">
		
	<tr><td style="padding-top:3px"><font face="Calibri" size="3" color="red"><i>Attention:</td></tr>	
	<tr><td><font face="Calibri" size="2" color="6688AA">
	Roster Settings are defined per Globally and Per Owner. <br><font color="808080">
	Change Settings <b>only</b> be changed if you are absolutely certain of their effect on the system.
	</td></tr>	
	<tr><td><font color="808080" size="2" face="Calibri">In case you have any doubt always consult your assignated focal point.</td></tr>
		
	</table>
	</td>

</tr>

<tr><td class="linedotted"></td></tr>

<cf_menuscript>


<tr>
		
	<tr><td height="30" style="padding:4px">

		<!--- top menu --->
								
		<table width="100%" border="0" cellspacing="0" cellpadding="0">		  		
						
			<cfset ht = "40">
			<cfset wd = "40">
							
			<tr>					
						
					<cf_menutab item       = "1" 
					            iconsrc    = "Logos/System/Settings.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								padding    = "2"
								width="60"
								class      = "highlight1"
								name       = "Settings"
								source     = "ParameterEditGlobal.cfm">		
								
					<cfquery name="Ownership" 
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT *
						FROM Ref_ParameterOwner
					</cfquery>
					
					<cfloop query="Ownership">
					
					<cf_menutab item       = "#currentrow+1#" 
					            iconsrc    = "Logos/Roster/Owner.png" 
								iconwidth  = "#wd#" 
								targetitem = "1"
								padding    = "2"
								width      = "60"
								iconheight = "#ht#" 
								name       = "#Owner#"
								source     = "ParameterEditOwner.cfm?owner=#owner#">							
						  								
					</cfloop>		
					
					<td width="15%"></td>
					
			</TR>
														
		</table>
			
		</td>							
	
	</tr>
	
	</td>
</tr>

<tr><td colspan="2" height="1" class="linedotted"></td></tr>

<tr><td height="100%">
   
	<cf_menucontainer item="1" class="regular">
		<cfdiv id="main" bind="url:ParameterEditGlobal.cfm">
	</cf_menucontainer>
	
</td></tr>
	
</table>

</BODY></HTML>