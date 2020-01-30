
<cf_menuscript>
<cfajaximport tags="cfmenu,cfdiv,cfwindow">

<cf_tl id="Do you want to remove this account ?" var="vPurgeAccMsg">

<cfoutput>

<script  language="javascript">
	
	function journal() {
		ptoken.navigate('JournalEdit.cfm?ID1=#URL.ID1#','contentbox1');
	}	
	
	function journal_action() {
		ptoken.navigate('JournalActionEdit.cfm?ID1=#URL.ID1#','contentbox2');
	}
	
	function costcenter() {
		ptoken.navigate('JournalCostCenter.cfm?ID1=#URL.ID1#','contentbox2');
	}
	
	function glaccount() {
		ptoken.navigate('JournalAccount/JournalAccount.cfm?ID1=#URL.ID1#','contentbox2');
	}
	
	function editJournalAccount(j,a) {
		ptoken.open('JournalAccount/JournalAccountEdit.cfm?journal='+j+'&account='+a,'journalaccount','left=250,top=100,width=1000,height=850,toolbar=no,scrollbars=no,resizable=yes');
	}
	
	function purgeJournalAccount(j,a) {
		if (confirm('#vPurgeAccMsg#')) {
			ptoken.navigate('JournalAccount/JournalAccountPurge.cfm?journal='+j+'&account='+a,'contentbox2');
		}
	}
		
</script>

<table width="100%" height="100%" cellspacing="0" cellpadding="0">

<tr><td height="30">

		<!--- top menu --->
				
		<table width="100%" border="0" align="center" cellspacing="0" cellpadding="0" class="formpadding">		  		
									
			<cfset ht = "48">
			<cfset wd = "48">			
			
			<tr>		
			
				<cfset itm = 0>
				
				<cfset itm = itm+1>			
									
				<cf_menutab item       = "#itm#" 
				            iconsrc    = "Logos/Accounting/General.png" 
							targetitem = "1"
							iconwidth  = "#wd#" 
							iconheight = "#ht#" 
							name       = "General Settings"
							class      = "highlight1"
							source 	   = "javascript:journal()">
							
				<cfset itm = itm+1>													
				<cf_menutab item       = "#itm#" 
				            iconsrc    = "Logos/Accounting/Accounts.png" 
							iconwidth  = "#wd#" 
							targetitem = "2"
							iconheight = "#ht#" 
							name       = "Accounts"
							source 	   = "javascript:glaccount()">							
							
				<cfset itm = itm+1>													
				<cf_menutab item       = "#itm#" 
				            iconsrc    = "Logos/Accounting/Actions.png" 
							iconwidth  = "#wd#" 
							targetitem = "2"
							iconheight = "#ht#" 
							name       = "Journal Actions"
							source 	   = "javascript:journal_action()">
							
						
							
				<cfset itm = itm+1>													
				<cf_menutab item       = "#itm#" 
				            iconsrc    = "Logos/Accounting/CostCenter.png" 
							iconwidth  = "#wd#" 
							targetitem = "2"
							iconheight = "#ht#" 
							name       = "Cost Center"
							source 	   = "javascript:costcenter()">			

				
														 		
				</tr>
		</table>

	</td>
 </tr>
 </cfoutput>
 
<tr><td height="1" colspan="1" class="linedotted"></td></tr>

<tr><td valign="top">
	
	<table width="100%" 
	      border="0"
		  height="100%"
		  cellspacing="0" 
		  cellpadding="0" 
		  align="center">
	 		
			<!--- <tr class="hide"><td valign="top" height="100" id="result" name="result"></td></tr> --->

			<cf_menucontainer item="1" class="regular">		
				<cfinclude template="JournalEdit.cfm">
			</cf_menucontainer>							
			
			<cf_menucontainer item="2" class="hide">
			
	</table>

</td></tr>

</table>

